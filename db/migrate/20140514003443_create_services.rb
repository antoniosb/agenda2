class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, null: false, default: "default"
      t.float :price, null: false, default: 0
      t.integer :duration, default: 0, null: false
      t.float :discount

      t.timestamps
    end
  end
end
