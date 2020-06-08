source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.x'
gem 'bootsnap', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
gem 'webpacker', '~> 5.x'
gem 'turbolinks'
gem 'jbuilder'

gem "slim-rails"
gem 'devise'
gem 'simple_form'
gem 'ransack'
gem 'kaminari'
gem 'rqrcode'
gem 'exception_notification'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'capybara-screenshot'
end
