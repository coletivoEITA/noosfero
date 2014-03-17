class EmailPlugin::Identity < Noosfero::Plugin::ActiveRecord

  belongs_to :profile

end
