class AvatarUploader < CarrierWave::Uploader::Base
  include SharedUploader

  # process optimize: [quality: 85, quiet: true]

  # 1:1
  # version :small do
    # process resize_to_fill: [200, 200]
  # end

  # version :thumb, from_version: :small do
    # process resize_to_fill: [100, 100]
  # end
end
