require_relative './../validators/validator'
require_relative './../../errors/errors'


module Methods
	class Login
		
		include Validator

		def login (hash_input)			 

	      error_manager = Error.new

	      validate = Validator::Validate.new

	      response = {  :view => nil , 
	                    :valid_action => false, 
	                    :params => {
	                      :error_message => nil
	                    }
	                  }

	      error_manager.add_request(hash_input)
	      result_structure = validate.method_structure(hash_input)
	        if result_structure == true
	            magic_input = error_manager.magic_input
	            if !magic_input.nil?
	              if error_manager.is_magic?(magic_input)   
		                use_error = error_manager.get_magic(magic_input)
		                response[:params][:error_message] = use_error['message']
		                response[:valid_action] = true
		                response[:view] = :error
		                return response
	            	end
	          	end
	          	result_rules = validate.method_rules(hash_input)
	          	if result_rules == true

		            Actions.add("login")

		            use_error =  error_manager.get_error(0000)

		            response[:view] = :success_procesar
		            response[:valid_action] = true
		            response[:params][:error_message] = use_error['message']
	        	else
		            response[:view] = :error
		            response[:valid_action] = true
	    	        response[:params][:error_message] = result_rules.to_s	        		
	        	end
	        else
	            response[:view] = :error
	            response[:valid_action] = true
	            response[:params][:error_message] = result_structure.to_s
	        end

	      	response

		end
	end
end