require_relative './../../config/config'

module Validator
	class Validate


		def method_structure(method,hash_input)
			
			file_methods = Configuration.get_methods

			service = get_service(hash_input,method)

			method_dependence = nil
			method_params = {}

			if service.nil?
				method_params = file_methods['partner']['methods'][method]['params']

				if file_methods['partner']['methods'][method].has_key?('dependence') 
					method_dependence = file_methods['partner']['methods'][method]['dependence']['methods']
				end
			else
				method_params = file_methods['partner']['services'][service]['methods'][method]['params']

				if file_methods['partner']['services'][service]['methods'][method].has_key?('dependence') 
					method_dependence = file_methods['partner']['services'][service]['methods'][method]['dependence']['methods']
				end
			end

			if !method_dependence.nil? 
				dependence = resolve_dependence(method_dependence)
				if dependence != true					
					raise method.to_s + " Has Dependence Of : " + dependence.to_s
				end
			end

			request_childs = hash_input[:body][:fields]

			compare = compare_hash(method_params,request_childs)

			if compare != true
				 raise compare.to_s
			end

			true

		end

		def method_rules(method,hash_input)
			config_rules = Hash.new
			config_fields = Hash.new
			fields = Hash.new

			file_validations = Configuration.get_validator

			service = get_service(hash_input,method)

			if service.nil?
				config_rules = file_validations['partner']['methods'][method]['rules']
				config_fields = file_validations['partner']['methods'][method]['fields']
			else
				
				config_rules = file_validations['partner']['services'][service]['methods'][method]['rules']
				config_fields = file_validations['partner']['services'][service]['methods'][method]['fields']
			end

			if config_rules.nil? then
				return true
			end

			request_childs = hash_input[:body][:fields]

			fields = replace_fields(request_childs,config_fields)
		
			config_rules.each do |keyrule,valuerule|
				arule = valuerule
				fields.each do |keyfield,valuefield|
					change_value=valuefield
					if !is_number?(valuefield) 
						change_value = "'" + change_value + "'"
					end
					arule = arule.gsub(keyfield,change_value )
				end
				config_rules[keyrule] = arule
			end

			config_rules.each_value do |value|
				if !validate(value) 
					raise " not pass rule : " + value
				end
			end

			true

		end

		private


		def resolve_dependence(hash_dependence)
			hash_actions = Actions.get_actions
			hash_dependence.each do |key,value|
				if !hash_actions.has_key?(key)
					return key.to_s
				end
			end
			true
		end

		def compare_hash(hash_from, hash_to)
			hash_from.each do |from_key,from_value| 	
				if from_value.is_a?(Hash) 
					compare_hash(from_value,hash_to)
				else
				 	if !exists_key(hash_to,from_key) 
						return " Misses Parameter : " + from_key.to_s
					end
				end
			end
			true
		end

	    def exists_key(hash,find_key)
	    	hash_response = false
	       	hash.each do |key,value|
	       		if find_key.to_s == key.to_s
	       			return true
	       		else
	       			if value.is_a?(Hash)
	             		hash_response=exists_key(value,find_key)
	            	end       			
	       		end
	       end
	       hash_response
	    end

		def replace_fields(input,fields)	
			fields.each do |key,value| 
				fields[key] = get_value_of(input,key)				
			end
			fields
		end

		def get_value_of(hash_input,key)
			value = nil
			if hash_input.has_key?(key) 
				return hash_input[key]
			else
				hash_input.each do |input_key,input_value|
					if input_value.is_a?(Hash) 
						value = get_value_of(input_value,key)
					end
				end
			end
			value
		end

		def get_service(hash_input, method)
			
			file_methods = Configuration.get_methods

			if file_methods['partner']['methods'][method].has_key?('serviceId')
				request_childs = hash_input[:body][:fields]
				return get_value_of(request_childs,file_methods['partner']['methods'][method]['serviceId'])
			end
			nil			
		end
		
		def validate(rule)
			eval(rule)
		end

		def is_number?(value)
    		true if Float(value) rescue false
		end
	end
end