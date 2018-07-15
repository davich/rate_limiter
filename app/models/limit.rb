class Limit < ApplicationRecord
  def increment!
    self.class.where(key: key).update_all("hits = hits + 1")
  end
end
