class EventPlugin::EventBlock < Block

  include DatesHelper

  settings_items :all_env_events, :type => :boolean, :default => false
  settings_items :limit, :type => :integer, :default => 4
  settings_items :future_only, :type => :boolean, :default => true
  settings_items :date_distance_limit, :type => :integer, :default => 0

  def self.description
    _('Events')
  end

  def help
    _('Show the profile events or all environment events.')
  end

  def events_source
    return environment if all_env_events
    if self.owner.kind_of? Environment
      environment.portal_community ? environment.portal_community : environment
    else
      self.owner
    end
  end

  def events(user = nil)
    events = events_source.events.order('start_date')
    events = user.nil? ? events.is_public : events.display_filter(user,nil)

    if future_only
      events = events.where('start_date >= ?', DateTime.now.beginning_of_day)
    end

    if date_distance_limit > 0
      events = events.by_range([
        DateTime.now.beginning_of_day - date_distance_limit,
        DateTime.now.beginning_of_day + date_distance_limit
      ])
    end

    event_list = []
    events.each do |event|
      event_list << event if event.display_to? user
      break if event_list.length >= limit
    end

    event_list
  end

  def self.expire_on
      { :profile => [:article], :environment => [:article] }
  end

end
