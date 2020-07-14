class DropStickerPendingFromBooks < ActiveRecord::Migration[6.0]
  def up
    change_table :books do |t|
      t.remove :sticker_pending
    end
  end

  def down
    change_table :books do |t|
      t.boolean :sticker_pending, default: true, null: false
    end
  end
end
