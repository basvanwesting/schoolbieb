Ransack.configure do |config|
  config.add_predicate 'eq_any_split_whitespace', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| v.to_s.split(/\s+/).select(&:present?) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string

  config.add_predicate 'wildcard', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| Book.wildcard_search(v) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string
end
