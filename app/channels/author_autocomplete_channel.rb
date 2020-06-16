class AuthorAutocompleteChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search(filter)
    data = Author.ransack(filter).result(distinct: true).map { |author| { id: author.id, full_name: author.full_name } }
    broadcast_to(current_user, data)
  end
end
