class Media < ActiveRecord::Base
  attr_accessor :serializer
  belongs_to :collection
  has_many :items
  validates :collection, presence: true

  has_paper_trail

  def to_json
    if serializer
      serializer.to_json(media: self)
    else
      super
    end
  end
end
