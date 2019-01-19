class AddNameToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :first_name, :string
    add_column :patients, :last_name, :string
  end
end
