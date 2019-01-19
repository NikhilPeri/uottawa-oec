class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.timestamp :predicted_time
      t.string :phone_number, null: false
      t.float :priority, null: false

      t.timestamps
    end
  end
end
