class CollectionsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection
end
