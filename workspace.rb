
mismatched_books_fiction = []
Book::Fiction.includes(:author).find_each do |book|
  result = Book::Fiction.ransack(id_book_wildcard: book.description).result
  if result == [book]
    #OK
  else
    mismatched_books_fiction << book
  end
end
mismatched_books_fiction.each { |b| puts b.description }

mismatched_books_non_fiction = []
Book::NonFiction.find_each do |book|
  result = Book::NonFiction.ransack(id_book_wildcard: book.description).result
  if result == [book]
    #OK
  else
    mismatched_books_non_fiction << book
  end
end
mismatched_books_non_fiction.each { |b| puts b.description }

mismatched_lenders = []
Lender.find_each do |lender|
  result = Lender.ransack(id_lender_wildcard: lender.description).result
  if result == [lender]
    #OK
  else
    mismatched_lenders << lender
  end
end
mismatched_lenders.each { |b| puts b.description }

mismatched_authors = []
Author.find_each do |author|
  result = Author.ransack(id_author_wildcard: author.description).result
  if result == [author]
    #OK
  else
    mismatched_authors << author
  end
end
mismatched_authors.each { |b| puts b.description }
mismatched_authors.each do |author|
  result = Author.ransack(id_author_wildcard: author.description).result
  puts "#{author.description} => [#{result.map(&:description).join(' :: ')}]"
end
