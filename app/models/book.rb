require 'csv'
class Book < ApplicationRecord
  validates :title, presence: true
  belongs_to :author, optional: true
  delegate :first_name, :middle_name, :last_name, :full_name, to: :author, prefix: true, allow_nil: true

  before_save :update_sticker_pending!

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

  def update_sticker_pending!
    if (changes.keys & %w[title series part reading_level author_id]).present?
      self.sticker_pending = true
    end
  end

  def unset_sticker_pending!
    update(sticker_pending: false)
  end

  def set_sticker_pending!
    update(sticker_pending: true)
  end

  class << self

    def classes
      [
        Book::Fiction,
        Book::NonFiction,
      ]
    end

    def wildcard_search(v)
      terms = v.split.map(&:upcase)
      clause = terms.map do |term|
        if term.in?(Book::ReadingLevels::All)
          "books.reading_level = '#{term}'"
        elsif term.in?(Book::AviLevels::All)
          "books.avi_level = '#{term}'"
        elsif term.downcase.in?(Book::NonFiction::Categories::All.map(&:downcase))
          "books.category ilike '#{term}'"
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
      where(clause).left_joins(:author).pluck(:id)
    end

    def to_csv(io = StringIO.new)
      csv_options = { col_sep: ';' }
      fields = %w[
        id
        title
        series
        part
        reading_level
        avi_level
        sticker_pending
        author_id
        author_first_name
        author_middle_name
        author_last_name
      ]
      io.puts CSV.generate_line(fields, csv_options)
      find_each do |record|
        row = fields.map {|f| record.public_send(f) }.map(&:presence)
        io.puts CSV.generate_line(row, csv_options)
      end
      io.string
    end
  end
end
