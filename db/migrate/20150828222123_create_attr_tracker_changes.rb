class CreateAttrTrackerChanges < ActiveRecord::Migration
  def change
    create_table :attr_tracker_changes do |t|
      t.text :before
      t.text :after
      t.integer :trackable_id
      t.string :trackable_type

      t.timestamps null: false
    end
  end
end
