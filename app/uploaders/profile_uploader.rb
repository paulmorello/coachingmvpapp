class ProfileUploader < CarrierWave::Uploader::Base
  storage :fog
end
