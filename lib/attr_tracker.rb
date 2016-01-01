require "attr_tracker/engine"

module AttrTracker
  module Trackable
    extend ActiveSupport::Concern
    module ClassMethods

      def tracks(*attrs)
        has_many :tracked_changes, class_name: "AttrTracker::Change", as: :trackable
        before_save :save_changes

        @tracked_attrs = [] if @tracked_attrs.nil?

        attrs.each do |attribute|
          @tracked_attrs << attribute if self.column_names.include?(attribute.to_s) && @tracked_attrs.exclude?(attribute)

          # Returns all :tracked_changes of an attribute
          define_method "#{attribute}_changes" do
            self.tracked_changes.where(attr_name: attribute)
          end

          # Returns the most recent :tracked_change of an attribute at or before the given date
          # Change 1 -> 2014-11-01
          # Change 2 -> 2013-11-03
          # attr_at('2014-11-02') => Change 1 (2014-11-01) version
          define_method "#{attribute}_at" do |date|
            self.tracked_changes.where(attr_name: attribute)
                                .where("created_at <= ?", date)
                                .order("created_at DESC")
                                .limit(1).first
          end

          # Returns all :tracked_changes of an attribute between two given dates
          define_method "#{attribute}_between" do |start_date, end_date|
            self.tracked_changes.where(attr_name: attribute)
                                .where("created_at > ? AND created_at < ?", start_date, end_date)

          end
        end
      end

      # Returns an array of tracked attributes
      def tracked
        @tracked_attrs
      end
    end

    private

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