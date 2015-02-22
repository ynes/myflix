require 'spec_helper'

describe PasswordResetsController do
  describe "Get show" do
    it "renders show template if the token is valid" do
      user = Fabricate(:user)
      user.update_column(:token, "1234")
      get :show, id: "1234"
      expect(response).to render_template :show
    end
    it "set @token" do
      user = Fabricate(:user)
      user.update_column(:token, "1234")
      get :show, id: "1234"
      expect(assigns(:token)).to eq("1234")

    end
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: "1234"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
   context "with valid token" do
     it "redirects to the sign in page" do
       user = Fabricate(:user, password: "old_password")
       user.update_column(:token, "1234")
       post :create, token: "1234", password: "new_password"
      expect(response).to redirect_to sign_in_path
     end
     it "update the user's password" do
       user = Fabricate(:user, password: "old_password")
       user.update_column(:token, "1234")
       post :create, token: "1234", password: "new_password"
       expect(user.reload.authenticate("new_password")).to be_truthy
     end
     it "sets the flash success message" do
       user = Fabricate(:user, password: "old_password")
       user.update_column(:token, "1234")
       post :create, token: "1234", password: "new_password"
      expect(flash[:success]).to be_present
     end
     it "renerates the user token" do
       user = Fabricate(:user, password: "old_password")
       user.update_column(:token, "1234")
       post :create, token: "1234", password: "new_password"
      expect(user.reload.token).not_to eq("1234")
     end
   end
   context "with invalid token" do
     it "redirects to the expired token path" do
       post :create, token: "1234", password: "some_password"
       expect(response).to redirect_to expired_token_path
     end
   end
  end
end
