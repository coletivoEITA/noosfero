require_dependency 'environment'

class Environment
  settings_items :piwik_domain
  settings_items :piwik_path, :default => 'piwik'
  settings_items :piwik_site_id
end
