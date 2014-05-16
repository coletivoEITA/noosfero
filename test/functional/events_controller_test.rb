require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @profile = create_user('testuser').person
  end
  attr_reader :profile

  should 'list today events by default' do
    profile.events << Event.new(:name => 'Joao Birthday', :start_date => Date.today)
    profile.events << Event.new(:name => 'Maria Birthday', :start_date => Date.today)

    get :events, :profile => profile.identifier

    today = Date.today.strftime("%B %d, %Y")
    assert_tag :tag => 'div', :attributes => {:id => "agenda-items"},
      :descendant => {:tag => 'h3', :content => "Events for #{today}"},
      :descendant => {:tag => 'tr', :content => "Joao Birthday"},
      :descendant => {:tag => 'tr', :content => "Maria Birthday"}
  end

  should 'display calendar of current month' do
    get :events, :profile => profile.identifier

    month = Date.today.strftime("%B %Y")
    assert_tag :tag => 'table', :attributes => {:class => /current-month/}, :descendant => {:tag => 'caption', :content => /#{month}/}
  end

  should 'display links to previous and next month' do
    get :events, :profile => profile.identifier

    prev_month = Date.today - 1.month
    next_month = Date.today + 1.month
    prev_month_name = prev_month.strftime("%B")
    next_month_name = next_month.strftime("%B")
    assert_tag :tag =>'a', :attributes => {:href => "/profile/#{profile.identifier}/events/#{prev_month.year}/#{prev_month.month}"}, :content => prev_month_name
    assert_tag :tag =>'a', :attributes => {:href => "/profile/#{profile.identifier}/events/#{next_month.year}/#{next_month.month}"}, :content => next_month_name
  end

  should 'see the events paginated' do
    30.times do |i|
      profile.events << Event.new(:name => "Lesson #{i}", :start_date => Date.today)
    end
    get :events, :profile => profile.identifier
    assert_equal 20, assigns(:events).size
  end

  should 'show events of specific day' do
    profile.events << Event.new(:name => 'Joao Birthday', :start_date => Date.new(2009, 10, 28))

    get :events_by_day, :profile => profile.identifier, :year => 2009, :month => 10, :day => 28

    assert_tag :tag => 'a', :content => /Joao Birthday/
  end

end
