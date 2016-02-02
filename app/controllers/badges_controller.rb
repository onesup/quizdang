# == Schema Information
#
# Table name: badges
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text(65535)      not null
#  slug        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  kind        :integer          not null
#  level       :integer          not null
#  active      :boolean          default(FALSE), not null
#

class BadgesController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]

  def index
    @badges = Badge.by_count.actived
  end

  def show
    @badge = Badge.friendly.find(params[:id])
    @questions = @badge.questions.desc_by_id
      .includes(:photo, :reputations).page(params[:page])
  end
end
