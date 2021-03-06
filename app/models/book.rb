require 'csv'
class Book < ApplicationRecord
  include AASM

  attr_accessor :author_description #for form

  belongs_to :author, optional: true
  has_many :loans, -> { order("id desc") }

  has_one :loan, -> { where(return_date: nil) }
  has_one :lender, through: :loan

  validates :title, presence: true

  delegate :first_name, :middle_name, :last_name, to: :author, prefix: true, allow_nil: true
  delegate :first_name, :middle_name, :last_name, :group_name, to: :lender, prefix: true, allow_nil: true
  delegate :lending_date, :due_date, :due_today?, to: :loan, prefix: true, allow_nil: true

  delegate :human, to: :model_name, prefix: true

  after_initialize :set_author_description #for form

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

  aasm column: :state do
    state :pending
    state :available, initial: true
    state :borrowed
    state :belated
    state :disabled

    event(:enable)  { transitions from: [:pending,:disabled], to: :available }
    event(:borrow)  { transitions from: :available,           to: :borrowed  }
    event(:return)  { transitions from: [:borrowed,:belated], to: :available }
    event(:prolong) { transitions from: [:borrowed,:belated], to: :borrowed  }
    event(:belate)  { transitions from: :borrowed,            to: :belated   }
    event(:disable) { transitions from: :available,           to: :disabled  }
  end

  # Needs to be unique, so record can matched based on description
  def description
    "#{title} (#{formatted_id})"
  end

  def formatted_id
    id.to_s.rjust(4, '0')
  end

  def set_author_description
    self.author_description ||= author&.description
  end

  class << self

    def classes
      [
        Book::Fiction,
        Book::NonFiction,
      ]
    end

    def check_due_dates!(date = Date.today)
      joins(:loans).
      where(state: 'borrowed').
      where(loans: { return_date: nil }).
      where("loans.due_date < ?", date).
      each(&:belate!)
    end

    def wildcard_search(v)
      terms = v.gsub(/[(),']/,' ').split.map(&:upcase)
      clause = terms.map do |term|
        [
          "books.reading_level = '#{term}'",
          "books.avi_level = '#{term}'",
          "unaccent(books.title) ilike unaccent('%#{term}%')",
          "unaccent(books.series) ilike unaccent('%#{term}%')",
          "unaccent(books.category) ilike unaccent('%#{term}%')",
          "unaccent(authors.first_name) ilike unaccent('%#{term}%')",
          "unaccent(authors.last_name) ilike unaccent('%#{term}%')",
          "cast(books.id as text) ilike '#{term.sub(/^0*/, '')}%'",
          "cast(books.part as text) = '#{term}'",
        ].join(" or ")
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
