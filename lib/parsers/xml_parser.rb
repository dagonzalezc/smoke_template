
require 'active_support/core_ext/hash/conversions'

class XmlParser
	def self.get_parser(method_request)

		parser = Hash.new
		fields = Hash.new

		hash = Hash.from_xml(method_request.read.to_s)
		hash_body = get_key(hash,'Body')

		fields = hash_body.values[0]
		method_name = hash_body.keys[0]


		parser = {:body => {:method => method_name, :fields => fields}}
		
		parser

	end

    def self.get_key(hash,find_key)
    	hash_response = {}
       	hash.map do |key,value|
       		if find_key.to_s == key.to_s then
       			return value
       		else
       			if value.is_a?(Hash)
             		hash_response=get_key(value,find_key)
            	end       			
       		end

       end
       hash_response
    end
end