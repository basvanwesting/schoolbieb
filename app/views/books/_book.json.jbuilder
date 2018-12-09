json.extract! book, :id, :name, :reading_level, :avi_level, :author_id, :created_at, :updated_at
json.url book_url(book, format: :json)
