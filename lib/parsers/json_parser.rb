require 'json'

class JsonParser
	def self.get_parser(method_request)
    parser = Hash.new
    fields = Hash.new
    hash = JSON.parse(method_request.read)

    param_method = nil

    file_methods = Configuration.get_methods

    file_methods['partner']['endpoints'].each_value do |endpoint|
      if endpoint.has_key?('methodId') then
        param_method = endpoint['methodId']
      end
    end

    method_name = hash[param_method]
    fields = hash
    fields.delete(param_method)

	  {:body => {:method => method_name, :fields => fields}}

	end
 end