require 'csv'
class Book < ApplicationRecord
  validates :title, presence: true
  belongs_to :author, optional: true
  delegate :first_name, :middle_name, :last_name, :full_name, to: :author, prefix: true, allow_nil: true
  delegate :human, to: :model_name, prefix: true

  before_save :update_sticker_pending!

  module ReadingLevels
    ALL = %w[A B C P ML].freeze
  end

  module AviLevels
    ALL = %w[
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
    ].freeze
  end

  def update_sticker_pending!
    return unless (changes.keys & %w[title series part reading_level author_id]).present?

    self.sticker_pending = true
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
        if term.in?(Book::ReadingLevels::ALL)
          "books.reading_level = '#{term}'"
        elsif term.in?(Book::AviLevels::ALL)
          "books.avi_level = '#{term}'"
        else
          [
            %i[books title],
            %i[books series],
            %i[books category],
            %i[authors first_name],
            %i[authors last_name],
          ].map do |table, field|
            "#{table}.#{field} ilike '%#{term}%'"
          end.join(" or ")
        end
      end.map { |v| "(#{v})" }.join(" and ")
      where(clause).left_joins(:author).pluck(:id)
    end

    def to_csv(io = StringIO.new)
      csv_options = { col_sep: ';' }
      mapping = {
        id:                 Book.human_attribute_name(:id),
        model_name_human:   Book.human_attribute_name(:sti_type),
        title:              Book.human_attribute_name(:title),
        series:             Book.human_attribute_name(:series),
        part:               Book.human_attribute_name(:part),
        category:           Book.human_attribute_name(:category),
        reading_level:      Book.human_attribute_name(:reading_level),
        avi_level:          Book.human_attribute_name(:avi_level),
        sticker_pending:    Book.human_attribute_name(:sticker_pending),
        author_id:          "#{Book.human_attribute_name(:author)} #{Author.human_attribute_name(:id)}",
        author_first_name:  "#{Book.human_attribute_name(:author)} #{Author.human_attribute_name(:first_name)}",
        author_middle_name: "#{Book.human_attribute_name(:author)} #{Author.human_attribute_name(:middle_name)}",
        author_last_name:   "#{Book.human_attribute_name(:author)} #{Author.human_attribute_name(:last_name)}",
      }
      io.puts CSV.generate_line(mapping.values, csv_options)
      find_each do |record|
        row = mapping.keys.map { |f| record.public_send(f) }.map(&:presence)
        io.puts CSV.generate_line(row, csv_options)
      end
      io.string
    end
  end
end
