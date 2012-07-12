if Rails::VERSION::MAJOR == 3 && [0,1].include?(Rails::VERSION::MINOR) # Rails 3.0.x and 3.1.x

	require 'action_controller/metal'

	module ActionController
		class Metal
			delegate :sub_session, :sub_session_id, :to => :@_request
		end
	end

	require 'action_controller/metal/url_for'

	module ActionController
		module UrlFor

			def url_for(options = nil)
				options ||= {}

				if self.sub_session_id
					if options.is_a?(Hash)
						options[:sub_session_id] = self.sub_session_id unless options[:host] && options[:host] != self.request.host
					elsif options.is_a?(Array)
						options.push({sub_session_id: self.sub_session_id})
					end
				end

				super(options)
			end

		end
	end

	require 'action_view/helpers'
	require 'action_view/helpers/url_helper'

	module ActionView
		module Helpers
			module UrlHelper

				def url_for_with_sub_session_for_action_view(options = {})
					options ||= {}
					if controller.sub_session_id
						if options.is_a?(Hash)
							options[:sub_session_id] = controller.sub_session_id
						elsif options.is_a?(Array)
							options.push({sub_session_id: controller.sub_session_id})
						end
					end
					url_for_without_sub_session_for_action_view(options)
				end

				alias_method_chain :url_for, :sub_session_for_action_view

			end
		end
	end

	require 'action_dispatch/routing/url_for'
	require 'uri'

	module ActionDispatch
		module Routing
			module UrlFor

				def url_for_with_sub_session(options = nil)

					sub_session_id = nil
					if options.is_a?(Hash)
						sub_session_id = options.delete(:sub_session_id)
					elsif options.is_a?(Array)
						if options[-1].is_a?(Hash) && options[-1].has_key?(:sub_session_id)
							sub_session_id = options.pop()[:sub_session_id]
						end
					end

					url = url_for_without_sub_session(options)

					if sub_session_id
						if url[0] == '/'
							prepend_path_with_subsession_id(url, sub_session_id)
						else
							uri = URI(url)
							uri.path = prepend_path_with_subsession_id(uri.path, sub_session_id)
							url = uri.to_s
						end
					end

					url
				end

				def prepend_path_with_subsession_id(path, sub_session_id)
					path.insert(0, "/ssid/#{sub_session_id}")
				end

				alias_method_chain :url_for, :sub_session
			end
		end
	end

else
	raise "RailsSubSessions only supports Rails 3.0.x and Rails 3.1.x"
end
