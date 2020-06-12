class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.belongs_to :book, foreign_key: true
      t.belongs_to :lender, foreign_key: true

      t.string :state
      t.date   :lending_date
      t.date   :due_date

      t.timestamps
    end
  end
end
