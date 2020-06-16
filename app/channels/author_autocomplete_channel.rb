class AuthorAutocompleteChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search(*args)
    p "called AuthorAutocompleteChannel#search with: #{args.inspect}"
    AuthorAutocompleteChannel.broadcast_to(current_user, ["AuthorAutocompleteChannel#search", current_user.id])
  end
end
