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

  def search_book_fiction_title(filter)
    titles = Book::Fiction.limit(RESULT_LIMIT).order(:title).ransack(filter).result(distinct: true).pluck(:title)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_fiction_title, titles: titles)
  end

  def search_book_fiction_series(filter)
    series = Book::Fiction.limit(RESULT_LIMIT).order(:series).ransack(filter).result(distinct: true).pluck(:series)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_fiction_series, series: series)
  end

  def search_book_non_fiction_title(filter)
    titles = Book::NonFiction.limit(RESULT_LIMIT).order(:title).ransack(filter).result(distinct: true).pluck(:title)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_non_fiction_title, titles: titles)
  end

  def search_book_non_fiction_series(filter)
    series = Book::NonFiction.limit(RESULT_LIMIT).order(:series).ransack(filter).result(distinct: true).pluck(:series)
    ActionCable.server.broadcast(channel_room_key, action: :search_book_non_fiction_series, series: series)
  end

  def search_author(filter)
    authors = Author.limit(RESULT_LIMIT).order(:first_name, :middle_name, :last_name).ransack(filter).result(distinct: true).map { |author| { id: author.id, description: author.description } }
    full_description_match = authors.detect { |author| author[:description] == filter["id_author_wildcard"] }
    authors = full_description_match ? [full_description_match] : authors
    ActionCable.server.broadcast(channel_room_key, action: :search_author, authors: authors)
  end

  def search_book(filter)
    books = Book.limit(RESULT_LIMIT).order(:title, :id).ransack(filter).result(distinct: true).map { |book| { id: book.id, description: book.description } }
    full_description_match = books.detect { |book| book[:description] == filter["id_book_wildcard"] }
    books = full_description_match ? [full_description_match] : books
    ActionCable.server.broadcast(channel_room_key, action: :search_book, books: books)
  end

  def search_lender(filter)
    lenders = Lender.limit(RESULT_LIMIT).order(:first_name, :middle_name, :last_name, :group_name).ransack(filter).result(distinct: true).map { |lender| { id: lender.id, description: lender.description } }
    full_description_match = lenders.detect { |lender| lender[:description] == filter["id_lender_wildcard"] }
    lenders = full_description_match ? [full_description_match] : lenders
    ActionCable.server.broadcast(channel_room_key, action: :search_lender, lenders: lenders)
  end
end
