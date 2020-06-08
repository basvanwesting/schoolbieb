module ApplicationHelper
  def inline_search_form_for(*args, **options, &block)
    merged_options = options.merge(wrapper: :inline_search_form)
    search_form_for(*args, merged_options, &block)
  end

  def search_row(&blk)
    content = capture(&blk)
    content_tag(:tr, content,  class: ['search', @q.conditions.present? ? 'conditions-present' : ''] )
  end

  def search_result_info(records)
    from_item = (records.current_page - 1) * records.limit_value + 1
    to_item = [from_item + records.size - 1, records.total_count].min
    from_item = 0 if records.total_count.zero?
    "#{from_item} - #{to_item} / #{records.total_count}"
  end

  def category_with_icon(category)
    [
      content_tag(:i, nil, class: "fas #{Book::NonFiction::Categories.fas_icon_for(category)}", style: "margin-right: 1rem"),
      content_tag(:span, category),
    ].join.html_safe
  end
end
