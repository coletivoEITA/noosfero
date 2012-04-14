require_relative '../test_helper'

class ProfileSearchBlockTest < ActiveSupport::TestCase

  should 'describe itself' do
    assert_not_equal Block.description, ProfileSearchBlock.description
  end

  should 'not provide a default title' do
    assert_equal Block.new.default_title, ProfileSearchBlock.new.default_title
  end

  should 'render profile search' do
    person = fast_create(Person)

    block = ProfileSearchBlock.new
    block.stubs(:owner).returns(person)

    self.expects(:render).with(:file => 'blocks/profile_search', :locals => { :title => block.title})
    instance_exec(& block.content)
  end

  should 'provide view_title' do
    person = fast_create(Person)
    person.boxes << Box.new
    block = ProfileSearchBlock.new(:title => 'Title from block')
    person.boxes.first.blocks << block
    block.save!
    assert_equal 'Title from block', block.view_title
  end

end
