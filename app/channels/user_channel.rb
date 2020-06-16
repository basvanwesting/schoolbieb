class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{broadcasting_for(current_user)}_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search(*args)
    p "called UserChannel#search with: #{args.inspect}"
    ActionCable.server.broadcast("#{broadcasting_for(current_user)}_#{params[:room]}", ["UserChannel#search", current_user.id])
  end

  def search_author(*args)
    p "called UserChannel#search_author with: #{args.inspect}"
    ActionCable.server.broadcast("#{broadcasting_for(current_user)}_#{params[:room]}", ["UserChannel#search_author", current_user.id])
  end

  def search_book(*args)
    p "called UserChannel#search_book with: #{args.inspect}"
    ActionCable.server.broadcast("#{broadcasting_for(current_user)}_#{params[:room]}", ["UserChannel#search_book", current_user.id])
  end
end
