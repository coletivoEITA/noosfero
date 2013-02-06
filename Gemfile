source :rubygems

gem 'rake', '0.8.7'
gem 'rails', '2.3.15'
gem 'gettext', '2.1.0'
gem 'gettext_rails', '2.1.0'
gem 'rmagick', '2.13.1'
gem 'RedCloth', '4.2.2'
gem 'will_paginate', '2.3.12'
gem 'ruby-feedparser', '0.7'
gem 'hpricot', '0.8.2'
gem 'i18n', '0.4.1'
gem 'daemons', '1.0.10'
gem 'rubyzip'

#Indirect, matching debian squeeze versions
gem 'builder', '2.1.2'
gem 'cmdparse', '2.0.2'
gem 'gem_plugin', '0.2.3'
gem 'eventmachine', '0.12.10'
gem 'log4r', '1.0.6'
gem 'mmap', '0.2.6'
gem 'mocha', '0.9.8'
gem 'nokogiri', '1.4.0'
gem 'rest-client', '1.6.0'
gem 'ruby-breakpoint', '0.5.1'

group :production do
  gem 'thin', '1.2.4'
  gem 'exception_notification', '1.0.20090728'
  gem 'system_timer'
end

group :development do
  gem 'rdoc'
  gem 'mongrel', '1.1.5'
  gem 'mongrel_cluster', '1.0.5'
end

group :databases do
  gem 'sqlite3-ruby', '1.2.4'
  gem 'pg', '0.8.0'
end

group :test do
  gem 'system_timer'
  gem 'tidy'
  gem 'rcov'
end

group :test, :cucumber do
  gem 'cucumber', '0.4.0'
  gem 'webrat', '0.5.1'
  gem 'rspec', '1.2.9'
  gem 'rspec-rails', '1.2.9'
  gem 'Selenium', '>= 1.1.14'
  gem 'selenium-client', '>= 1.2.17'
  gem 'database_cleaner'
end

def program(name)
  unless system("which #{name} > /dev/null")
    puts "W: Program #{name} is needed, but was not found in your PATH"
  end
end

program 'java'
program 'firefox'
