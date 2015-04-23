require 'yaml'

class Configuration
  attr_accessor :file_methods, :file_validator
  def self.get_validator
    @file_validator = @file_validator || YAML.load_file(File.expand_path('../files/validator.yml', __FILE__))
  end

  def self.get_methods
    @file_methods = @file_methods || YAML.load_file(File.expand_path('../files/methods.yml', __FILE__))
  end
end
