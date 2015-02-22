require 'spec_helper'

describe Video do
  it { should belong_to :category }
  it { should validate_presence_of :title  }
  it { should validate_presence_of :description }
  it "should return an empty array when search by title and can't find any match" do
    results = Video.search_by_title("video1")
    expect(results).to eq([])
  end
  it "should return a single video when the search match with the title" do
    Video.create(title: "video1", description: "test description", category_id: 1)
    results = Video.search_by_title("video1")
    expect(results.size).to eq(1)
  end
  it "should return multiple vides if the partial title match with multiple videos" do
    Video.create(title: "the video1", description: "test description", category_id: 1)
    Video.create(title: "other video2", description: "test description", category_id: 1)
    Video.create(title: "test video3", description: "test description", category_id: 1)
    Video.create(title: "video", description: "test description", category_id: 1)
    results = Video.search_by_title("video")
    expect(results.size).to be > 1
  end
   it "should calculate the average rating of the reviews" do
     video = Fabricate(:video)
     review1 = Fabricate(:review, video: video, rating: 3, user: Fabricate(:user)) 
     review2 = Fabricate(:review, video: video, rating: 2, user: Fabricate(:user)) 
     average = video.average_rating
     expect(average).to be 2.5
   end

end
