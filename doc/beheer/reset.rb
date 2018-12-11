Book.destroy_all
Author.destroy_all

middle_regexp = /\s[a-z]+(\s[a-z]+)?/
last_regexp = /\s[A-Za-z]+$/
File.open('doc/authors.txt').each_line do |line|
  line.strip!
  last_name, first_and_middle_name = line.split(',',2)
  last_name = last_name.to_s.strip
  first_and_middle_name = first_and_middle_name.to_s.strip

  middle_name = first_and_middle_name[middle_regexp].to_s

  first_and_middle_name.gsub!(middle_name, '') if middle_name.present?
  first_name = first_and_middle_name

  first_name  = first_name.strip.capitalize
  middle_name = middle_name.strip.downcase
  last_name   = last_name.strip.capitalize

  if first_name.present? && last_name.present?
    Author.create(
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
    )
  end
end
