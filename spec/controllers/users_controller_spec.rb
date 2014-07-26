require "spec_helper"

describe UsersController do
  describe "Get new" do
    it "set the @user vaiable" do
      user = User.new
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  describe "POST create" do
    describe "with valid parameters" do
      before do
        post :create, {user: Fabricate.attributes_for(:user)}
      end
      it "creates user when parameters are valid" do
        expect(assigns(:user)).to eq(User.last)
      end
      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
    describe "with invalid parameters" do
      before do
        post :create, {user: {full_name: nil, email: nil, password: nil}}
      end
      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "render to new" do
        response.should render_template("new") 
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end
