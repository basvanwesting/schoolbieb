class CreateVacations < ActiveRecord::Migration[6.0]
  def change
    create_table :vacations do |t|
      t.date :start_date
      t.date :end_date
      t.date :due_date
    end
  end
end
