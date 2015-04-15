require_relative './../validators/validator'

module Methods
  class Query
    
    include Validator

    def query(hash_input)       
      #Actions.set_action("createsession")

      begin
        if Validator::Validate.method_structure('query',hash_input)  and 
          Validator::Validate.method_rules('query',hash_input) then
            Actions.set_action("query")            
            { :view => :success_procesar, :valid_action => true, :params => {:ErrorMesage => " Operation Success!"}}
        else
            { :view => :error, :valid_action => false, :params => {:ErrorMesage => ""}}
        end
      rescue Exception => e
        { :view => :error, :valid_action => false, :params => {:ErrorMesage => e.message.to_s}}       
      end
      #Validator::Validate.method_rules('query',hash_input)

    end

  end
end