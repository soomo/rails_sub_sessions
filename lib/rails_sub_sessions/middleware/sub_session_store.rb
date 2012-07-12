require 'securerandom'

module RailsSubSessions
	module Middleware
		class SubSessionStore

			def initialize(app)
				@app = app
			end

			def call(env)
				prepare!(env)
				response = @app.call(env)

				ssid = env['rack.sub_session.id']
				env['rack.session']["sub_session.#{ssid}"] = env['rack.sub_session']

				response
			end

			private

			def prepare!(env)
				if not env['rack.sub_session.id']
					env['rack.sub_session.id'] = generate_ssid(env)
				end
				ssid = env['rack.sub_session.id']
				env['rack.sub_session'] = env['rack.session']["sub_session.#{ssid}"] || {}
			end

			def generate_ssid(env)
				max_attempts = 1000
				attempts = 0
				ssid = SecureRandom.random_number(999999)
				until env['rack.session']["sub_session.#{ssid}"].nil?
					raise "Exceeded max attempts." if attempts > max_attempts
					ssid = SecureRandom.random_number(999999)
					attempts += 1
				end
				ssid
			end

		end
	end
end

