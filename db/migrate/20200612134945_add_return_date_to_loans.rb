class AddReturnDateToLoans < ActiveRecord::Migration[5.2]
  def change
    change_table :loans do |t|
      t.date :return_date
    end
  end
end
