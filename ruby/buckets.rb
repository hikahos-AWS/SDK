require 'aws-sdk-s3'

s3 = Aws::S3::Resource.new(region: 'us-east-1')

s3.buckets.limit(50).each do |b|
  puts "#{b.name}"
end
