class QuestionFeaturedImageUploader < CarrierWave::Uploader::Base
  include SharedUploader

  # 1:1
  version :regular do
    process optimize: [quality: 85, quiet: true]
    process resize_to_limit: [1200, nil]

    # process :add_text

    def add_text
      text = "마라톤 경기는 기원전 490년 마라톤 평원에서 벌어진 아테네와 페르시아의 전투를 기념하기 위해 만들어졌습니다.
    때문에 페르시아의 후예인 이 나라에서는 마라톤을 금지한다고 합니다. 어느 나라일까요?"
      manipulate! do |image|
        image.combine_options do |c|
          c.gravity 'Center'
          # c.pointsize '22'
          # c.draw "text 0,0 'test'"
          # c.fill 'white'

          # c.stroke '#000C'
          # c.strokewidth 2
          # c.stroke 'none'
          c.background '#0008'
          c.size '260x70'
          c.fill 'white'
          c.font "#{Rails.root}/public/fonts/NanumBarunGothic.ttf"
          c.pointsize 72
          # c.draw "gravity center \
                 # fill black  text 0,12 '#{model.text}' \
                 # fill white  text 1,11 '#{model.text}' "
          c.draw "text 25,65 '#{text}'"
          # c.fill '#000000'
        end
        image
      end
    end
  end

  version :large, from_version: :regular do
    process resize_to_fill: [800, 800]
  end
end
