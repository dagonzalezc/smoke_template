
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

  private 
  
  def clean_return xml
    regex = /<return><!\[CDATA\[(.*)\]\]><\/return>/
      if regex =~ xml
        xml.gsub(regex) do |capture|
            "<return>#{capture}</return>"
        end
      else
        xml
      end
  end

end