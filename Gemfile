source :rubygems

group :development, :production do
  gem 'rake', '0.9.2.2'
  gem 'rails', '3.1.4'

  gem 'gettext_i18n_rails', '0.4.6'
  gem 'rmagick', '2.13.1'
  gem 'RedCloth', '4.2.2'
  gem 'ruby-feedparser', '0.7'
  gem 'hpricot', '0.8.4'
  gem 'daemons', '1.0.10'

  gem 'will_paginate', '3.0.3'
  gem 'acts_as_versioned', :git => 'git://github.com/JoelJuliano/acts_as_versioned'

  gem 'prototype-rails'
end

group :production do
  gem 'thin', '1.2.4'
  gem 'exception_notification', '1.0.20090728'
end

group :databases do
  gem 'sqlite3', '1.3.5'
  gem 'pg', '0.8.0'
end

group :test do
  gem 'system-timer19'
  gem 'tidy_ffi'
end

group :test, :cucumber do
  gem 'mocha', '0.9.8'
  gem 'cucumber', '0.4.0'
  gem 'webrat', '0.5.1'
  gem 'rspec', '1.2.9'
  gem 'rspec-rails', '1.2.9'
  gem 'Selenium', '>= 1.1.14'
  gem 'selenium-client', '>= 1.2.17'
  gem 'database_cleaner'
end

group :utils do
  gem 'wirble'
end

def program(name)
  unless system("which #{name} > /dev/null")
    puts "W: Program #{name} is needed, but was not found in your PATH"
  end
end

program 'java'
program 'firefox'

