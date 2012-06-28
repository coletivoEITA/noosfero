class SignupWithEnterprisePluginController < ApplicationController

  no_design_blocks

  def signup
    @invitation_code = params[:invitation_code]
    begin
      params[:user] ||= {}
      params[:user].delete(:password_confirmation_clear)
      params[:user].delete(:password_clear)

      @user = User.build_with_person params[:profile_data] || {},
        params[:user].merge(:environment => environment)
      @terms_of_use = @user.terms_of_use
      @person = @user.person

      if request.post?
        @user.signup!

        invitation = Task.find_by_code(@invitation_code)
        if invitation
          invitation.update_attributes!({:friend => @user.person})
          invitation.finish
        end

        if @user.activated?
          self.current_user = @user
          redirect_to '/'
        else
          @register_pending = true
        end
      end
    rescue ::ActiveRecord::RecordInvalid
      @person.valid?
      @person.errors.delete(:identifier)
      @person.errors.delete(:user_id)
    end
  end
end
