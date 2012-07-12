require 'rails_sub_sessions/middleware/get_id_from_path_info'
require 'rails_sub_sessions/middleware/sub_session_store'

module RailsSubSessions
	class Railtie < Rails::Railtie

		initializer 'rails_sub_sessions.insert_middleware' do |app|
			app.middleware.insert_before "ActionDispatch::Static", "RailsSubSessions::Middleware::GetIdFromPathInfo"

			# Flash is currently situated just after Rails session middleware.  This avoids the need to discover
			# which particular session middleware an app is using.
			app.middleware.insert_before "ActionDispatch::Flash", "RailsSubSessions::Middleware::SubSessionStore"
		end

	end
end
