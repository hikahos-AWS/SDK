require 'aws-sdk'

ec2 = Aws::EC2::Client.new

begin
  ec2.wait_until(:instance_running, instance_ids:['i-0117e081b54bdf2eb']) do |w|
    w.max_attempts = 5
    w.delay = 5
  end
  puts "instance running"
rescue Aws::Waiters::Errors::WaiterFailed => error
  puts "failed waiting for instance running: #{error.message}"
end
