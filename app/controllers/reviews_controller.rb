class ReviewsController < ApplicationController
  before_filter :required_user
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params.merge!(user: current_user))
   if @review.save
    redirect_to @video
   else
     @reviews = @video.reviews.reload
     render 'videos/show'
   end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def review_params
    params.require(:review).permit(:content, :user_id, :video_id, :rating)
  end
end
