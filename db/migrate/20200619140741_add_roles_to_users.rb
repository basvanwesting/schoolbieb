class AddRolesToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :roles, array: true, default: []
    end
  end
end
