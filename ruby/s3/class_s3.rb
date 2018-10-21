class AwsS3
  require 'aws-sdk-s3'
  require 'aws-sdk-ec2'
  
  attr_reader :region, :buckets

  def initialize(region =nil, buckets = nil)
    # @regions = list_regions.to_a
    @region = 'us-east-1'
    # @buckets = list_buckets.to_a
    # @bucket_objects = list_bucket_objects.to_a
  end
  
  def get_buckets
    bucket_name = nil
    bucket_creation = nil
    bucket_owner = nil

    s3 = Aws::S3::Client.new(region: @region)
    buckets = s3.list_buckets.to_h
    buckets.each do |key, value|
      value.each do |key, value|
        if key.kind_of?(Hash) == true
	  bucket_name = key[:name].to_s
	  bucket_creation = key[:creation_date].to_s
	elsif key.to_s == 'display_name'
	  bucket_owner = value.to_s
        end
      end
    end
    puts "bucket name: #{bucket_name}, creation date: #{bucket_creation}, owner: #{bucket_owner}"
  end
	
  private

  def list_regions
    regionsArr = []
    # instantiate an ec2 client object
    ec2 = Aws::EC2::Client.new()
    # retrieve a list of regions
    regions = ec2.describe_regions().to_h
    regions.each do |key,value|
      parentVal = value
      parentVal.each do |key,value|
        region = key[:region_name]
        # push the region to the @regions array
        regionsArr << region
      end
    end
    regionsArr
  end

  def list_buckets
    bucketsArr = []
    # @regions.each do |region|
      # instantiate a client object
      client = Aws::S3::Client.new(region: @region)
      # pass client object to s3 resource
      s3 = Aws::S3::Resource.new(client: client)
      s3.buckets.each do |bucket|
        bucketsArr << bucket.name
      end
    # end
    bucketsArr
  end

  def list_bucket_objects
    objects_arr = []
    #@regions.each do |region|
      # instantiate a client object
      client = Aws::S3::Client.new(region: @region)
      # pass client object to s3 resource
      # s3 = Aws::S3::Resource.new(client: client)
      @buckets.each do |bucket|
        object_keys = client.list_objects_v2(bucket: bucket).to_h
        object_keys.each do |_key1, value1|
          next unless value1.is_a?(Array) == true
          value1.each do |key2, _value2|
            object_key = key2[:key]
            if object_key.to_s.include?('.') && !object_key.to_s.include?('.json.gz')
              #puts "s3://#{bucket}/#{object_key}"
              objects_arr << object_key
            end
          end
        end
      end
    #end
    objects_arr
  end
end
