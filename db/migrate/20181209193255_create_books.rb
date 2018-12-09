class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :reading_level
      t.string :avi_level
      t.belongs_to :author, foreign_key: true

      t.timestamps
    end
  end
end
