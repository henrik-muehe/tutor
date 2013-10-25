# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.tutorial = (group_id) =>
	wheel.init();

	$("#tutorial_group_id").change => window.location = "/tutorial/?group_id="+$("#tutorial_group_id").val()
	$("#tutorial_course_id").change => window.location = "/tutorial/?course_id="+$("#tutorial_course_id").val()
	$("#tutorial_week_id").change => window.location = "/tutorial/?week_id="+$("#tutorial_week_id").val()

	bind = =>
		$(".point-adjust").click (e) =>
			el = $(e.currentTarget)
			form = el.closest("form")
			input = form.find("input[type=text]")

			# Change visible points
			newValue = parseInt(input.val()) + parseInt(el.attr("data-value"))
			newValue = if newValue < -1 then -1 else newValue
			input.val(newValue)

			# Push to server
			$.post "/tutorial/assess", $(form).serialize(), ((data) => ), 'json'

		# Tooltips
		$(".enable-tooltip").tooltip
			placement: "bottom"
			container: "body" 

	sort = =>
		#$(".enable-tooltip").tooltip('destroy')
		rows = $.makeArray($("tbody tr").remove())
		$(rows).removeClass('warning')
		$(rows).removeClass('danger')
		rows.sort (a,b) =>
			an = $(a).find("td.lastname").text()
			bn = $(b).find("td.lastname").text()
			return if an < bn then -1 else 1
		[a,b] = [[],[]]
		for r in rows 
			$(r).attr("title",$(r).attr("data-original-title"))
			points = parseInt($(r).find("input[type=text]").val())
			if points < 0 || $(r).attr("data-othergroup") == "1" then b.push(r) else a.push(r)
		$(a).addClass('warning')
		$(b).addClass('danger')
		rows = a.concat(b)
		$(r).find("td.count").text(parseInt(index)+1) for index,r of rows
		$("table tbody").append($(rows))
		bind()

	sort()
	$("#sort").click sort

	$("#random").click =>
		wheel.segments = []
		for r in $("tbody tr")
			points=$(r).find("input[type=text]").val()
			lastname=$(r).find("td.lastname").text()
			firstname=$(r).find("td.firstname").text()
			if points >= 0 && $(r).attr("data-othergroup") != "1"
				wheel.segments.push "#{firstname} #{lastname}"
		if wheel.segments.length > 0
			$("#wheel").modal('show')
			wheel.update();
			wheel.spin();

	$("#search").change (event,m) => 
		$(".move").removeClass("disabled")
		return false;

	$("#move").submit (e)=>
		# Visual
		id=$("#search").select2("val")
		$(".move").addClass("disabled")
		return if !id or id <= 0
		# Request assessment
		data = $("#move").serialize()
		$.post "/tutorial/move", data, (result) =>
			$("#table tr[data-id='#{id}']").remove()
			$("#table tbody").append(result)
			sort()
		$("#search").select2("val","")

		return false

	$("#settings form").submit (e)=>
		$("#settings .error").text('');
		req = $.post "/tutorial/settings", $("#settings form").serialize(), (result) =>
			$("#settings").modal('hide')
			$("#btn-settings").removeClass("btn-danger")
		req.fail (e) =>
			[status,data] = [e.status, JSON.parse(e.responseText)]
			$("#settings .error").text(data.error);
		false

	$("#addstudent").submit (e)=>
		# Request assessment
		$("#addstudent .error").text('');
		data = $("#addstudent").serialize()
		req = $.post "/tutorial/create_student", data, (result) =>
			$("#table tbody").append(result)
			sort()
		req.fail (e) =>
			[status,data] = [e.status, JSON.parse(e.responseText)]
			$("#addstudent .error").text(data.error);

		# Visual
		$("#addstudent")[0].reset()

		return false

	$("#search").select2
		placeholder: "Search for a student"
		minimumInputLength: 3
		ajax:
			url: "/tutorial/search"
			dataType: 'json'
			data: (term,page) => { term: term, page: page, group_id: group_id }
			results: (data,page) => { results: data }
		dropdownCssClass: "bigdrop"
		escapeMarkup: (m) => m
		formatResult: (m) => "#{m.firstname} #{m.lastname} #{m.email}"
		formatSelection: (m) => "#{m.firstname} #{m.lastname} #{m.email}"
