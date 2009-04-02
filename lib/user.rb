class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :active, Boolean, :default => true
  property :remarks, Text

  # TODO: Add more validations here

  has n, :yubikeys
end
