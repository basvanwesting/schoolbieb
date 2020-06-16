class BookAutocompleteChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search_title(filter)
    data = Book.order("title ASC").ransack(filter).result(distinct: true).pluck(:title)
    broadcast_to(current_user, data)
  end
end
