# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'cucumber' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard :test, :dri => true,
  #:cli => '-n /thumbnails_were/', # uncomment to select tests
  :all_on_start => false, :all_after_pass => false, :keep_failed => false do

  watch(%r{^test/.+_test\.rb$})

  watch('test/test_helper.rb')                       { "test" }
  watch(%r{^lib/(.+)\.rb$})                          { |m| "test/unit/#{m[1]}_test.rb" }
  # Rails 
  watch(%r{^app/helpers/(.+)\.rb$})                  { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(?:.*/)?(.+)\.rb$})      { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{^app/views/(?:.*/)?.+\.rb$})              { "test/integration" }
  watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
end

