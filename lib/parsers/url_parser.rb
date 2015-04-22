require_relative './../../config/config'

class UrlParser
	def self.get_parser(method_request,input_params)
		begin 
			fields = Hash.new
			if input_params.nil? || input_params.empty?
				return {:body => {:method => nil, :fields => nil}}
			end
			param_method = nil

			file_methods = Configuration.get_methods

			file_methods['partner']['endpoints'].each_value do |endpoint|
				if endpoint.has_key?('methodId') then
					param_method = endpoint['methodId']
				end
			end

			method_name = input_params[param_method]
			fields = input_params
			fields.delete(param_method)

			{:body => {:method => method_name, :fields => fields}}
		rescue
			{:body => {:method => nil, :fields => nil}}
		end
		
	end
end