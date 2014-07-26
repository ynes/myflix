require 'spec_helper'

describe Category do
  it {should have_many :videos}
  it {should validate_presence_of  :name}
  describe "#recent_videos" do
    it "should retun empty array if the category doesn't have videos" do
      category = Category.create(name: "Drama")
      expect(category.recent_videos).to eq([])
    end
    it "should return the 6 recent videos ordered reverse" do
      category = Category.create(name: "Action")
      8.times.each do |t|
        Video.create(title: "title_#{t}", description: "description_#{t}", category: category)
      end
      expect(category.recent_videos.size).to eq(6)
      expect(category.recent_videos.first).to eq(Video.last)
    end
    it "should return all videos if there are less than 6" do
      category = Category.create(name: "Romance")
      4.times.each do |t|
        Video.create(title: "title_#{t}", description: "description_#{t}", category: category)
      end
      expect(category.recent_videos.size).to eq(4)
      expect(category.recent_videos.first).to eq(Video.last)
    end
    it "should only return vides of selected category" do
      category1 = Category.create(name: "Action")
      category2 = Category.create(name: "Romance")
      8.times.each do |t|
        Video.create(title: "title1_#{t}", description: "description1_#{t}", category: category1)
      end

      5.times.each do |t|
        Video.create(title: "title2_#{t}", description: "description2_#{t}", category: category2)
      end
      expect(category2.recent_videos.size).to eq(5)
      expect(category2.recent_videos.map{|v| v.category.name}.uniq).to eq(["Romance"])
    end
  end
end
