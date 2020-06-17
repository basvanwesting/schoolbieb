class AuthorAutocompleteChannel < ApplicationCable::Channel
  RESULT_LIMIT = 25

  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search(filter)
    data = Author.limit(RESULT_LIMIT).ransack(filter).result(distinct: true).map { |author| { id: author.id, full_name: author.full_name } }
    broadcast_to(current_user, data)
  end
end
