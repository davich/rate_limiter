class CreateLimits < ActiveRecord::Migration[5.2]
  def change
    create_table :limits do |t|
      t.string :key
      t.integer :hits

      t.timestamps
    end

    add_index :limits, :key, unique: true
  end
end
