namespace :app do
  namespace :photos do
    # run this on a cron every 1 day
    desc 'download unsplash image'
    task download_unsplash_image: :environment do
      25.times do
        unsplash_photo = Unsplash::Photo.random
        Photo.where(unique_id: unsplash_photo.id).first_or_create!(
          source: 'unsplash',
          remote_image_url: unsplash_photo.urls['regular'].sub('w=1080', 'w=1920')
        )
      end

      multiple = 5
      per_page = 30
      multiple.times do |count|
        unsplash_photos = Unsplash::Photo.all(page = count + 1, per_page = per_page)
        unsplash_photos.each do |unsplash_photo|
          Photo.where(unique_id: unsplash_photo.id).first_or_create!(
            source: 'unsplash',
            remote_image_url: unsplash_photo.urls['regular'].sub('w=1080', 'w=1920')
          )
        end
      end
    end

    desc 'download pixabay image'
    task download_pixabay_image: :environment do
      multiple = 2
      per_page = 60

      multiple.times do |count|
        pixabay_photos = Pixabay.new.photos(
          response_group: 'high_resolution', lang: 'ko', image_type: 'photo',
          editors_choice: true, safesearch: true,
          page: count + 1, per_page: per_page
        )
        pixabay_photos['hits'].each do |pixabay_photo|
          Photo.where(unique_id: pixabay_photo['id_hash']).first_or_create!(
            source: 'pixabay',
            remote_image_url: pixabay_photo['fullHDURL']
          )
        end
      end
    end
  end
end
