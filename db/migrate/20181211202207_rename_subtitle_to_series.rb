class RenameSubtitleToSeries < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :subtitle, :series
  end
end
