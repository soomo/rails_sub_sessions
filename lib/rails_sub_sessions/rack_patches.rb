require 'rack/request'

module Rack
	class Request
		def sub_session;    @env['rack.sub_session'];    end
		def sub_session_id; @env['rack.sub_session.id']; end
	end
end
