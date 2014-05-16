class Friendship < ActiveRecord::Base
  track_actions :new_friendship, :after_create, :keep_params => ["friend.name", "friend.url", "friend.profile_custom_icon"], :custom_user => :person

  extend CacheCounterHelper

  belongs_to :person, :foreign_key => :person_id
  belongs_to :friend, :class_name => 'Person', :foreign_key => 'friend_id'

  after_create do |friendship|
    Friendship.update_cache_counter(:friends_count, friendship.person, 1)
    Friendship.update_cache_counter(:friends_count, friendship.friend, 1)
  end

  after_destroy do |friendship|
    Friendship.update_cache_counter(:friends_count, friendship.person, -1)
    Friendship.update_cache_counter(:friends_count, friendship.friend, -1)
  end
end
