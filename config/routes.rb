require 'noosfero'

Rails3::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  ######################################################
  ## Public controllers
  ######################################################

  match 'test/:controller/:action/:id' => '(?-mix:.*test.*)#index'
 
  # -- just remember to delete public/index.html.
  # You can have the root of your site routed by hooking up ''
  match '' => 'home#index', :via => 
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
 
  # events
  map.events 'profile/:profile/events_by_day', :controller => 'events', :action => 'events_by_day', :profile => /#{Noosfero.identifier_format}/
  map.events 'profile/:profile/events/:year/:month/:day', :controller => 'events', :action => 'events', :year => /\d*/, :month => /\d*/, :day => /\d*/, :profile => /#{Noosfero.identifier_format}/
  map.events 'profile/:profile/events/:year/:month', :controller => 'events', :action => 'events', :year => /\d*/, :month => /\d*/, :profile => /#{Noosfero.identifier_format}/
  map.events 'profile/:profile/events', :controller => 'events', :action => 'events', :profile => /#{Noosfero.identifier_format}/

  # catalog
  map.catalog 'catalog/:profile', :controller => 'catalog', :action => 'index', :profile => /#{Noosfero.identifier_format}/

  # invite
  map.invite 'profile/:profile/invite/friends', :controller => 'invite', :action => 'select_address_book', :profile => /#{Noosfero.identifier_format}/
  map.invite 'profile/:profile/invite/:action', :controller => 'invite', :profile => /#{Noosfero.identifier_format}/

  # feeds per tag
  map.tag_feed 'profile/:profile/tags/:id/feed', :controller => 'profile', :action =>'tag_feed', :id => /.+/, :profile => /#{Noosfero.identifier_format}/

  # profile tags
  map.tag 'profile/:profile/tags/:id', :controller => 'profile', :action => 'content_tagged', :id => /.+/, :profile => /#{Noosfero.identifier_format}/
  map.tag 'profile/:profile/tags', :controller => 'profile', :action => 'tags', :profile => /#{Noosfero.identifier_format}/

  # profile search
  map.profile_search 'profile/:profile/search', :controller => 'profile_search', :action => 'index', :profile => /#{Noosfero.identifier_format}/

  # public profile information
  map.profile 'profile/:profile/:action/:id', :controller => 'profile', :action => 'index', :id => /[^\/]*/, :profile => /#{Noosfero.identifier_format}/

  # contact
  map.contact 'contact/:profile/:action/:id', :controller => 'contact', :action => 'index', :id => /.*/, :profile => /#{Noosfero.identifier_format}/

  # map balloon
  map.contact 'map_balloon/:action/:id', :controller => 'map_balloon', :id => /.*/

  # chat
  map.chat 'chat/:action/:id', :controller => 'chat'
  map.chat 'chat/:action', :controller => 'chat'

  ######################################################
  ## Controllers that are profile-specific (for profile admins )
  ######################################################
  # profile customization - "My profile"
  map.myprofile 'myprofile/:profile', :controller => 'profile_editor', :action => 'index', :profile => /#{Noosfero.identifier_format}/
  map.myprofile 'myprofile/:profile/:controller/:action/:id', :controller => Noosfero.pattern_for_controllers_in_directory('my_profile'), :profile => /#{Noosfero.identifier_format}/


  ######################################################
  ## Controllers that are used by environment admin
  ######################################################
  # administrative tasks for a environment
  map.admin 'admin', :controller => 'admin_panel'
  map.admin 'admin/:controller/:action.:format/:id', :controller => Noosfero.pattern_for_controllers_in_directory('admin')
  map.admin 'admin/:controller/:action/:id', :controller => Noosfero.pattern_for_controllers_in_directory('admin')


  ######################################################
  ## Controllers that are used by system admin
  ######################################################
  # administrative tasks for a environment
  map.system 'system', :controller => 'system'
  map.system 'system/:controller/:action/:id', :controller => Noosfero.pattern_for_controllers_in_directory('system')

  ######################################################
  # plugin routes
  ######################################################
  plugins_routes = File.join(File.dirname(__FILE__) + '/../lib/noosfero/plugin/routes.rb')
  eval(IO.read(plugins_routes), binding, plugins_routes)

  # cache stuff - hack
  map.cache 'public/:action/:id', :controller => 'public'

  # match requests for profiles that don't have a custom domain
  map.homepage ':profile/*page', :controller => 'content_viewer', :action => 'view_page', :profile => /#{Noosfero.identifier_format}/, :conditions => { :if => lambda { |env| !Domain.hosting_profile_at(env[:host]) } }

  # match requests for content in domains hosted for profiles
  map.connect '*page', :controller => 'content_viewer', :action => 'view_page'

end
