class Admin::VideosController < ApplicationController
  before_filter :required_user
  before_filter :required_admin

  def new
    @video = Video.new
  end

  private

  def required_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that"
      redirect_to home_path unless current_user.admin?
    end
  end

end
