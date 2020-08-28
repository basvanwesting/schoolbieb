desc "This task is called by the Heroku scheduler add-on"
task :check_due_dates => :environment do
  puts "Check due-dates, belated book listed below:"
  belated_books = Book.check_due_dates!
  belated_books.each { |book| puts book.description }
  puts "Done."
end
