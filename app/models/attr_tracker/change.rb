module AttrTracker
  class Change < ActiveRecord::Base
    belongs_to :trackable, polymorphic: true
  end
end
