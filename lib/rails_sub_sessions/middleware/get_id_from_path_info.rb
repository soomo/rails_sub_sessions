module RailsSubSessions
	module Middleware
		class GetIdFromPathInfo

			def initialize(app)
				@app = app
			end

			def call(env)
				if env['PATH_INFO'] =~ /\/ssid\/([^\/]+)(\/.*)/
					env['rack.sub_session.id'] = $1
					env['PATH_INFO'] = $2
				end
				@app.call(env)
			end

		end
	end
end
