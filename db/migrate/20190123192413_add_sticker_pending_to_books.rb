class AddStickerPendingToBooks < ActiveRecord::Migration[5.2]
  def change
    change_table :books do |t|
      t.boolean :sticker_pending, null: false, default: true
    end
  end
end
