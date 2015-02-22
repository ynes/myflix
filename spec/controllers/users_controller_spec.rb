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

      it "makes the user follow the inviter" do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user, recipient_email: "abc@example.com")
        post :create, user: {email: "abc@example.com", password: "password", full_name: "first last"}, invitation_token: invitation.token
        abc = User.where(email: "abc@example.com").first
        expect(abc.follows?(user)).to be true
      end
      it "makes the inviter follow the user" do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user, recipient_email: "abc@example.com")
        post :create, user: {email: "abc@example.com", password: "password", full_name: "first last"}, invitation_token: invitation.token
        abc = User.where(email: "abc@example.com").first
        expect(user.follows?(abc)).to be true
      end
      it "expires the invitation upon accepatance" do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user, recipient_email: "abc@example.com")
        post :create, user: {email: "abc@example.com", password: "password", full_name: "first last"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil

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
    context "sending emails" do
      after {ActionMailer::Base.deliveries.clear}

      it "sends out email to the user with valid inputs" do
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end
      it "sends out email containgin the user's name with valid input" do
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end
      it "does not send out email with invalid inputs" do
        post :create, user: {email: "joe@example.com"}
        expect(ActionMailer::Base.deliveries).to be_empty 
      end
    end
  end
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: 3}
    end
    it "sets @user" do
      set_current_user
      user = Fabricate(:user)
      get :show, id:user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new 
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq( invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: "asfagra" 
      expect(response).to redirect_to expired_token_path

    end
  end
end
