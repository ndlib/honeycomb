module V1
  # Version 1 API
  class MediaController < APIController
    def create
      uuid = SecureRandom.hex
      render json: { uploadURL: AllocateS3Url.call(uuid, "filename.jpg") }
    end

    def update
    end

    def start_upload
    end

    def finsh_upload
    end
  end
end
