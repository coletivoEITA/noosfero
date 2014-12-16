module UrlSupport

  protected

  extend ActiveSupport::Concern
  included do
    helper_method :url_for
  end

  mattr_accessor :controller_path_class
  self.controller_path_class = {}

  mattr_accessor :omit_profile_if_unnecessary
  self.omit_profile_if_unnecessary = false

  def url_for options = {}
    return super unless options.is_a? Hash
    # for action mailer
    return super unless respond_to? :params and respond_to? :controller_path

    ##
    # This has to implemented overiding #url_for due to 2 reasons:
    # 1) #default_url_options cannot be used to delete params
    # 2) #url_options is general and not specific to each options/url_for call
    #
    # This does:
    # 1) Remove :profile when target profile has a custom domain
    # 2) Ensure :profile if target controller needs a profile and target profile doesn't use a custom domain
    #
    # PS: options[:profile] = nil assure :profile isn't reinserted
    # (this happens with options.delete :profile)
    #
    path           = (options[:controller] || self.controller_path).to_sym
    controller     = UrlSupport.controller_path_class[path] ||= "#{path}_controller".camelize.constantize
    profile_needed = controller.profile_needed if controller.respond_to? :profile_needed, true
    if profile_needed
      other_profile_domain = options[:host].present? && options[:host] != request.host
      this_profile_domain  = @profile && @profile.hostname.present?
      if other_profile_domain || this_profile_domain
        options[:profile] = nil
      elsif profile_needed and @profile
        options[:profile] ||= @profile.identifier
      end
    elsif UrlSupport.omit_profile_if_unnecessary and options[:profile].present?
      options[:profile] = nil
    end

    super options
  end

  def default_url_options
    options = super

    options[:override_user] = params[:override_user] if params[:override_user].present?

    options
  end
end

