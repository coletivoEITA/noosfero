namespace :spork do

  SPORK_PORT = (ENV['SPORK_PORT'] || 8988).to_i
  FRAMEWORKS = %w[testunit rspec cucumber]

  desc "Start all Spork frameworks"
  task 'start' => FRAMEWORKS.map{ |f| "spork:#{f}:start" }

  desc "Stop all Spork frameworks"
  task 'stop' => FRAMEWORKS.map{ |f| "spork:#{f}:stop" }

  desc "Restart all Spork frameworks"
  task 'restart' => FRAMEWORKS.map{ |f| "spork:#{f}:restart" }

  FRAMEWORKS.each do |framework|
    namespace framework do

      desc "Start Spork #{framework}"
      task 'start' do
        start framework
      end

      desc "Stop Spork #{framework}"
      task 'stop' do
        stop framework
      end

      desc "Restart Spork #{framework}"
      task 'restart' do
        stop framework
        start framework
      end

    end
  end

  def start(framework, options = {})
    if is_port_open?('127.0.0.1', SPORK_PORT)
      puts "Spork port #{SPORK_PORT} is already open"
      return
    end

    # run
    pid = spawn "spork #{framework} -p #{SPORK_PORT}"
    # wait until spork is ready
    while ! is_port_open?('127.0.0.1', SPORK_PORT); end
    # write pid file
    File.open(pid_path(framework), "w") { |file| file.write pid }
  end

  def stop(framework, options = {})
    path = pid_path(framework)
    pid = File.read(path).to_i
    rm path

    puts "Stopping Spork at pid #{pid}"
    Process.kill("INT", pid)
    sleep 1
  end

  def pid_path(framework)
    pid_dir = File.join("tmp/pids")
    system "mkdir -p #{pid_dir}"
    pidfile = File.join(pid_dir, "spork_#{framework}.pid")
  end

  def spawn(*args)
    fork do
      Process.setpgrp
      exec *args 
    end
  end

  # from http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open
  require 'socket'
  require 'timeout'
  def is_port_open?(ip, port, timeout = 1)
    begin
      Timeout::timeout(timeout) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end

end
