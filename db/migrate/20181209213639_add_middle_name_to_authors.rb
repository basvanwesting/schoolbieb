class AddMiddleNameToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :middle_name, :string
  end
end
