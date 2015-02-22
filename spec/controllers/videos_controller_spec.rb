require "spec_helper"

describe VideosController do
  describe "GET show" do
    it "set the @video variable for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      assigns(:video).should eq(video)
    end
  end
  it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, user: Fabricate(:user))
      review2 = Fabricate(:review, video: video, user: Fabricate(:user))
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])

  end
  it "redirect user to the sign in page for vaiable for authenticated users" do
    video = Fabricate(:video)
    get :show, id: video.id
    expect(response).to redirect_to  sign_in_path
  end
  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "Futurama")
      post :search, search: "rama"
      expect(assigns(:videos)).to eq([futurama])
    end
    it "redirects to sign in page for the unauthenticated users" do
      futurama = Fabricate(:video, title: "Futurama")
      post :search, search: "rama"
      expect(response).to redirect_to sign_in_path
    end
  end
end

