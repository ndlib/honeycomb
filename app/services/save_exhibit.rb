class SaveExhibit
  attr_reader :params, :exhibit

  def self.call(exhibit, params)
    new(exhibit, params).save
  end

  def initialize(exhibit, params)
    @params = params
    @exhibit = exhibit
  end

  def save
    exhibit.attributes = params

    (exhibit.save && update_honeypot_image)
  end

  private

  def update_honeypot_image
    if params[:image]
      SaveHoneypotImage.call(exhibit)
    else
      true
    end
  end
end
