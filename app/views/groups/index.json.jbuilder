json.array!(@groups) do |group|
  json.extract! group, :name, :start, :user_id, :course_id
  json.url group_url(group, format: :json)
end
