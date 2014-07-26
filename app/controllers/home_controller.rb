class HomeController < ApplicationController
  before_filter :required_user
  
  def index
    @categories = Category.all
  end
end
