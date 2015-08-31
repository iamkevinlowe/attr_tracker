require "attr_tracker/engine"

module AttrTracker
  module Trackable
    extend ActiveSupport::Concern
    module ClassMethods

      def tracks(*attrs)
        @tracked_attrs = [] if @tracked_attrs.nil?

        attrs.each do |attribute|
          # Stores trackable attributes in instance variable
          @tracked_attrs << attribute if self.column_names.include?(attribute.to_s) && @tracked_attrs.exclude?(attribute)

          # Creates instance method returning all changes of an attribute
          define_method "#{attribute}_changes" do
            Change.where(
              "trackable_id = ? AND
              trackable_type = ? AND
              attr_name = ?",
              self.id,
              self.class.to_s,
              attribute
            )
          end

          # Creates instance method returning changes of an attribute between two dates
          define_method "#{attribute}_between" do |start_date, end_date|
            Change.where(
              "trackable_id = ? AND
              trackable_type = ? AND
              attr_name = ? AND
              created_at > ? AND < ?",
              self.id,
              self.class.to_s,
              attribute,
              start_date,
              end_date
            )
          end
        end

        # Before save hook to create attribute changes
        before_save :save_changes
      end

      # Returns an array of tracked attributes
      def tracked
        @tracked_attrs
      end
    end

    private

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

# Includes AttrTracker::Trackable to ActiveRecord::Base
module ActiveRecord
  class Base
    include AttrTracker::Trackable
  end
end