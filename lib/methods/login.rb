require_relative './../validators/validator'
require_relative './../../errors/errors'


module Methods
	class Login
		
		include Validator

		def login (hash_input)			 
	      error_manager = Error.new

	      response = {  :view => nil , 
	                    :valid_action => false, 
	                    :params => {
	                      :error_message => nil
	                    }
	                  }

	      error_manager.add_request(hash_input)

	      begin
	        if Validator::Validate.method_structure('login',hash_input)
	            magic_input = error_manager.magic_input
	            if !magic_input.nil?
	              if error_manager.is_magic?(magic_input)   
	                use_error = error_manager.get_error(magic_input,true)
	                response[:params][:error_message] = use_error['message']
	                response[:valid_action] = true
	                response[:view] = :error
	                return response
	            end
	          end
	          if Validator::Validate.method_rules('login',hash_input)

	            Actions.set_action("login")

	            use_error =  error_manager.get_error(0000,false)

	            response[:view] = :success_procesar
	            response[:valid_action] = true
	            response[:params][:error_message] = use_error['message']
	          end

	        end
	      rescue Exception => e
	            response[:view] = :error
	            response[:valid_action] = false
	            response[:params][:error_message] = e.message.to_s
	      end

	      response

		end
	end
end