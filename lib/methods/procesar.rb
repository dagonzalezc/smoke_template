require_relative './../validators/validator'

module Methods
  class Procesar
    
    include Validator

    def procesar(hash_input)       
      #Actions.set_action("createsession")

      begin
        if Validator::Validate.method_structure('procesar',hash_input)  and 
          Validator::Validate.method_rules('procesar',hash_input) then
            Actions.set_action("procesar")            
            { :view => :success_procesar, :valid_action => true, :params => {:ErrorMesage => " Operation Success!"}}
        else
            { :view => :error, :valid_action => false, :params => {:ErrorMesage => ""}}
        end
      rescue Exception => e
        { :view => :error, :valid_action => false, :params => {:ErrorMesage => e.message.to_s}}       
      end
      #Validator::Validate.testing('procesar',hash_input)

    end

  end
end