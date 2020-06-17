class AutocompleteChannel < ApplicationCable::Channel
  RESULT_LIMIT = 25

  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search_book_title(filter)
    titles = Book.limit(RESULT_LIMIT).order("title ASC").ransack(filter).result(distinct: true).pluck(:title)
    broadcast_to(current_user, action: :search_book_title, titles: titles)
  end

  def search_book_series(filter)
    series = Book.limit(RESULT_LIMIT).order("series ASC").ransack(filter).result(distinct: true).pluck(:series)
    broadcast_to(current_user, action: :search_book_series, series: series)
  end

  def search_author(filter)
    authors = Author.limit(RESULT_LIMIT).ransack(filter).result(distinct: true).map { |author| { id: author.id, full_name: author.full_name } }
    broadcast_to(current_user, action: :search_author, authors: authors)
  end
end
