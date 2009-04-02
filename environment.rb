require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Rubikey',
                 :author => 'Carl Bystrom',
                 :url_base => 'http://localhost:4567/'
               )

  DataMapper.setup(:default, "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db")

  # Load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
