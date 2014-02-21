json.array!(@exams) do |exam|
  json.extract! exam, :id, :name, :start, :original_import
  json.url exam_url(exam, format: :json)
end
