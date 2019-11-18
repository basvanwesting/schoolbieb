class AddStiTypeToBooks < ActiveRecord::Migration[5.2]
  def change
    change_table :books do |t|
      t.string :sti_type
    end

    execute <<~SQL
      update books
      set
        sti_type = 'Book::Fiction'
    SQL
  end
end
