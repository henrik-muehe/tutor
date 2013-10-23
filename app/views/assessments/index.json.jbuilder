json.array!(@assessments) do |assessment|
  json.extract! assessment, :student_id, :user_id, :value, :remark, :week
  json.url assessment_url(assessment, format: :json)
end
