class RemoveBooksOverdue < ActiveRecord::Migration[6.0]
  def up
    change_table :books do |t|
      t.remove :overdue
    end
  end

  def down
    change_table :books do |t|
      t.boolean :overdue, default: false
    end
  end
end
