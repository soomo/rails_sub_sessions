require 'rails_sub_sessions/middleware/get_id_from_path_info'
require 'rails_sub_sessions/middleware/sub_session_store'

module RailsSubSessions
	class Railtie < Rails::Railtie

		initializer 'rails_sub_sessions.insert_middleware' do |app|
			app.middleware.insert_before "ActionDispatch::Static", "RailsSubSessions::Middleware::GetIdFromPathInfo"
			app.middleware.insert_after  "ActiveRecord::SessionStore", "RailsSubSessions::Middleware::SubSessionStore"
		end

	end
end
