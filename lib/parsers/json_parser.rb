require 'json'

class JsonParser
	def self.get_parser(method_request, input_params)
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

    method_name = input_params[param_method]
    fields = input_params
    fields.delete(method_name)

	 {:body => {:method => method_name, :fields => fields}}
			
	end

  def self.get_key(hash,find_key)
  	hash_response = {}
  	if hash.has_key?(find_key) then
  		return hash[find_key]
  	else
  		hash.each_value do |value|
  			if value.is_a?(Hash) then
  				hash_response=get_key(value,find_key)
  			end
  		end
  	end  	
    hash_response
  end

 end