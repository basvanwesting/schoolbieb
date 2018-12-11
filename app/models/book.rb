class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true

  def sticker
    <<~DOC
      ID: #{id.to_s.rjust(4, '0')}
      #{author.full_name}
      #{title}
      #{subtitle}
      #{reading_level} / #{avi_level}
    DOC
  end
end
