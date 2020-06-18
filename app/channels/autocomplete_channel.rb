class AutocompleteChannel < ApplicationCable::Channel
  RESULT_LIMIT = 25

  def channel_room_key
    "#{broadcasting_for(current_user)}_#{params[:room]}"
  end

  def subscribed
    stream_from channel_room_key
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search_book_title(filter)
    titles = Book.limit(RESULT_LIMIT).order(:title).ransack(filter).result(distinct: true).pluck(:title)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_title, titles: titles)
  end

  def search_book_series(filter)
    series = Book.limit(RESULT_LIMIT).order(:series).ransack(filter).result(distinct: true).pluck(:series)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_series, series: series)
  end

  def search_author(filter)
    authors = Author.limit(RESULT_LIMIT).order(:first_name, :middle_name, :last_name).ransack(filter).result(distinct: true).map { |author| { id: author.id, description: author.description } }
    ActionCable.server.broadcast(channel_room_key, action: :search_author, authors: authors)
  end

  def search_book(filter)
    books = Book.limit(RESULT_LIMIT).order(:title, :id).ransack(filter).result(distinct: true).map { |book| { id: book.id, description: book.description } }
    ActionCable.server.broadcast(channel_room_key, action: :search_book, books: books)
  end

  def search_lender(filter)
    lenders = Lender.limit(RESULT_LIMIT).order(:first_name, :middle_name, :last_name, :group_name).ransack(filter).result(distinct: true).map { |lender| { id: lender.id, description: lender.description } }
    ActionCable.server.broadcast(channel_room_key, action: :search_lender, lenders: lenders)
  end
end
