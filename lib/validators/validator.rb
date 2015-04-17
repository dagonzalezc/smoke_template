require_relative './../../config/config'

module Validator
	class Validate

		def self.testing(method,hash_input)
			#Actions.set_action('createsession')
			#method_rules(method,hash_input)
			get_service(hash_input,method)
			#hash_input.inspect.to_s
		end

		def self.method_structure(method,hash_input)
			
			file_methods = Configuration.get_methods

			service = get_service(hash_input,method)

			method_dependence = nil
			method_params = {}

			if service == nil then
				method_params = file_methods['partner']['methods'][method]['params']

				if file_methods['partner']['methods'][method].has_key?('dependence') then
					method_dependence = file_methods['partner']['methods'][method]['dependence']['methods']
				end
			else
				method_params = file_methods['partner']['services'][service]['methods'][method]['params']

				if file_methods['partner']['services'][service]['methods'][method].has_key?('dependence') then
					method_dependence = file_methods['partner']['services'][service]['methods'][method]['dependence']['methods']
				end
			end

			if method_dependence != nil then
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

		def self.method_rules(method,hash_input)
			config_rules = Hash.new
			config_fields = Hash.new
			fields = Hash.new

			file_validations = Configuration.get_validator

			service = get_service(hash_input,method)

			if service == nil then
				#if file_validations['partner']['methods'][method].has_key?('rules') then
				config_rules = file_validations['partner']['methods'][method]['rules']
				config_fields = file_validations['partner']['methods'][method]['fields']
				#end
			else
				
				config_rules = file_validations['partner']['services'][service]['methods'][method]['rules']
				config_fields = file_validations['partner']['services'][service]['methods'][method]['fields']
			end
			if config_rules == nil then
				return true
			end

			request_childs = hash_input[:body][:fields]

			fields = replace_fields(request_childs,config_fields)
		
			config_rules.each do |keyrule,valuerule|
				arule = valuerule
				fields.each do |keyfield,valuefield|
					change_value=valuefield
					if valuefield.class == String then
						change_value = "'" + change_value + "'"
					end
					arule = arule.gsub(keyfield,change_value )
				end
				config_rules[keyrule] = arule
			end

			config_rules.each_value do |value|
				if !validate(value) then
					raise " not pass rule : " + value
				end
			end

			true

		end

		private


		def self.resolve_dependence(hash_dependence)
			hash_actions = Actions.get_actions
			hash_dependence.each do |key,value|
				if !hash_actions.has_key?(key)
					return key.to_s
				end
			end
			true
		end

		def self.compare_hash(hash_from, hash_to)
			hash_from.each do |from_key,from_value| 	
				if from_value.is_a?(Hash) then
					compare_hash(from_value,hash_to)
				else
				 	if !exists_key(hash_to,from_key) then
						return " Misses Parameter : " + from_key.to_s
					end
				end
			end
			true
		end

	    def self.exists_key(hash,find_key)
	    	hash_response = false
	       	hash.each do |key,value|
	       		if find_key.to_s == key.to_s then
	       			return true
	       		else
	       			if value.is_a?(Hash)
	             		hash_response=exists_key(value,find_key)
	            	end       			
	       		end
	       end
	       hash_response
	    end

		def self.replace_fields(input,fields)	
			fields.each do |key,value| 
				fields[key] = get_value_of(input,key)				
			end
			fields
		end

		def self.get_value_of(hash_input,key)
			value = nil
			if hash_input.has_key?(key) then
				return hash_input[key]
			else
				hash_input.each do |input_key,input_value|
					if input_value.is_a?(Hash) then
						value = get_value_of(input_value,key)
					end
				end
			end
			value
		end

		def self.get_service(hash_input, method)
			
			file_methods = Configuration.get_methods

			if file_methods['partner']['methods'][method].has_key?('serviceId') then
				request_childs = hash_input[:body][:fields]
				return get_value_of(request_childs,file_methods['partner']['methods'][method]['serviceId'])
			end
			nil			
		end
		
		def self.validate(rule)
			eval(rule)
		end

	end
end