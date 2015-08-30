require "attr_tracker/engine"

module AttrTracker
  module Trackable
    extend ActiveSupport::Concern
    module ClassMethods

      # Stores trackable attributes in instance variable
      def tracks(*attrs)
        @tracked_attrs = [] if @tracked_attrs.nil?

        attrs.each do |attribute|
          @tracked_attrs << attribute if self.column_names.include?(attribute.to_s) && @tracked_attrs.exclude?(attribute)
        end

        before_save :save_changes
      end

      # Returns an array of tracked attributes
      def tracked
        @tracked_attrs
      end

    end

    # Creates a new Change object for each tracked attribute
    def save_changes
      self.class.tracked.each do |attribute|
        if change = self.changes[attribute]
          Change.create(
            before: change.first,
            after: change.last,
            trackable_id: self.id,
            trackable_type: self.class.to_s,
            attr_name: attribute
          )
        end
      end
    end
  end
end
