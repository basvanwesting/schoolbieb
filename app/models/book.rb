class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true

  module ReadingLevels
    All = %w[ A B C P ]
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

  def sticker
    <<~DOC
      ID: #{id.to_s.rjust(4, '0')}
      #{author.full_name}
      #{title}
      #{series}
      #{reading_level} / #{avi_level}
    DOC
  end
end
