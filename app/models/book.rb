class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true

  before_save :extend_title!

  module ReadingLevels
    All = %w[ A B C P ML ]
  end

  module AviLevels
    All = %w[
      START
      M3
      E3
      M4
      E4
      M5
      E5
      M6
      E6
      M7
      E7
      PLUS
    ]
  end

  def unextended_title
    title.sub(/\[\[.*?\]\]/,'')
  end

  def extended_title?
    title.to_s[/\[\[.*\]\]$/]
  end

  def extended_title
    return title if extended_title?
    enrichment = [
      reading_level.present? ? reading_level  : nil,
      avi_level.present?     ? avi_level      : nil,
      part.present?          ? "deel #{part}" : nil,
    ].compact.join(' | ')
    "#{title} [[#{enrichment}]]"
  end

  def extend_title!
    return if extended_title?
    self.title = extended_title
  end

  def sticker
    <<~DOC
      ID: #{id.to_s.rjust(4, '0')}
      #{author.full_name}
      #{title} #{part.present? ? "(deel #{part})" : nil}
      #{series}
      #{reading_level} / #{avi_level}
    DOC
  end

  class << self
    def wildcard_search(v)
      terms = v.split.map(&:upcase)
      clause = terms.map do |term|
        if term.in?(Book::ReadingLevels::All)
          "books.reading_level = '#{term}'"
        elsif term.in?(Book::AviLevels::All)
          "books.avi_level = '#{term}'"
        else
          [
            [:books,   :title],
            [:books,   :series],
            [:authors, :first_name],
            [:authors, :last_name],
          ].map do |table, field|
            "#{table}.#{field} ilike '%#{term}%'"
          end.join(" or ")
        end
      end.map { |v| "(#{v})" }.join(" and ")
      where(clause).joins(:author).pluck(:id)
    end
  end
end
