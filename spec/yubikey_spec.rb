require File.dirname(__FILE__) + '/spec_helper'

describe "A valid", YubikeyToken, "when decoded" do
  before(:each) do
     aes_key = '0123456789abcdef0123456789abcdef'
     otp = 'cbdefghijklnbvhgbhebfuurheknkvulgtdejrljhifn'
     @t = YubikeyToken.new(otp, aes_key)
  end

  it "should be valid" do
    @t.valid?.should == true
  end
  
  it "should have a public ID" do
    @t.public_id.should == 'cbdefghijkln'
  end
  
  it "should have a secret ID" do
    @t.secret_id.should == 'ab1234512345'
  end
  
  it "should have a counter" do
    @t.counter.should == 41345
  end
  
  it "should have a timestamp" do
    @t.timestamp.should == 12123456
  end
  
  it "should have a counter session" do
    @t.counter_session.should == 244
  end
  
  it "should have a random number" do
    @t.random_number.should == 32999
  end
  

end
