require 'spec_helper'
require_relative './../lib/parsers/xml_parser'      
require_relative './../lib/parsers/url_parser'      
require_relative './../lib/parsers/json_parser'     

describe "Parsers Request", focus: true do 
  describe XmlParser do

    it "xml parser good request " do
      input_request = "<Envelope><Body><login><loginRequest>
                                    <sessionid>KE5R1CNMYKHAAQ4C0119</sessionid>    
                                    <initiator>20150001</initiator>
                                    <pin>325F9DFC430CA0ED7DEC36A262479623E603635D</pin>
                                 </loginRequest></login></Body></Envelope>"

      hash_out = XmlParser.get_parser(input_request) 
      expect(hash_out[:body][:method]).not_to be_nil
      expect(hash_out[:body][:fields]).not_to be_nil

    end
      it "Xml no Parameters" do
        input_request = ""

        hash_out = XmlParser.get_parser(input_request) 
        expect(hash_out[:body][:method]).to be_nil
        expect(hash_out[:body][:fields]).to be_nil
      end
      it "Xml Bad request" do
        input_request = "<Envelope><Body><login><loginequest>
                                 </loginRequest></login></Body></Envelope>"

        hash_out = XmlParser.get_parser(input_request) 
        expect(hash_out[:body][:method]).to be_nil
        expect(hash_out[:body][:fields]).to be_nil
      end

  end

  describe JsonParser do
    it "Json good request" do
      input_request = '{"method": "query",
      "operacion": "ConNor",
      "ModBusqueda": "20",
      "NumMaxSaldos": "1",
      "Aviso": "xoom",
      "NomEmpresa": "enee",
      "NumServicio": "1",
      "IdentificadorS1": 
      "0001951"}'

      hash_out = hash = JsonParser.get_parser(input_request)
      expect(hash_out[:body][:method]).not_to be_nil
      expect(hash_out[:body][:fields]).not_to be_nil

    end

    it "Json no Parameters" do
      input_request = "{}"
        hash_out = XmlParser.get_parser(input_request) 
        expect(hash_out[:body][:method]).to be_nil
        expect(hash_out[:body][:fields]).to be_nil      
      end

      it "Json Bad request" do

        input_request = '{"method": "query",
        "operacion" "ConNor",
        "ModBusqueda": "20",
        "NumMaxSaldos": "1",
        "Aviso": "xoom",
        "NomEmpresa": "enee",
        "NumServicio": "1",
        "IdentificadorS1": 
        "0001951"}'

        hash_out = hash = JsonParser.get_parser(input_request)
        expect(hash_out[:body][:method]).to be_nil
        expect(hash_out[:body][:fields]).to be_nil
    end
   end

  describe UrlParser do
    it "Urls good request" do
      parameters = {"NomEmpresa" =>"enee", "method" => "query", "operacion" => "1234"}
      hash_out = hash = UrlParser.get_parser("",parameters)
      expect(hash_out[:body][:method]).not_to be_nil
      expect(hash_out[:body][:fields]).not_to be_nil
    end

    it "Url No Parameters" do
      parameters = {}
      hash_out = hash = UrlParser.get_parser("",parameters)
      expect(hash_out[:body][:method]).to be_nil
      expect(hash_out[:body][:fields]).to be_nil
    end
   end
end


