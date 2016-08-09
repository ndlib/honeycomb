class AllocateS3Url
  attr_reader :uid, :filename

  def self.call(uid, filename)
    new(uid, filename).generate
  end

  def initialize(uid, filename)
    @filename = filename
    @uid = uid
  end

  def generate
    bucket_object.presigned_url(:put)
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
    @s3 ||= Aws::S3::Resource.new
  end

  def configuration
    @configuration ||= Rails.application.secrets.aws
  end
end
