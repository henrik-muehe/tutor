json.array!(@users) do |user|
  json.extract! user, :role
  json.url user_url(user, format: :json)
end
