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

  private

  def bucket_object
    bucket.object("#{uid}#{file_extension}")
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
    credentials = Aws::Credentials.new(configuration["access_key_id"], configuration["secret_access_key"])
    client = Aws::S3::Client.new(region: configuration["region"], credentials: credentials)
    @s3 ||= Aws::S3::Resource.new(client: client)
  end

  def configuration
    @configuration ||= Rails.application.secrets.aws
  end
end
