# ****************************** Using Owner ****************************

require_relative './../config/config'
require './lib/actions'

# ****************************** Add we Owner Created Methods ****************************

require './lib/methods/procesar'
require './lib/methods/login'
require './lib/methods/query'


module Methods

  class Manager
    
    def self.request(method_request, input_params = nil)
      
      @parsed_request = {}
      @content_type = nil
      @wsdl = nil
      @file_methods = Configuration.get_methods
      @sleep = @file_methods['partner']['environment']['sleep']

      @file_methods['partner']['endpoints'].each_value do |endpoint|
        if endpoint['url'].to_s == method_request.path_info.to_s 
          @content_type = endpoint['inputType'].downcase.to_sym
          if endpoint.has_key?('wsdl')
            @wsdl = endpoint['wsdl'].to_sym
          end         
        end
      end

      case @content_type
        when :xml         
          if input_params.has_key?('wsdl')
            if !@wsdl.nil?
              return { :view => @wsdl, :valid_action => true, :params => {:error_message => ""}}
            else
              return { :view => :error, :valid_action => true, :params => {:error_message => "Not defined wsdl to endpoint"}}
            end
          else
            require './lib/parsers/xml_parser'
            @parsed_request= XmlParser.get_parser(method_request.body.read) 
          end
        when :json      
          require './lib/parsers/json_parser'
          @parsed_request = JsonParser.get_parser(method_request.body.read)
        when :url
          require './lib/parsers/url_parser'
          @parsed_request = UrlParser.get_parser(method_request.body.read,input_params)
          
      end

      sleep(@sleep)

      if @parsed_request[:body][:method].nil?
        return { :view => :error, :valid_action => false, :params => {:error_message => "Not valid Action Request"}}
      end

      if @file_methods['partner']['methods'].has_key?(@parsed_request[:body][:method])

        Actions.update

        action= @parsed_request[:body][:method].capitalize
        obj =  Object.const_get('Methods').const_get(action.to_s).new

        response = obj.send(@parsed_request[:body][:method].downcase,@parsed_request)
        
        if response[:valid_action] == true
          Actions.add(action.downcase)
        end

        response
      else
        { :view => :error, :valid_action => false, :params => {:error_message => "Not Added method"}} 
      end

    end

  end
end