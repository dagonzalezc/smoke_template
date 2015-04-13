require_relative './../../config/config'

module Validator
	class Validate
		def self.testing
			Actions.set_action('login')
		end

		def self.resolve_dependence(hash_dependence)
			hash_actions = Actions.get_actions
			hash_dependence.each do |key,value|
				if !hash_actions.has_key?(key)
					return key.to_s
			end
			true
		end

		def self.method_structure(method,service_request)
			
			file_methods = Configuration.get_methods

			service = get_service(service_request,method)

			if service? == nil then
				method_params = file_methods['common']['methods'][method]['params']
				if file_methods['common']['methods'][method].has_key?('dependence')
					method_dependence = file_methods['common']['methods'][method]['dependence']
			else
				method_params = file_methods['services'][service]['methods'][method]['params']
				if file_methods['services'][service]['methods'][method].has_key?(dependence)
					method_dependence = file_methods['services'][service]['methods'][method]['dependence']
			end

			if method_dependence?
				dependence = resolve_dependence(method_dependence)
				if dependence != true
					return method.to_s + " has dependence of : " + dependence.to_s
				end
			end


			request_childs = service_request.xpath("//#{method}//child::*")[0]
			
			compare_elements(method_params,request_childs)

			true

		end

		def self.compare_elements(hash_from, hash_to)
			method_params.each do |key,value| 
				
				exists = false

				request_childs.element_children.each do |element|
					if element.name.to_s == key.to_s then
						exists = true
						break
					end
				end

				if !exists
					return " Misses Parameter : " + key.to_s
				end
			end

		end

		def self.method_rules(method,service_request)

			file_validations = Configuration.get_validator

			service = get_service(service_request,method)

			if service == nil then
				config_rules = file_validations['common']['methods'][method]['rules']
				config_fields = file_validations['common']['methods'][method]['fields']
			else
				config_rules = file_validations['services'][service]['methods'][method]['rules']
				config_fields = file_validations['services'][service]['methods'][method]['fields']
			end

			request_childs = service_request.xpath("//#{method}//child::*")[0]

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
					return false
				end
			end

			true

		end

		private


		def self.replace_fields(input,fields)	
			fields.each do |key,value| 
				input.element_children.each do |element|
					if element.name.to_s == key.to_s then
						fields[key] = element.text
						break
					end
				end
			end
			fields
		end

		def self.get_service(service_request, method)

			file_methods = Configuration.get_methods
			param = file_methods['common']['methodparam'][method]

			if param != nil then
				request_childs = service_request.xpath("//#{method}//child::*")[0]

				request_childs.element_children.each do |element|
					if element.name.to_s == param.to_s then
						return element.text						
					end
				end
			end
			nil
		end
		
		def self.validate(rule)
			eval(rule)
		end

	end
end