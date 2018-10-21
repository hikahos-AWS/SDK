require 'aws-sdk'

s3 = Aws::S3::Client.new

# Get the first page of data
response = s3.list_objects(bucket: 's3-us-east-1-d-test1')

# Get additional pages
while response.next_page? do
  response = response.next_page
  # Use the response data here...
end
