class AddStateToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :aasm_state, :string
    add_column :patients, :complete_at, :timestamp
  end
end
