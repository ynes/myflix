class Video < ActiveRecord::Base

  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(title)
    Video.where("title like ?", "%#{title}%") 
  end

  def average_rating
    if reviews.count > 0
      reviews.map(&:rating).inject{ |sum, el| sum + el }.to_f / reviews.count
    else
      0
    end
  end
end
