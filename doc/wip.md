* add search#q storage in session
* add exception notification
* add feature specs
* refactor ajax to allow for auther lookup in the same manner

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
