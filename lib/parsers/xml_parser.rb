
require 'active_support/core_ext/hash/conversions'

class XmlParser
  def self.get_parser(method_request)
    begin
      fields = Hash.new

      hash = Hash.from_xml(method_request.to_s)
      hash_body = get_key(hash,'Body')

      fields = hash_body.values[0]
      method_name = hash_body.keys[0]

      {:body => {:method => method_name, :fields => fields}}
    rescue
      {:body => {:method => nil, :fields => nil}}
    end
    
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