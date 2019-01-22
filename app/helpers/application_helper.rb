module ApplicationHelper
  def search_result_info(records)
    from_item = (records.current_page - 1) * records.limit_value + 1
    to_item = [from_item + records.size - 1, records.total_count].min
    from_item = 0 if records.total_count.zero?
    "#{from_item} - #{to_item} / #{records.total_count}"
  end
end
