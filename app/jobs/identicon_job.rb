class IdenticonJob
  include Sidekiq::Worker

  def perform(user)
    # blob = RubyIdenticon.create(user.username, background_color: 0xecececec)
    blob = RubyIdenticon.create(user.username)
    user.avatar = CarrierwaveStringIO.new("#{Digest::MD5.hexdigest(user.username)}.png", blob)
    user.save!
  end
end
