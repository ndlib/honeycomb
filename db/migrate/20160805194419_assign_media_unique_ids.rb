class AssignMediaUniqueIds < ActiveRecord::Migration
  def up
    Media.all.each do |media|
      media.uuid = SecureRandom.uuid
      media.save
    end
  end
end

class Media < ActiveRecord::Base
end
