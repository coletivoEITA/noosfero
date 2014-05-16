require File.dirname(__FILE__) + '/../test_helper'

class TextArticleTest < ActiveSupport::TestCase
  
  # mostly dummy test. Can be removed when (if) there are real tests for this
  # this class. 
  should 'inherit from Article' do
    assert_kind_of Article, TextArticle.new
  end

  should 'found TextileArticle by TextArticle class' do
    person = create_user('testuser').person
    article = fast_create(TextileArticle, :name => 'textile article test', :profile_id => person.id)
    assert_includes TextArticle.find(:all), article
  end

  should 'remove HTML from name' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person)
    article.name = "<h1 Malformed >> html >>></a>< tag"
    article.valid?

    assert_no_match /[<>]/, article.name
  end

  should 'be translatable' do
    assert_kind_of Noosfero::TranslatableContent, TextArticle.new
  end

  should 'return article icon name' do
    assert_equal Article.icon_name, TextArticle.icon_name
  end

  should 'return blog icon name if the article is a blog post' do
    blog = fast_create(Blog)
    article = TextArticle.new
    article.parent = blog
    assert_equal Blog.icon_name, TextArticle.icon_name(article)
  end

  should 'change image path to relative' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person, :name => 'test')
    env = Environment.default
    article.body = "<img src=\"http://#{env.default_hostname}/test.png\" />"
    article.save!
    assert_equal "<img src=\"/test.png\" />", article.body
  end

  should 'change link to relative path' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person, :name => 'test')
    env = Environment.default
    article.body = "<a href=\"http://#{env.default_hostname}/test\">test</a>"
    article.save!
    assert_equal "<a href=\"/test\">test</a>", article.body
  end

  should 'change image path to relative for domain with https' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person, :name => 'test')
    env = Environment.default
    article.body = "<img src=\"https://#{env.default_hostname}/test.png\" />"
    article.save!
    assert_equal "<img src=\"/test.png\" />", article.body
  end

  should 'change image path to relative for domain with port' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person, :name => 'test')
    env = Environment.default
    article.body = "<img src=\"http://#{env.default_hostname}:3000/test.png\" />"
    article.save!
    assert_equal "<img src=\"/test.png\" />", article.body
  end

  should 'change image path to relative for domain with www' do
    person = create_user('testuser').person
    article = TextArticle.new(:profile => person, :name => 'test')
    env = Environment.default
    env.force_www = true
    env.save!
    article.body = "<img src=\"http://#{env.default_hostname}:3000/test.png\" />"
    article.save!
    assert_equal "<img src=\"/test.png\" />", article.body
  end

end
