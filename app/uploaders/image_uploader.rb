class ImageUploader < CarrierWave::Uploader::Base
  include SharedUploader

  version :regular do
    process optimize: [quality: 85, quiet: true]
    process resize_to_limit: [1080, nil]
  end

  # 1:1
  version :large, from_version: :regular do
    process resize_to_fill: [640, 640]
  end

  version :small, from_version: :large do
    process resize_to_fill: [320, 320]
  end

  version :thumb, from_version: :small do
    process resize_to_fill: [160, 160]
  end

  def filename
    original_filename.sub('_1920', '') if original_filename
  end
end
