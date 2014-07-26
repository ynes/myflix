require "spec_helper"

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirect to the sign in page for unautheticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associeted with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue that is associatesd the the signed in user" do
      user  = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)

    end
    it "puts the video as the last one in the queue" do
      user  = Fabricate(:user)
      session[:user_id] = user.id
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: user)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
      expect(video2_queue_item.position).to eq(2)
    end
    it "does not add the video the queue if the video is already in the queue" do
      user  = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user)
      post :create, video_id: video.id
      expect(user.queue_items.count).to eq(1)

    end
    it "redirect to the sign in page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end

  end

  describe "DELETE destroy" do
    it "redirect to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
       delete :destroy, id: queue_item.id
       expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      session[:user_id] = user1.id
      queue_item = Fabricate(:queue_item, user: user2)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)

    end
    it "redirects to the sign in page for unanthenticated users" do
      delete :destroy, id: 3
      expect(response).to redirect_to sign_in_path
    end
  end
end
