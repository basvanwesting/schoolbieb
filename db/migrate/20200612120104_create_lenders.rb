class CreateLenders < ActiveRecord::Migration[5.2]
  def change
    create_table :lenders do |t|
      t.string :identifier
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :group_name

      t.timestamps
    end
  end
end
