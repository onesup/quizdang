# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def create_users
  User.create_with_identicon!(name: '퀴즈당', username: 'quizdang', password: Devise.friendly_token).add_role(:admin)
  User.create_with_identicon!(name: 'lim', username: 'lim', password: Devise.friendly_token)
end

def create_badges
  data = YAML::load_file(File.expand_path('../badge.yml', __FILE__))
  data.each do |key, value|
    value.each do |badge|
      Badge.create!(kind: key,
                    name: badge['name'],
                    description: badge['description'],
                    level: badge['level'] || 'gold',
                    active: badge['active'] || false)
    end
  end
end

def create_hashtags
  hashtags = YAML::load_file(File.expand_path('../hashtag.yml', __FILE__))
  hashtags.each do |data|
    hashtag = Hashtag.create!(name: data['name'], user: User.admins.sample)
    data['children'].try(:each) do |subdata|
      hashtag.children.create!(name: subdata['name'], user: User.admins.sample)
    end
  end
end

def create_subdangs
  subdangs = YAML::load_file(File.expand_path('../subdang.yml', __FILE__))
  subdangs.each do |data|
    subdang = Subdang.create!(name: data['name'], remote_featured_image_url: data['featured_image'], user: User.admins.sample)
    data['children'].try(:each) do |subdata|
      subdang.children.create!(name: subdata['name'], remote_featured_image_url: subdata['featured_image'], user: User.admins.sample)
    end
  end
end

def create_pixabay_photos
  multiple = Rails.env.development? ? 1 : 2
  per_page = Rails.env.development? ? 3 : 60

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

def create_unsplash_photos
  multiple = Rails.env.development? ? 1 : 10
  per_page = Rails.env.development? ? 2 : 30

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

def create_questions(filename)
  data = YAML::load_file(File.expand_path("../#{filename}", __FILE__))

  data.each do |key, value|
    value.each do |question|
      if filename == 'question_extra.yml'
        user = User.not_admins.sample
      else
        user = User.admins.sample
      end

      @question = Question.new(
        status: 'active',
        question_type: key,
        text: question['text'],
        photo: Photo.all.sample,
        user: user
      )

      if question['subdang'].present?
        @question.subdang = Subdang.find_by!(name: question['subdang'])
      end

      question['options'].each do |option|
        @question.options.build(
          text: option['text'],
          correct: option['correct'] || false
        )
      end
      @question.save!

      if filename == 'question_extra.yml'
        @question.hashtaggings.create!(hashtag: Hashtag.find_by(name: '1대100'))
      end

      # early generate reputation
      @question.reputation_for(:votes)
    end
  end
end

def create_dummy_users
  5.times do
    User.create_with_identicon!(
      name: "#{Faker::Name.last_name}#{Faker::Name.first_name}",
      username: Faker::Internet.user_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
  end
end

def create_participants
  Question.all.each do |question|
    option = question.options.sample
    user = User.all.sample
    participant = question.participants.create!(option: option, user: user)
    if participant.correct?
      user.add_evaluation(:participant_points, 1, question)
    end
  end
end

def create_answers
  Question.all.each do |question|
    user = User.all.sample
    answer = question.answers.create!(user: user, text: Faker::Lorem::sentence)
    vote_type = [:upvotes, :downvotes].sample

    case vote_type
    when :upvotes
      answer.add_or_update_evaluation(vote_type, 1, user)
    when :downvotes
      answer.add_or_update_evaluation(vote_type, -1, user)
    end
  end
end

def create_comments
  Question.all.each do |question|
    user = User.all.sample
    comment = question.comments.create!(user: user, text: Faker::Lorem::sentence)
    comment.add_or_update_evaluation(:votes, 1, user)
  end
end

def create_badgings
  Question.all.each do |question|
    question.badgings.create!(badge: Badge.actived.question.sample)
  end

  User.all.each do |user|
    user.badgings.create!(badge: Badge.actived.moderation.sample)
  end
end

def create_question_votes
  Question.all.each do |question|
    user = User.all.sample
    vote_type = [:upvotes, :downvotes].sample

    case vote_type
    when :upvotes
      question.add_or_update_evaluation(vote_type, 1, user)
    when :downvotes
      question.add_or_update_evaluation(vote_type, -1, user)
    end
  end
end

create_users
create_badges
create_hashtags
create_subdangs
# create_pixabay_photos
create_unsplash_photos
create_questions('question.yml')

if Rails.env.development?
  create_dummy_users
  create_questions('question_extra.yml')
  create_participants
  create_answers
  create_comments
  create_badgings
  create_question_votes
end
