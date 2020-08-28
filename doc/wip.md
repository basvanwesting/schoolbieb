* Add exception notification
* Scope title/series autocomplete to fiction/non_fiction
* Add version to GUI
* Add times_prolonged to loan
* Add vakantie dagen, om due-dates over te slaan.
* Add rack-attach WAF
* Migrate from us to europe region
* Add scheduled task to belate books

# Stickers code snippet
- @books.each_slice(1) do |books_for_page|
  - books_for_page.each do |book|
    .grid-y style="height: 40em;"
      .cell
        .grid-x.grid-margin-x
          .cell.medium-2 style="font-size: 18em;"
            i class="fas #{Book::NonFiction::Categories.fas_icon_for(book.category)}"
          .cell.medium-6 style="font-size: 4.0em; line-height: 1.1em; text-align: right;"
            = book.id.to_s.rjust(4, '0')
          .cell.medium-4 style="text-align: right;"
            - qrcode = RQRCode::QRCode.new(qr_book_url(book))
            = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 11).html_safe
  .page-break
