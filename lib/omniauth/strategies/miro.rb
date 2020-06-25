require 'omniauth-oauth'
require 'json'

module OmniAuth
  module Strategies
    class Miro < OmniAuth::Strategies::OAuth
      option :name, 'miro'

      option :client_options, {:authorize_path => '/oauth/authorize',
                               :site => 'https://miro.com',
                               :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil}

      uid { access_token.params[:user_id] }

      info do
        {
          user_type: raw_info['user']['type'],
          user_email: raw_info['user']['email'],
          user_name: raw_info['user']['name'],
          user_state: raw_info['user']['state'],
          user_id: raw_info['user']['id'],
          team_type: raw_info['team']['type'],
          team_name: raw_info['team']['name'],
          team_id: raw_info['team']['id'],
        }
      end

      extra do
        skip_info? ? {} : { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= JSON.load(access_token.get('/v1/users/me').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      alias :old_request_phase :request_phase

      def request_phase
        %w[force_login lang screen_name].each do |v|
          if request.params[v]
            options[:authorize_params][v.to_sym] = request.params[v]
          end
        end

        %w[x_auth_access_type].each do |v|
          if request.params[v]
            options[:request_params][v.to_sym] = request.params[v]
          end
        end

        if options[:use_authorize] || request.params['use_authorize'] == 'true'
          options[:client_options][:authorize_path] = '/oauth/authorize'
        else
          options[:client_options][:authorize_path] = '/oauth/authenticate'
        end

        old_request_phase
      end

      alias :old_callback_url :callback_url

      def callback_url
        if request.params['callback_url']
          request.params['callback_url']
        else
          old_callback_url
        end
      end

      def callback_path
        params = session['omniauth.params']

        if params.nil? || params['callback_url'].nil?
          super
        else
          URI(params['callback_url']).path
        end
      end
    end
  end
end
