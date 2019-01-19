class AddJsonToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :data, :json
  end
end
