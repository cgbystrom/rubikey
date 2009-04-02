class Yubikey
  include DataMapper::Resource

  property :id, Serial
  property :public_id, String
  property :aes_key, String
  property :secret_id, String
  property :active, Boolean, :default => true
  property :remarks, Text
  property :counter, Integer
  property :counter_session, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  # TODO: Add more validations here
  validates_present :public_id
  
  belongs_to :user
  
  def token_valid?(raw_token)
    token = YubikeyToken.new(raw_token, @aes_key)
    
    counter_valid = ((token.counter > @counter) or (token.counter == @counter and token.counter_session > @counter_session))
    secret_id_valid = (not @secret_id or token.secret_id == @secret_id) 
    public_id_valid = (token.public_id == @public_id)
    valid = (token.valid? and counter_valid and secret_id_valid and public_id_valid)

    raise YubikeyToken::NoSuchClient unless public_id_valid
    raise YubikeyToken::ReplayedOtp unless counter_valid
    raise YubikeyToken::AuthError unless secret_id_valid

    if valid
      attribute_set(:secret_id, token.secret_id) if @secret_id.nil? 
      attribute_set(:counter, token.counter)
      attribute_set(:counter_session, token.counter_session)
      save
    else
      false
    end
  end
end
