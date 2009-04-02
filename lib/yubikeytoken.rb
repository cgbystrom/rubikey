require 'rubygems'
require 'crypt/rijndael'
require 'openssl'

class YubikeyToken
  attr_reader :token, :public_id, :aes_key, :secret_id, :counter, :timestamp, :counter_session,
    :random_number, :crc
  
  # Errors from the official Yubikey server
  # OK
  # BAD_OTP
  # REPLAYED_OTP
  # DELAYED_OTP
  # BAD_SIGNATURE
  # MISSING_PARAMETER
  # NO_SUCH_CLIENT
  # OPERATION_NOT_ALLOWED
  # BACKEND_ERROR
  
  class AuthError < RuntimeError; end
  class DelayedOtp < AuthError; end
  class ReplayedOtp < AuthError; end
  class BadOtp < AuthError; end
  class BadSignature < AuthError; end
  class NoSuchClient < AuthError; end
  
  def initialize(data, aes_key)
    raise "Invalid token. Token must be 34 to 64 ModHex characters." unless data =~ /^[cbdefghijklnrtuv]{32,64}$/
    raise "Invalid AES key. Key must be 32 hex characters." unless aes_key =~ /^[0-9a-fA-F]{32}$/
    
    @public_id, @token = data.unpack("a12a*")
    @aes_key = aes_key
    
    aes_key_bin = [aes_key].pack('H*')
    token_bin = modhex_decode(@token)
    decoded_token = Crypt::Rijndael.new(aes_key_bin, 128).decrypt_block(token_bin)
    
    @secret_id, @counter, @timestamp, @timestamp_lo, @counter_session, @random_number, @crc = decoded_token.unpack('H12vvCCvv')
    @timestamp += @timestamp_lo * 65536 # Extract the 3-byte integer 
    @crc_ok = crc_valid?(decoded_token)
  end
  
  def valid?
    @crc_ok
  end
  
  def self.extract_public_id(otp)
    otp.unpack("a12")
  end
  
  private
  def modhex_decode(data)
    chars = 'cbdefghijklnrtuv'
    ret = ""
    data.scan(/../).each do |c|
      ret += (chars.index(c[0]) * 16 + chars.index(c[1])).chr
    end
    ret
  end
  
  def crc_valid?(data)
    crc = 0xffff
    data.each_byte do |b|
      crc ^= b & 0xff
      8.times do
        test = (crc & 1) == 1
        crc >>= 1
        crc ^= 0x8408 if test
      end
    end
    crc == 0xf0b8
  end
end
