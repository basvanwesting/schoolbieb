class AddTagsToBooks < ActiveRecord::Migration[5.2]
  def change
    change_table :books do |t|
      t.string :tags, array: true, default: []
      t.index :tags, using: 'gin'
    end
  end
end
