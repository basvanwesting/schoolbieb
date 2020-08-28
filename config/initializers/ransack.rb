require 'ransack/helpers'

Ransack.configure do |config|
  config.add_predicate 'eq_any_split_whitespace', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| v.to_s.split(/\s+/).select(&:present?) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string

  config.add_predicate 'book_wildcard', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| Book.wildcard_search(v) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string

  config.add_predicate 'author_wildcard', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| Author.wildcard_search(v) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string

  config.add_predicate 'lender_wildcard', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| Lender.wildcard_search(v) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string

  config.add_predicate(
    # produces queries in the form of `WHERE (unaccent (column)) ILIKE unaccent (%foo%bar%)`
    'cont',
    arel_predicate: 'ai_imatches', # <- thanks arel_extensions !
    formatter: proc { |s| ActiveSupport::Inflector.transliterate("%#{s.tr(' ', '%')}%") },
    validator: proc { |s| s.present? },
    compounds: true,
    type: :string
  )
end

Ransack::Helpers::FormBuilder.class_eval do
  def submit_search_form
    [
      submit('Search', class: 'button small', id: 'search_button'),
      @template.link_to('Reset', { reset_q: true }, class: 'search-reset button small secondary'),
    ].join.html_safe
  end
end
