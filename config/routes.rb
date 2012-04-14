require 'noosfero'

class DomainConstraint
  def matches?(request)
    !Domain.hosting_profile_at(request.host)
  end
end

Noosfero::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  
  ######################################################
  ## Public controllers
  ######################################################

  match 'test/:controller/:action(/:id)' => '(?-mix:.*test.*)#index'
 
  root :to => "home#index"  
  match '/' => 'home#index', :constraints => DomainConstraint.new
  match 'site/:action' => 'home#index', :as => :home

  match 'images/*stuff' => 'not_found#index'
  match 'stylesheets/*stuff' => 'not_found#index'
  match 'designs/*stuff' => 'not_found#index'
  match 'articles/*stuff' => 'not_found#index'
  match 'javascripts/*stuff' => 'not_found#index'
  match 'thumbnails/*stuff' => 'not_found#index'
  match 'user_themes/*stuff' => 'not_found#index'

  # online documentation
  match 'doc' => 'doc#index', :as => :doc
  match 'doc/:section' => 'doc#section', :as => :doc_section
  match 'doc/:section/:topic' => 'doc#topic', :as => :doc_topic
  
  # user account controller
  match 'account/new_password/:code' => 'account#new_password'
  match 'account/:action' => 'account#index'

  # enterprise registration
  match 'enterprise_registration/:action' => 'enterprise_registration#index'

  # tags
  match 'tag' => 'search#tags', :as => :tag
  match 'tag/:tag' => 'search#tag', :as => :tag, :tag => /.*/
  
  # categories index
  match 'cat/*category_path' => 'search#category_index', :as => :category
  match 'assets/:asset/*category_path' => 'search#assets', :as => :assets
  # search
  match 'search/:action/*category_path' => 'search#index'
 
  # Browse
  match 'browse/:action/:filter' => 'browse#index'
  match 'browse/:action' => 'browse#index'

  # events
  match 'profile/:profile/events_by_day' => 'events#events_by_day', :as => :events, :profile => /#{Noosfero.identifier_format}/
  match 'profile/:profile/events/:year/:month/:day' => 'events#events', :as => :events, :month => /\d*/, :year => /\d*/, :profile => /#{Noosfero.identifier_format}/, :day => /\d*/
  match 'profile/:profile/events/:year/:month' => 'events#events', :as => :events, :month => /\d*/, :year => /\d*/, :profile => /#{Noosfero.identifier_format}/
  match 'profile/:profile/events' => 'events#events', :as => :events, :profile => /#{Noosfero.identifier_format}/

  # catalog
  match 'catalog/:profile' => 'catalog#index', :as => :catalog, :profile => /#{Noosfero.identifier_format}/

  # invite
  match 'profile/:profile/invite/friends' => 'invite#select_address_book', :as => :invite, :profile => /#{Noosfero.identifier_format}/
  match 'profile/:profile/invite/:action' => 'invite#index', :as => :invite, :profile => /#{Noosfero.identifier_format}/

  # feeds per tag
  match 'profile/:profile/tags/:id/feed' => 'profile#tag_feed', :as => :tag_feed, :profile => /#{Noosfero.identifier_format}/, :id => /.+/

  # profile tags
  match 'profile/:profile/tags(/:id)' => 'profile#content_tagged', :as => :tag, :profile => /#{Noosfero.identifier_format}/, :id => /.+/

  # profile search
  match 'profile/:profile/search' => 'profile_search#index', :as => :profile_search, :profile => /#{Noosfero.identifier_format}/

  # public profile information
  match 'profile/:profile/:action(/:id)' => 'profile#index', :as => :profile, :profile => /#{Noosfero.identifier_format}/, :id => /[^\/]*/

  # contact
  match 'contact/:profile/:action(/:id)' => 'contact#index', :as => :contact, :profile => /#{Noosfero.identifier_format}/, :id => /.*/

  # chat
  match 'chat/:action(/:id)' => 'chat#index', :as => :chat

  ######################################################
  ## Controllers that are profile-specific (for profile admins )
  ######################################################
  # profile customization - "My profile"
  match 'myprofile/:profile' => 'profile_editor#index', :as => :myprofile, :profile => /#{Noosfero.identifier_format}/
  match 'myprofile/:profile/:controller/:action(/:id)' => '(?-mix:(memberships|favorite_enterprises|mailconf|profile_editor|manage_products|friends|tasks|profile_design|maps|cms|profile_members|themes|enterprise_validation))#index', :as => :myprofile, :profile => /#{Noosfero.identifier_format}/


  ######################################################
  ## Controllers that are used by environment admin
  ######################################################
  # administrative tasks for a environment
  match 'admin' => 'admin_panel#index', :as => :admin
  match 'admin/:controller/:action(.:format)(/:id)' => '(?-mix:(plugins|environment_design|edit_template|admin_panel|users|role|region_validators|categories|features|environment_role_manager))#index', :as => :admin


  ######################################################
  ## Controllers that are used by system admin
  ######################################################
  # administrative tasks for a environment
  match 'system' => 'system#index', :as => :system
  match 'system/:controller/:action(/:id)' => '(?-mix:)#index', :as => :system

  ######################################################
  # plugin routes
  ######################################################
  plugins_routes = File.join(File.dirname(__FILE__) + '/../lib/noosfero/plugin/routes.rb')
  eval(IO.read(plugins_routes), binding, plugins_routes)

  # cache stuff - hack
  match 'public/:action(/:id)' => 'public#index', :as => :cache

  # match requests for profiles that don't have a custom domain
  match ':profile/*page' => 'content_viewer#view_page', :as => :homepage, :profile => /#{Noosfero.identifier_format}/, :constraints => DomainConstraint.new

  # match requests for content in domains hosted for profiles
  match '*page' => 'content_viewer#view_page'

end
