#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

ACTS_AS_SEARCHABLE_ENABLED = false if Rake.application.top_level_tasks.detect{|t| t == 'db:data:minimal'}

Noosfero::Application.load_tasks
