require 'spec_helper'
require 'yaml'

describe "Files Configuration", focus: true do

  let(:root)   {File.expand_path('../../', __FILE__)}
  let(:config) {File.open(root + '/config/files/methods.yml')}
  let(:config_validator) {File.open(root + '/config/files/validator.yml')}
  let(:config_error) {File.open(root + '/errors/errors.yml')}

  let(:method) {YAML::load(config)}
  let(:validator) {YAML::load(config_validator)}
  let(:error) {YAML::load(config_error)}

  describe "Exists Configuration files" do
    it "must load validator File" do    
      expect(validator).not_to be_nil
    end

    it "must load methods File" do
      expect(method).not_to be_nil
    end

    it "must load Errors File" do
      expect(error).not_to be nil
    end
  end
  
  describe "Configuration Files" do

    describe "methods Configuration" do

      it "should be defined root" do
        expect(method['partner']['methods']).not_to be nil
      end

      it "define optional parameters to method" do
        if !method['partner']['methods'].nil?
          method['partner']['methods'].each_value do |a_method|
            expect(a_method.has_key?('params')).to eq(true)
            if a_method.has_key?('dependence')
              expect(a_method['dependence'].has_key?('methods')).to eq(true)
            end             
          end
        end
      end

      it  "define services" do
        if !method['partner']['services'].nil?
          method['partner']['services'].each_value do |a_service|
            expect(a_service.has_key?('methods')).to eq(true)
          end
        end
      end

      it "structure of methods by services" do
        if !method['partner']['services'].nil?
          method['partner']['services'].each_value do |a_service|
            if a_service.has_key?('methods')
              a_service['methods'].each_value do |a_service_method|
                expect(a_service_method.has_key?('params')).to eq(true)
                if a_service_method.has_key?('dependence')
                  expect(a_service_method['dependence'].has_key?('methods')).to eq(true)
                end 
              end
            end
          end
        end
      end

      it "End Points definition" do
        expect(method['partner'].has_key?('endpoints')).to eq(true)

        method['partner']['endpoints'].each_value do |endpoint|
          expect(endpoint.has_key?('url')).to eq(true)
          expect(endpoint.has_key?('inputType')).to eq(true)
          expect(endpoint['url']).not_to be nil
          expect(endpoint['url']).not_to be_empty
          expect(["xml","json","url"]).to include(endpoint['inputType'].to_s)
          case endpoint['inputType'].to_sym
            when :json , :url
              expect(endpoint.has_key?('methodId')).to eq(true)
          end
            
        end

      end

    end

    describe "validator Configuration" do

      it "methods validation" do
        expect(validator['partner'].has_key?('methods')).to eq(true)
        if !validator['partner']['methods'].nil?
          validator['partner']['methods'].each_value do |a_method|
            expect(a_method.has_key?('rules')).to eq(true)

            if !a_method['rules'].nil? 
              expect(a_method.has_key?('fields')).to eq(true)
            end
          end
        end
      end

      it "service Structure" do
        expect(validator['partner']['services']).not_to be_nil
        validator['partner']['services'].each_value do |a_service|
          expect(a_service['methods']).not_to be_nil
          a_service['methods'].each_value do |a_service_method|
            expect(a_service_method.has_key?('rules')).to eq(true)
            if !a_service_method['rules'].nil? 
              expect(a_service_method.has_key?('fields')).to eq(true)
            end
          end
        end

      end

    end

    describe "Errors Configuration" do

      it "method structure" do
          expect(error['partner']['methods']).not_to be_nil
          error['partner']['methods'].each_value do |a_method|
            expect(a_method['errors']).not_to be_nil

            expect(a_method['errors']['lists']).not_to be_nil

            a_method['errors']['lists'].each_value do |a_list|
              if !a_list.nil?
                a_list.each_value do |a_error|
                  expect(a_error['code']).not_to be_nil
                  expect(a_error['message']).not_to be_nil                  
                end
              end
            end

            if !a_method['errors']['magics'].nil?
              a_method['errors']['magics'].each_value do |a_magic|
                expect(a_magic['number']).not_to be_nil
                magic_error = a_magic.values[1]
                expect(magic_error).to be_instance_of Hash
                expect(magic_error['code']).not_to be_nil
                expect(magic_error['message']).not_to be_nil
              end
            end

          end          
      end
    end

  end
  
end
