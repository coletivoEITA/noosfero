class SignupWithEnterprisePluginController < ApplicationController

  no_design_blocks

  def signup
    @invitation_code = params[:invitation_code]
    params[:user] ||= {}
    params[:user].delete(:password_confirmation_clear)
    params[:user].delete(:password_clear)

    begin
      @user = User.new params[:user].merge(:environment => environment)
      @terms_of_use = @user.terms_of_use
      @person = @user.person = Person.new(params[:profile_data])

      if request.post?
        @user.signup!

        if @user.activated?
          self.current_user = @user
          redirect_to '/'
        else
          @register_pending = true
        end
      end
    rescue ActiveRecord::RecordInvalid
      @person.valid?
      @person.errors.delete(:identifier)
      @person.errors.delete(:user_id)
    end
  end
end
