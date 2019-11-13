class RemoveExtendedTitleFromBook < ActiveRecord::Migration[5.2]
  def up
    Book.find_each do |book|
      book.update_columns(
        title: book.title.sub(/\[\[.*?\]\]/,'').strip,
        series: book.series.strip
      )
    end
  end

  def down
    Book.find_each do |book|
      next if book.title.to_s[/\[\[.*\]\]$/]
      enrichment = [
        book.reading_level.present? ? book.reading_level  : nil,
        book.avi_level.present?     ? book.avi_level      : nil,
        book.part.present?          ? "deel #{book.part}" : nil,
      ].compact.join(' | ')
      book.update_columns(title: "#{book.title} [[#{enrichment}]]")
    end
  end
end
