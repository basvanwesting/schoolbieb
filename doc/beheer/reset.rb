Book.destroy_all
Author.destroy_all

middle_regexp = /\s[a-z]+(\s[a-z]+)?/
last_regexp = /\s[A-Za-z]+$/
File.open('doc/authors.txt').each_line do |line|
  line.strip!
  middle = line[middle_regexp].to_s
  line.gsub!(middle, '') if middle.present?
  last = line[last_regexp].to_s
  first = line.gsub(last, '').to_s if last.present?
  first ||= line.to_s

  first_name  = first.strip
  middle_name = middle.strip.presence
  last_name   = last.strip

  if first_name.present? && last_name.present?
    Author.create(
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
    )
  end
end
