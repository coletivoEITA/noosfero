require_relative '../helpers/application_helper'

class ApplicationMailer < ActionMailer::Base

  include AuthenticatedSystem

  helper ApplicationHelper

  attr_accessor :environment

  def default_url_options
    options = super

    options[:host] = environment.default_hostname if environment

    options
  end

end

