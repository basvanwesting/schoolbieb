class AddSubtitleToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :subtitle, :string
    rename_column :books, :name, :title
  end
end
