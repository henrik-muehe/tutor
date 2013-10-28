# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.buildCalendar = (id,events,onClick)->
	# Build calendar
	$("##{id}").fullCalendar
		header:
			left: ''
			center: ''
			right: ''
		events: events
		eventTextColor: '#000000'
		defaultView: 'agendaWeek'
		editable: false
		weekends: false
		firstDay: 1
		minTime: 7
		maxTime: 19
		allDaySlot: false
		timeFormat:
			agenda: 'H:mm{ - H:mm}'
			'': 'H(:mm)t'
		eventClick: onClick
		columnFormat:
			week: 'ddd'
	$("##{id}").fullCalendar 'gotoDate',2012,9,1
