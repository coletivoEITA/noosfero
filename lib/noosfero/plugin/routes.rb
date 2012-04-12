Dir.glob(File.join(Rails.root, 'config', 'plugins', '*', 'controllers')) do |dir|
  plugin_name = File.basename(File.dirname(dir))
  match "plugin/#{plugin_name}/:action/:id" => "#{plugin_name}_plugin_environment#index"
  match "profile/:profile/plugins/#{plugin_name}/:action/:id" => "#{plugin_name}_plugin_profile#index"
  match "myprofile/:profile/plugin/#{plugin_name}/:action/:id" => "#{plugin_name}_plugin_myprofile#index"
  match "admin/plugin/#{plugin_name}/:action/:id" => "#{plugin_name}_plugin_admin#index"
end

