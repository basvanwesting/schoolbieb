Ransack.configure do |config|
  config.add_predicate 'wildcard', # Name your predicate
    arel_predicate: 'in',
    formatter: proc { |v| Book.wildcard_search(v) },
    validator: proc { |v| v.present? },
    compounds: false,
    wants_array: false,
    type: :string
end
