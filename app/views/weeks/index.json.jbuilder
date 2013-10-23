json.array!(@weeks) do |week|
  json.extract! week, :start
  json.url week_url(week, format: :json)
end
