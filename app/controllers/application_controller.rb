class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:health_check]
  before_action :set_properties

  def set_properties
    @activate_repository = false
    @body_class = "default"
    @page_title = ""
  end
end
