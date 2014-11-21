class VirtuosoPlugin::NoosferoHarvest

  COMMON_MAPPING = {
    :type => {:predicate => "http://purl.org/dc/terms/type", :value => lambda {|s, t| t.class.name}},
    :created_at => {:predicate => "http://purl.org/dc/terms/created"},
    :updated_at => {:predicate => "http://purl.org/dc/terms/modified"},
  }

  ARTICLE_MAPPING = {
    :title => {:predicate => "http://purl.org/dc/terms/title"},
    :abstract => {:predicate => "http://purl.org/dc/terms/abstract"},
    :body => {:predicate => "http://purl.org/dc/terms/description"},
    :part_of => {:predicate => "http://purl.org/dc/terms/isPartOf", :value => lambda {|s, t| url_for(s.url)} },
    :published_at => {:predicate => "http://purl.org/dc/terms/issued"},
    :author => {:predicate => "http://purl.org/dc/terms/creator", :value => lambda {|s, t| url_for(t.author_url) if t.author_url} },
  }
  PROFILE_MAPPING = {
    :name => {:predicate => "http://purl.org/dc/terms/title"},
    :public? => {:predicate => "http://purl.org/socialparticipation/opa#publicProfile"},
  }
  COMMENT_MAPPING = {
    :title => {:predicate => "http://purl.org/dc/terms/title"},
    :body => {:predicate => "http://purl.org/dc/terms/description"},
    :part_of => {:predicate => "http://purl.org/dc/terms/isPartOf", :value => lambda {|s, t| url_for(s.url)} },
    :author => {:predicate => "http://purl.org/dc/terms/creator", :value => lambda {|s, t| url_for(t.author_url) if t.author_url} },
  }
  FRIENDSHIP_MAPPING = {
    :knows => {:predicate => "http://xmlns.com/foaf/0.1/knows", :value => lambda {|s, t| url_for(t.url)} },
    :type => nil, :created_at => nil, :updated_at => nil,
  }

  def initialize(environment)
    @environment = environment
    @graph = environment.top_url
  end

  attr_reader :environment

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  delegate :settings, :to => :plugin

  include Rails.application.routes.url_helpers

  def triplify_comments(article)
    article.comments.each do |comment|
      subject_identifier = url_for(comment.url)
      puts "triplify #{subject_identifier} comment"
      triplify_mappings(COMMENT_MAPPING, subject_identifier, article, comment)
    end
  end

  def triplify_articles(profile)
    profile.articles.public.each do |article|
      subject_identifier = url_for(article.url)
      puts "triplify #{subject_identifier} article"
      triplify_mappings(ARTICLE_MAPPING, subject_identifier, profile, article)
      triplify_comments(article)
    end
  end

  def triplify_friendship(person)
    person.friends.each do |friend|
      subject_identifier = url_for(person.url)
      puts "triplify #{subject_identifier} friendship"
      triplify_mappings(FRIENDSHIP_MAPPING, subject_identifier, person, friend)
    end
  end

  def triplify_profiles
    environment.profiles.each do |profile|
      subject_identifier = url_for(profile.url)
      puts "triplify #{subject_identifier} profile"
      triplify_mappings(PROFILE_MAPPING, subject_identifier, environment, profile)
      triplify_articles(profile) if profile.public?
      triplify_friendship(profile) if profile.person?
    end
  end

  def run
    triplify_profiles
  end

  protected

  def triplify_mappings(mapping, subject_identifier, source, target)
    COMMON_MAPPING.merge(mapping).each do |k, v|
      next unless v
      value = nil
      if v[:value]
        value = v[:value].kind_of?(Proc) ? v[:value].call(source, target) : v[:value]
      elsif target.respond_to?(k)
        value = target.send(k)
      end
      insert_triple(RDF::URI.new(subject_identifier), RDF::URI.new(v[:predicate]), value) if value.present?
    end
  end

  def insert_triple(subject, predicate, value)
    value = RDF::URI.new(value) if value.kind_of?(String) && /https?:\/\//.match(value)
    value = RDF::Literal::DateTime.new(value) if value.kind_of?(ActiveSupport::TimeWithZone)
    value = RDF::Literal::Boolean.new(value) if !!value == value

    query = RDF::Virtuoso::Query.insert_data([RDF::URI.new(subject), RDF::URI.new(predicate), value]).graph(RDF::URI.new(@graph))
    plugin.virtuoso_client.insert(query)
  end

end
