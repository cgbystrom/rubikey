require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Rubikey' do
  include Sinatra::Test

  before :each do
    @user = User.new({:name => 'Charlie', :email => 'charlie@example.com'})
    @user.yubikeys << Yubikey.new({
      :aes_key => '0123456789abcdef0123456789abcdef',
      :public_id => 'cbdefghijkln',
      :secret_id => 'ab1234512345',
      :counter => 41344,
      :counter_session => 243,
    })
    @user.save
  end

  specify 'should validate a Yubikey OTP successfully' do
    get '/verify?otp=cbdefghijklnbvhgbhebfuurheknkvulgtdejrljhifn'
    @response.should be_ok
    JSON.parse(@response.body)['status'].should == 'OK'
  end

  specify 'should not accept a replayed OTP' do
    get '/verify?otp=cbdefghijklnbvhgbhebfuurheknkvulgtdejrljhifn'
    get '/verify?otp=cbdefghijklnbvhgbhebfuurheknkvulgtdejrljhifn'
    @response.status.should == 500
    JSON.parse(@response.body)['status'].should == 'REPLAYED_OTP'
  end

end
