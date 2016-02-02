# == Schema Information
#
# Table name: quizzes
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  description    :text(65535)
#  featured_image :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

class QuizzesController < ApplicationController
  def show
    @quiz = Quiz.find(params[:id])
  end
end
