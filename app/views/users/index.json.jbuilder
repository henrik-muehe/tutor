json.array!(@users) do |user|
  json.extract! user, :admin
  json.url user_url(user, format: :json)
end
