require "attr_tracker/engine"

module AttrTracker
  module Trackable
    extend ActiveSupport::Concerns
    module ClassMethods
      def tracks(*attrs)
        # store the attrs in an instance variable
        # set up a before_save (on update) hook that loops through the attrs and stores the changes for them
      end
    end
  end
end
