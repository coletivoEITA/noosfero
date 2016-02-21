require_dependency 'profile'

class Profile

  def volunteers_settings attrs = {}
    @volunteers_settings ||= Noosfero::Plugin::Settings.new self, VolunteersPlugin, attrs
    attrs.each{ |a, v| @volunteers_settings.send "#{a}=", v }
    @volunteers_settings
  end
  alias_method :volunteers_settings=, :volunteers_settings

end
