json.array!(@students) do |student|
  json.extract! student, :firstname, :lastname, :email, :matrnr
  json.url student_url(student, format: :json)
end
