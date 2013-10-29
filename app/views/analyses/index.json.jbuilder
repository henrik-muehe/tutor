json.array!(@analyses) do |analysis|
  json.extract! analysis, :name, :query, :admin
  json.url analysis_url(analysis, format: :json)
end
