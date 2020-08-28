Rack::Attack.blocklist("block all access by default") do |request|
  false
end

ENV['SAFELIST_IPS'].to_s.split(',').each do |safelist_ip|
  Rack::Attack.safelist_ip(safelist_ip)
end

if Rails.env.in? %w[development test]
  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  Rack::Attack.safelist('allow from localhost') do |req|
    # Requests are allowed if the return value is truthy
    '127.0.0.1' == req.ip || '::1' == req.ip
  end
end
