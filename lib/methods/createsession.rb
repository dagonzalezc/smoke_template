require_relative './../validators/validator'

module Methods
  class Createsession
    
    include Validator

    def createsession(hash_input)       
      #Actions.set_action("createsession")

      begin
        if Validator::Validate.method_structure('createsession',hash_input)  and 
          Validator::Validate.method_rules('createsession',hash_input) then
            Actions.set_action("createsession")            
            { :view => :success_procesar, :valid_action => true, :params => {:error_message => " Operation Success!"}}
        else
            { :view => :error, :valid_action => false, :params => {:error_message => ""}}
        end
      rescue Exception => e
        { :view => :error, :valid_action => false, :params => {:error_message => e.message.to_s}}       
      end
      #Validator::Validate.method_rules('query',hash_input)

    end

  end
end