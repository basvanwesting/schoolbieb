class Vacation < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date,   presence: true
  validates :due_date,   presence: true
end
