require_relative './../validators/validator'

module Methods
	class Login
		
		include Validator

		def self.login (hash_input)			 
			#Actions.set_action("createsession")

			begin
				if Validator::Validate.method_structure('login',hash_input) and 
					Validator::Validate.method_rules('login',hash_input) then
						response =  { :view => :success, :valid_action => true, :params => {:ErrorMesage => " Operation Success!"}}
				else
						response =  { :view => :error, :valid_action => false, :params => {:ErrorMesage => ""}}
				end
			rescue Exception => e
				response =  { :view => :error, :valid_action => false, :params => {:ErrorMesage => e.message.to_s}}				
			end
			#Validator::Validate.testing('login',hash_input)
		end
	end
end