require 'sinatra'
require 'rack/test'
require 'rspec'


RSpec.configure do |config|
  
  config.color = true
  config.formatter     = 'documentation'
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.alias_it_should_behave_like_to :it_implements, 'implements:'

end