class AddPartToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :part, :integer
  end
end
