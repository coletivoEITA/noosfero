class RecentDocumentsBlock < Block

  def self.description
    _('Last updates')
  end

  def default_title
    _('Recent content')
  end

  def help
    _('This block lists your content most recently updated.')
  end

  settings_items :limit, :type => :integer, :default => 5

  def content(args={})
    docs = self.docs
    title = self.title
    proc do
      block_title(title) +
        content_tag('ul', docs.map {|item| content_tag('li', link_to(h(item.title), item.url))}.join("\n"))
    end
  end

  def footer
    return nil unless self.owner.is_a?(Profile)

    profile = self.owner
    proc do
      link_to _('All content'), :profile => profile.identifier, :controller => 'profile', :action => 'sitemap'
    end
  end

  def docs
    self.limit.nil? ? owner.recent_documents(nil, {}, false) : owner.recent_documents(self.limit, {}, false)
  end

  def self.expire_on
      { :profile => [:article], :environment => [:article] }
  end
end
