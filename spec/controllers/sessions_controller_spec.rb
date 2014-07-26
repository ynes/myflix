require "spec_helper"

describe SessionsController do
  describe "GET new" do
    it "render the new template for anauthenticated user" do
      get :new
      response.should render_template :new
    end
    it "redirect to home fot authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      response.should redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before do
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password
      end
      it "add the signed user to the session" do
        expect(session[:user_id]).to eq(@user.id)
      end
      it "redirects to the home template" do
        response.should redirect_to home_path
      end
      it "sets the notice" do 
        expect(flash[:notice]).not_to be_blank
      end
    end
    context "with invalid credentials" do
      before do 
        user = Fabricate(:user)
        post :create, email: user.email, password: "ootherPassword" 
      end
      it "does not add the signed user to the session" do
        expect(session[:user_id]).to be_nil
      end
      it "redirects to the sign in page" do
        response.should redirect_to sign_in_path
      end
      it "sets the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end
    it "redirects to the root path" do
      response.should redirect_to root_path
    end
    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
