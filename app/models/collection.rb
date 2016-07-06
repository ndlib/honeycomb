class Collection < ActiveRecord::Base
  has_many :items
  has_many :collection_users
  has_many :users, through: :collection_users
  has_many :showcases
  has_many :pages
  has_one :collection_configuration
  belongs_to :image

  validates :name_line_1, :unique_id, presence: true
  validates :url_slug, uniqueness: true, allow_nil: true

  has_paper_trail

  def name
    if name_line_2.present?
      "#{name_line_1} #{name_line_2}"
    else
      name_line_1
    end
  end

  def items_json_url
    "/api/collections/#{id}/items.json?include=image"
  end

  def item_json_url(item_id)
    "/api/collections/#{id}/items/#{item_id}.json?include=image"
  end
end
