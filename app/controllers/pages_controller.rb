class PagesController < ApplicationController
  include HighVoltage::StaticPage
  before_action :skip_authorization
end
