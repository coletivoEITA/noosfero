class ProposalsDiscussionPlugin::Topic < Folder

  alias :discussion :parent

  has_many :proposals, :class_name => 'ProposalsDiscussionPlugin::Proposal', :foreign_key => 'parent_id'
  has_many :proposals_comments, :class_name => 'Comment', :through => :children, :source => :comments
  has_many :proposals_authors, :class_name => 'Person', :through => :children, :source => :created_by

  settings_items :color, :type => :string

  attr_accessible :color

  def self.short_description
    _("Discussion topic")
  end

  def self.description
    _('Container for proposals.')
  end

  def most_active_participants
    proposals_authors.group('profiles.id').order('count(articles.id) DESC').includes(:environment, :preferred_domain, :image)
  end

  def to_html(options = {})
    topic = self
    proc do
      render :file => 'content_viewer/topic', :locals => {:topic => topic}
    end
  end

  def allow_create?(user)
    true
  end

  def max_score
    @max ||= [1, proposals.maximum(:comments_count)].max
  end

  def proposal_tags
    proposals.tag_counts.inject({}) do |memo,tag|
      memo[tag.name] = tag.count
      memo
    end
  end

  def proposals_per_day
    result = proposals.group("date(created_at)").count
    fill_empty_days(result)
  end

  def comments_per_day
    result = proposals.joins(:comments).group('date(comments.created_at)').count('comments.id')
    fill_empty_days(result)
  end

  def fill_empty_days(result)
    from = created_at.to_date
    (from..Date.today).inject({}) do |h, date|
      h[date.to_s] = result[date.to_s] || 0
      h
    end
  end

  def cache_key_with_person(params = {}, user = nil, language = 'en')
    cache_key_without_person + (user ? "-#{user.identifier}" : '')
  end
  alias_method_chain :cache_key, :person

end