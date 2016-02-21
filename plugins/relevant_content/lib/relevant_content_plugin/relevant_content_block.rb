class RelevantContentPlugin::RelevantContentBlock < Block
  def self.description
    _('Relevant content')
  end

  def default_title
    _('Relevant content')
  end

  def help
    _('This block lists the most popular content.')
  end

  settings_items :limit,                :type => :integer, :default => 5
  settings_items :show_most_read,       :type => :boolean, :default => 1
  settings_items :show_most_commented,  :type => :boolean, :default => 1
  settings_items :show_most_liked,      :type => :boolean, :default => 1
  settings_items :show_most_disliked,   :type => :boolean, :default => 0
  settings_items :show_most_voted,      :type => :boolean, :default => 1

  def env
    owner.kind_of?(Environment) ? owner : owner.environment
  end

  def timeout
    4.hours
  end

  def self.expire_on
      { :profile => [:article], :environment => [:article] }
  end

end
