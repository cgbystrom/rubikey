require 'rubygems'
require 'sinatra'
require 'environment'
require 'json'

mime :json, "application/json"

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

error YubikeyToken::AuthError do
  e = request.env['sinatra_error']
  { :status => 'BACKEND_ERROR' }.to_json
end

error YubikeyToken::ReplayedOtp do
  { :status => 'REPLAYED_OTP' }.to_json
end

get '/verify' do
  content_type :json
  otp = params[:otp]
  yubikey = Yubikey.first(:public_id => YubikeyToken.extract_public_id(otp))
  raise YubikeyToken::AuthError, "Yubikey not found!" if yubikey.nil?
  raise "Not active" unless yubikey.active and yubikey.user.active
  raise "Token invalid" unless yubikey.token_valid?(otp)
  { :status => 'OK' }.to_json
end