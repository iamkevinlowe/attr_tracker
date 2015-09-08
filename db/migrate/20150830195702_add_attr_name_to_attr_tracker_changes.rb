class AddAttrNameToAttrTrackerChanges < ActiveRecord::Migration
  def change
    add_column :attr_tracker_changes, :attr_name, :string
  end
end
