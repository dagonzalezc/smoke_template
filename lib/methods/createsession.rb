require 'securerandom'

module Methods
	class Token 
		attr_accessor :token_id, :timeout, :logged
		def initialize()
			@sessionid = SecureRandom.urlsafe_base64(nil, false)[0,20].upcase
			@start_time = Time.now
			@logged = true
			@timeout = 60
		end

		def self.create
			@sessionid = SecureRandom.urlsafe_base64(nil, false)[0,20].upcase
			@timeout = Time.now
			@logged = false
		end
		def set_loggin(value=false)
			@logged = value
		end
		def valid?
			(@start_time - Time.now) < @timeout and @logged
		end
	end
end
