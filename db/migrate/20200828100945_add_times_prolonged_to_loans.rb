class AddTimesProlongedToLoans < ActiveRecord::Migration[6.0]
  def change
    change_table :loans do |t|
      t.integer :times_prolonged, default: 0
    end
  end
end
