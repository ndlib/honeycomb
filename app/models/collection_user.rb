class CollectionUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection
end
