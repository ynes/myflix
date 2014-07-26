class Review < ActiveRecord::Base
  default_scope { order('created_at desc') } 
  belongs_to :video
  belongs_to :user

  validates_presence_of :video_id, :user_id, :content, :rating
end
