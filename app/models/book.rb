class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true

  def sticker
    <<-DOC.strip_heredoc
      laksjdlak
      lkajsdlk
      lakdjlakjdlajsdlasj
      klsjd laskdjlka
    DOC
  end
end
