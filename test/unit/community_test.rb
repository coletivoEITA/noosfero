require File.dirname(__FILE__) + '/../test_helper'

class CommunityTest < Test::Unit::TestCase

  def setup
    @person = create_user('testuser').person
  end

  attr_reader :person

  should 'inherit from Profile' do
    assert_kind_of Profile, Community.new
  end

  should 'convert name into identifier' do
    c = Community.new(:environment => Environment.default, :name =>'My shiny new Community')
    assert_equal 'My shiny new Community', c.name
    assert_equal 'my-shiny-new-community', c.identifier
  end

  should 'have a description attribute' do
    c = Community.new(:environment => Environment.default)
    c.description = 'the description of the community'
    assert_equal 'the description of the community', c.description
  end

  should 'create default set of blocks' do
    c = Community.create!(:environment => Environment.default, :name => 'my new community')

    assert c.boxes[0].blocks.map(&:class).include?(MainBlock)

    assert c.boxes[1].blocks.map(&:class).include?(ProfileInfoBlock)
    assert c.boxes[1].blocks.map(&:class).include?(RecentDocumentsBlock)

    assert c.boxes[2].blocks.map(&:class).include?(MembersBlock)
    assert c.boxes[2].blocks.map(&:class).include?(TagsBlock)

    assert_equal 5,  c.blocks.size
  end

  should 'get a default home page and RSS feed' do
    community = Community.create!(:environment => Environment.default, :name => 'my new community')

    assert_kind_of Article, community.home_page
    assert_kind_of RssFeed, community.articles.find_by_path('feed')
  end

  should 'have contact_person' do
    community = Community.new(:environment => Environment.default, :name => 'my new community')
    assert_respond_to community, :contact_person
  end

  should 'allow to add new members' do
    c = fast_create(Community, :name => 'my test profile', :identifier => 'mytestprofile')
    p = create_user('mytestuser').person

    c.add_member(p)

    assert c.members.include?(p), "Community should add the new member"
  end

  should 'allow to remove members' do
    c = fast_create(Community, :name => 'my other test profile', :identifier => 'myothertestprofile')
    p = create_user('myothertestuser').person

    c.add_member(p)
    assert_includes c.members, p
    c.remove_member(p)
    c.reload
    assert_not_includes c.members, p
  end

  should 'clear relationships after destroy' do
    c = fast_create(Community, :name => 'my test profile', :identifier => 'mytestprofile')
    member = create_user('memberuser').person
    admin = create_user('adminuser').person
    moderator = create_user('moderatoruser').person

    c.add_member(member)
    c.add_admin(admin)
    c.add_moderator(moderator)

    relationships = c.role_assignments
    assert_not_nil relationships

    c.destroy
    relationships.each do |i|
      assert !RoleAssignment.exists?(i.id)
    end
  end

  should 'have a community template' do
    env = Environment.create!(:name => 'test env')
    p = Community.create!(:name => 'test_com', :identifier => 'test_com', :environment => env)
    assert_kind_of Community, p.template
  end

  should 'return active_community_fields' do
    e = Environment.default
    e.expects(:active_community_fields).returns(['contact_phone', 'contact_email']).at_least_once
    ent = Community.new(:environment => e)

    assert_equal e.active_community_fields, ent.active_fields
  end

  should 'return required_community_fields' do
    e = Environment.default
    e.expects(:required_community_fields).returns(['contact_phone', 'contact_email']).at_least_once
    community = Community.new(:environment => e)

    assert_equal e.required_community_fields, community.required_fields
  end

  should 'require fields if community needs' do
    e = Environment.default
    e.expects(:required_community_fields).returns(['contact_phone']).at_least_once
    community = Community.new(:name => 'My community', :environment => e)
    assert ! community.valid?
    assert community.errors.invalid?(:contact_phone)

    community.contact_phone = '99999'
    community.valid?
    assert ! community.errors.invalid?(:contact_phone)
  end

  should 'return newest text articles as news' do
    c = fast_create(Community, :name => 'test_com')
    f = fast_create(Folder, :name => 'folder', :profile_id => c.id)
    u = UploadedFile.create!(:profile => c, :uploaded_data => fixture_file_upload('/files/rails.png', 'image/png'))
    older_t = fast_create(TinyMceArticle, :name => 'old news', :profile_id => c.id)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id)
    t_in_f = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id, :parent_id => f.id)

    assert_equal [t_in_f, t], c.news(2)
  end

  should 'not return highlighted news when not asked' do
    c = fast_create(Community, :name => 'test_com')
    highlighted_t = fast_create(TinyMceArticle, :name => 'high news', :profile_id => c.id, :highlighted => true)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id)

    assert_equal [t].map(&:slug), c.news(2).map(&:slug)
  end

  should 'return highlighted news when asked' do
    c = fast_create(Community, :name => 'test_com')
    highlighted_t = fast_create(TinyMceArticle, :name => 'high news', :profile_id => c.id, :highlighted => true)
    t = fast_create(TinyMceArticle, :name => 'news', :profile_id => c.id)

    assert_equal [highlighted_t].map(&:slug), c.news(2, true).map(&:slug)
  end

  should 'sanitize description' do
    c = Community.create!(:name => 'test_com', :description => '<b>new</b> community')

    assert_sanitized c.description
  end

  should 'sanitize name' do
    c = Community.create!(:name => '<b>test_com</b>')

    assert_sanitized c.name
  end

  should 'create a task when creating a community if feature is enabled' do
    env = Environment.default
    env.enable('admin_must_approve_new_communities')

    assert_difference CreateCommunity, :count do
      Community.create_after_moderation(person, {:environment => env, :name => 'Example'})
    end

    assert_no_difference Community, :count do
      Community.create_after_moderation(person, {:environment => env, :name => 'Example'})
    end
  end

  should 'create a community if feature is disabled' do
    env = Environment.default
    env.disable('admin_must_approve_new_communities')

    assert_difference Community, :count do
      Community.create_after_moderation(person, {:environment => env, :name => 'Example'})
    end

    assert_no_difference CreateCommunity, :count do
      Community.create_after_moderation(person, {:environment => env, :name => 'Example'})
    end
  end

  should 'not create new request membership if it already exists' do
    community = fast_create(Community)
    community.closed = true
    community.save
    assert_difference AddMember, :count do
      community.add_member(person)
    end

    assert_no_difference AddMember, :count do
      community.add_member(person)
    end
  end

  should 'escape malformed html tags' do
    community = Community.new
    community.name = "<h1 Malformed >> html >< tag"
    community.address = "<h1 Malformed >,<<<asfdf> html >< tag"
    community.contact_phone = "<h1 Malformed<<> >> html >><>< tag"
    community.description = "<h1 Malformed /h1>>><<> html ><>h1< tag"
    community.valid?

    assert_no_match /[<>]/, community.name
    assert_no_match /[<>]/, community.address
    assert_no_match /[<>]/, community.contact_phone
    assert_no_match /[<>]/, community.description
  end

end
