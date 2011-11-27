# 2007 Copyright Susan Potter <me at susanpotter dot net>
# You can read her software development rants at: http://geek.susanpotter.net
# Released under CreativeCommons-attribution-noncommercial-sharealike license:
# http://creativecommons.org/licenses/by-nc-sa/1.0/
namespace :memcached do
  desc "Restart the Memcache daemon"
  task :restart, :roles => :app do
    deploy.memcached.stop
    deploy.memcached.start
  end

  desc "Start the Memcache daemon"
  task :start, :roles => :app do
    invoke_command "memcached -P #{current_path}/log/memcached.pid  -d", :via => run_method
  end

  desc "Stop the Memcache daemon"
  task :stop, :roles => :app do
    pid_file = "#{current_path}/log/memcached.pid"
    invoke_command("killall -9 memcached", :via => run_method) if File.exist?(pid_file)
  end
end
