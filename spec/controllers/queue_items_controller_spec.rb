require "spec_helper"

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index}
    end

  end

  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates the queue item that is associeted with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue that is associatesd the the signed in user" do
      user  = Fabricate(:user)
      set_current_user(user)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)

    end
    it "puts the video as the last one in the queue" do
      user  = Fabricate(:user)
      set_current_user(user)
      video1 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: user)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
      expect(video2_queue_item.position).to eq(2)
    end
    it "does not add the video the queue if the video is already in the queue" do
      user  = Fabricate(:user)
      set_current_user(user)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user)
      post :create, video_id: video.id
      expect(user.queue_items.count).to eq(1)

    end

    it_behaves_like "requires sign in" do
      let(:action) { get :create, video_id: 3}
    end

  end

  describe "DELETE destroy" do
    it "redirect to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      queue_item = Fabricate(:queue_item, user: user2)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)

    end

    it "normalize the remaining queue items" do
      user = Fabricate(:user)
      set_current_user(user)
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: user, position:1, video: video)
      queue_item2 = Fabricate(:queue_item, user: user, position:2, video: video)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :destroy, id: 3}
    end
  end
  describe "POST update_queue" do
    
    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, postion: 2}] }
    end

    context "with valid inputs" do
      let(:user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) { Fabricate(:queue_item, user: user, position:1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: user, position:2, video: video)}
      before { set_current_user(user)}

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "renders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq([1, 2])
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs" do
      let(:user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}
      let(:queue_item1) { Fabricate(:queue_item, user: user, position:1, video: video)}
      let(:queue_item2) {Fabricate(:queue_item, user: user, position:2, video: video)}
      before { set_current_user(user) }

      it "redirect to the my queue page"do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 5.7}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 5.93}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do no belongs to current user" do
      it "does not change the queue items" do
        user = Fabricate(:user)
        user2 = Fabricate(:user)
        set_current_user(user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user2, position:1, video: video)
        queue_item2 = Fabricate(:queue_item, user: user, position:2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
