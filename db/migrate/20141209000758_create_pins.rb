class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.integer :story_id
      t.integer :user_id

      t.timestamps
    end
  end
end
