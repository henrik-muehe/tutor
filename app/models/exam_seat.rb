class ExamSeat < ActiveRecord::Base
	belongs_to :exam
	belongs_to :student
	belongs_to :room

	def split
		seat = seat_string.gsub(/^.*Reihe /, "").gsub("Platz ",":").split(":")
		seat.map { |v| (v.strip.match(/^[0-9]+$/) ? v.strip.to_i : v.strip) }
	end

	def row
		split.first
	end

	def seat
		split.last
	end
end
