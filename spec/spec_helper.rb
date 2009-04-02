require 'rubygems'
require 'sinatra'
require 'spec'
require 'spec/interop/test'
require 'sinatra/test'
require 'json'

# Set test environment
set :environment, :test
set :run, false
set :raise_errors, false
set :logging, false

require 'application'
require 'yubikeytoken'

# Establish in-memory database for testing
DataMapper.setup(:default, "sqlite3::memory:")

Spec::Runner.configure do |config|
  # Reset database before each example is run
  config.before(:each) { DataMapper.auto_migrate! }
end

def generate_aes_key
  c = '0123456789abcdef'
  (0..32).collect { c[Kernel.rand(c.length)] }.join
end

def generate_public_id
  c = 'cbdefghijklnrtuv'
  (0..12).collect { c[Kernel.rand(c.length)] }.join
end