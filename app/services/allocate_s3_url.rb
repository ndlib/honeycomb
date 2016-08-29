class AllocateS3Url
  attr_reader :uid, :filename

  def initialize(uid, filename)
    @filename = filename
    @uid = uid
  end

  def self.presigned_url(uid, filename)
    new(uid, filename).generate_presigned_url
  end

  def self.public_url(uid, filename)
    new(uid, filename).generate_public_url
  end

  def generate_presigned_url
    bucket_object.presigned_url(:put, expires_in: 3600)
  end

  def generate_public_url
    bucket_object.public_url
  end

  def file_name
    "#{uid}#{file_extension}"
  end

  private

  def bucket_object
    bucket.object(file_name)
  end

  def bucket
    s3.bucket(bucket_name)
  end

  def file_extension
    Pathname.new(filename).extname
  end

  def bucket_name
    configuration["bucket"]
  end

  def s3
    # Force a reload of the shared config each time, otherwise we won't get any new rotated creds
    # https://github.com/aws/aws-sdk-ruby/blob/e9276ee29af123384304848381698ffd307b1533/aws-sdk-core/lib/aws-sdk-core/shared_credentials.rb#L25
    Aws.shared_config.fresh
    credentials = Aws::SharedCredentials.new(profile_name: configuration["profile"])
    client = Aws::S3::Client.new(region: configuration["region"], credentials: credentials)
    @s3 ||= Aws::S3::Resource.new(client: client)
  end

  def configuration
    @configuration ||= Rails.configuration.settings.aws
  end
end
