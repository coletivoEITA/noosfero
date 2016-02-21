class LinkArticle < Article

  def self.short_description
    "Article link"
  end

  delegate :name, :to => :reference_article
  delegate :body, :to => :reference_article
  delegate :abstract, :to => :reference_article
  delegate :url, :to => :reference_article

end
