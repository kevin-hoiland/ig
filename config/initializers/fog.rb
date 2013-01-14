#require 'carrierwave'

CarrierWave.configure do |config|
#  config.storage = :fog
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => 'AKIAJS5OBUQYNQXDPPSA',
    :aws_secret_access_key => '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'
#    :region => 'us-east-1'
  }
  config.fog_directory  = 'gums' # ENV['S3_BUCKET']
  # config.fog_public     = false 
end