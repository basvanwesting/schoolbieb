part_regexp = /(\(|\s)deel\s?\d+(\s*\))?/i

File.open('doc/books.txt').each_line do |line|
  begin
    line.strip!
    _id, _index, _schrijver, titel, reeks, info, bouw, _rest = line.split(';')

    titel = titel.to_s.strip
    reeks = reeks.to_s.strip
    info  = info.to_s.strip
    bouw  = bouw.to_s.strip
    part  = nil

    if (part_section = reeks[part_regexp])
      part = part_section[/\d+/].to_i
      reeks = reeks.gsub(part_section,'').strip
    end
    if (part_section = titel[part_regexp])
      part = part_section[/\d+/].to_i
      titel = titel.gsub(part_section,'').strip
    end

    begin
      reeks_regexp = Regexp.new("^#{reeks}", Regexp::IGNORECASE)
      titel = titel.gsub(reeks_regexp,'').strip
      unless titel.present?
        titel = reeks
        reeks = ''
      end
    rescue
      #noop
    end

    puts [
      titel,
      reeks,
      part,
      info,
      bouw,
    ].inspect
  rescue => e
    puts line
    raise e
  end
end
