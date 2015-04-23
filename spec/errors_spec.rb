require 'spec_helper'

require_relative './../errors/errors'

describe Error, focus: true do 
  # *************************** Use Method and error added in errors.yml file ***************************

  it "Find Valid Error" do
    hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "0"}}}

    error_manager = Error.new

    error_manager.add_request(hash_input)

    use_error =  error_manager.get_error(0000)

    expect(use_error).to be_instance_of Hash
    expect(use_error['code']).not_to be_nil
    expect(use_error['message']).not_to be_nil

  end

  it "Find Invalid Error" do

    hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "0"}}}

    error_manager = Error.new

    error_manager.add_request(hash_input)

    use_error =  error_manager.get_error(99)

    expect(use_error).to be_instance_of Hash        
    expect(use_error['message'].index("Not Error added to List").nil?).to be(false)

  end

  it "Find a valid Magic Number" do
    hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "0"}}}

    error_manager = Error.new

    error_manager.add_request(hash_input)

    use_error =  error_manager.get_magic(61003)

    expect(use_error).to be_instance_of Hash
    expect(use_error['code']).not_to be_nil
    expect(use_error['message']).not_to be_nil

  end

  it "Find invalid magic Number" do
    hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "0"}}}

    error_manager = Error.new

    use_error =  error_manager.get_magic('test')

    expect(use_error).to be_instance_of Hash        

    expect(use_error['message'].index("Not Magic added").nil?).to be(false)   
  end

  it "request is magic number" do
    hash_input = {:body =>{:method => "query", :fields=>{"NomEmpresa" => "enee", "operacion" => "1234", "account" => "61003"}}}

    error_manager = Error.new

    error_manager.add_request(hash_input)

    magic_request= error_manager.is_magic?(error_manager.magic_input)
    expect(is_boolean?(magic_request)).to be(true)
  end

  def is_boolean?(value)
    true if value == true || value == false rescue false
  end

end