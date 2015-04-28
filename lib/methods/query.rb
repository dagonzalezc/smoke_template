require_relative './../validators/validator'
require_relative './../../errors/errors'

require_relative './../faker/faker'

module Methods
  class Query
    
    include Validator

    def initialize      
      @error_manager = Error.new
      @validate = Validator::Validate.new
      @names = Faker::Name.new
      @names.language = 'es'
      @address= Faker::Address.new
      @address.language = 'es'
      @amounts = Faker::Amount.new
      @amounts.limit = 999
    end

    def query(hash_input)       

      response = {  :view => nil , 
                    :valid_action => false, 
                    :params => {
                      :error_message => nil
                    }
                  }

      result_structure = @validate.method_structure(hash_input)

      if result_structure == true
        @error_manager.add_request(hash_input)
        magic_input = @error_manager.magic_input
        if !magic_input.nil?
          if @error_manager.is_magic?(magic_input)   
            use_error = @error_manager.get_magic(magic_input)
            response[:params][:error_message] = use_error['message']
            response[:view] = :error
            return response
          end
        end

        result_rules = @validate.method_rules(hash_input)

        if result_rules == true

          use_error =  @error_manager.get_error(0000)
          
          response[:view] = :success_procesar
          response[:valid_action] = true
          response[:params][:error_message] = use_error['message']
          response[:params][:client_name] = @names.get_name.to_s
          response[:params][:client_address] = @address.get_address.to_s
          response[:params][:client_amount] = @amounts.get_amount.to_s
        else
          response[:view] = :error
          response[:params][:error_message] = result_rules.to_s             
        end
      else
        response[:view] = :error
        response[:params][:error_message] = result_structure.to_s
      end
      response
    end
  end
end



