class BookAutocompleteChannel < ApplicationCable::Channel
  RESULT_LIMIT = 25

  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search_title(filter)
    titles = Book.limit(RESULT_LIMIT).order("title ASC").ransack(filter).result(distinct: true).pluck(:title)
    broadcast_to(current_user, action: :search_title, titles: titles)
  end

  def search_series(filter)
    series = Book.limit(RESULT_LIMIT).order("series ASC").ransack(filter).result(distinct: true).pluck(:series)
    broadcast_to(current_user, action: :search_series, series: series)
  end
end
