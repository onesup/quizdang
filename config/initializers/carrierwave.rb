CarrierWave.configure do |config|
  # config.asset_host = ENV['ASSET_HOST']
end

# put this in config/initializers/carrierwave.rb
module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage)
        img = yield(img) if block_given?
        img
      end
    end
  end
end
