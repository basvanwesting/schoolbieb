class AddStateToBooks < ActiveRecord::Migration[5.2]
  def change
    change_table :books do |t|
      t.string :state
      t.boolean :overdue, default: false
    end
    remove_column :loans, :state, :string

    Book.update_all(state: 'available')
  end
end
