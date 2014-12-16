module NeedsProfile

  extend ActiveSupport::Concern
  included do
    extend NeedsProfile::ClassMethods
  end

  module ClassMethods
    def needs_profile
      self.cattr_accessor :profile_needed
      self.profile_needed = true
      before_filter :load_profile
    end
  end

  def boxes_holder
    profile || environment # prefers profile, but defaults to environment
  end

  def profile
    @profile
  end

  protected

  def load_profile
    ##
    # The route must omit the :profile to support
    # profile with domains URLs without them.
    # Recognize :profile parameter here.
    #
    if (@domain.blank? or @domain.owner_type != 'Profile') and params[:profile].blank?
      if params[:page].present?
        page_path        = params[:page].split '/'
        params[:profile] = page_path.shift
        params[:page]    = page_path
      end
    end

    if params[:profile]
      params[:profile].downcase!
      @profile ||= environment.profiles.where(identifier: params[:profile]).first
    end

    if @profile
      profile_hostname = @profile.hostname
      if profile_hostname && profile_hostname != request.host
        params.delete(:profile)
        redirect_to(Noosfero.url_options.merge(params).merge(:host => profile_hostname))
      end
    else
      render_not_found
    end
  end

end
