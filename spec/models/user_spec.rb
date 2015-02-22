require 'spec_helper'

describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_uniqueness_of(:email)}
  it { should have_many(:queue_items)}
  it { should have_many(:reviews).order("created_at DESC")}

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user)}
  end


  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user)
      user.queued_video?(video).should be_truthy
    end
    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_falsey

    end
  end
  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader:user2, follower: user1)
      expect(user1.follows?(user2)).to be true
    end
    it "returns false if the user does not have a following relationship with another user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader:user1, follower: user2)
      expect(user1.follows?(user2)).to be false
    end
  end

  describe "#follow" do
    it "follows another user" do
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      user.follow(user2)
      expect(user.follows?(user2)).to be true
    end
    it "does not follow one self" do
      user = Fabricate(:user)
      user.follow(user)
      expect(user.follows?(user)).to be false
    end
  end

end
