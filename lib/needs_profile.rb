module NeedsProfile

  module ClassMethods
    def needs_profile
      before_filter :load_profile
      # put it after so that the profile can be seen
      skip_before_filter :boxes_controller
      before_filter :boxes_controller
    end
  end

  def self.included(including)
    including.send(:extend, NeedsProfile::ClassMethods)
  end

  def boxes_holder
    profile || environment # prefers profile, but defaults to environment
  end

  protected 

  def profile
    @profile
  end

  def load_profile
    @profile ||= environment.profiles.find_by_identifier(params[:profile])
    if @profile
      if !@profile.display_info_to?(user)
        render_access_denied(_("This profile is inaccessible. You don't have the permission to view the content here."), _("Oops ... you cannot go ahead here"))
      else
        profile_hostname = @profile.hostname
        if profile_hostname && request.host == @environment.default_hostname
          params.delete(:profile)
          redirect_to(Noosfero.url_options.merge(params).merge(:host => profile_hostname))
        end
      end
    else
      render_not_found
    end
  end

end
