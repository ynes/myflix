class InvitationsController < ApplicationController
  before_filter :required_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "You hace successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash[:error] = "Please check your inputs."
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :inviter_id, :recipient_email, :message )
  end
end
