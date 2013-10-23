json.array!(@results) do |r|
	json.extract! r, :id, :firstname, :lastname, :email
end
