# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
hsvToRgb = (h, s, v) ->
	h_i = Math.floor(h * 6)
	f = h * 6 - h_i
	p = v * (1 - s)
	q = v * (1 - f * s)
	t = v * (1 - (1 - f) * s)
	r = 255
	g = 255
	b = 255
	switch h_i
		when 0
			r = v
			g = t
			b = p
		when 1
			r = q
			g = v
			b = p
		when 2
			r = p
			g = v
			b = t
		when 3
			r = p
			g = q
			b = v
		when 4
			r = t
			g = p
			b = v
		when 5
			r = v
			g = p
			b = q
	[
		Math.floor(r * 256)
		Math.floor(g * 256)
		Math.floor(b * 256)
	]

padHex = (str) ->
	return str if str.length >= 2
	new Array(2 - str.length + 1).join("0") + str

stringColor = (str, hex, saturation, value) ->
	goldenRatio = 0.618033988749895
	hue = Math.abs(CryptoJS.MD5(str).words[3])/Math.pow(2,32)
	hue += goldenRatio
	hue %= 1
	saturation = 0.5  if typeof saturation isnt "number"
	value = 0.95  if typeof value isnt "number"
	rgb = hsvToRgb(hue, saturation, value)
	if hex
		"#" + padHex(rgb[0].toString(16)) + padHex(rgb[1].toString(16)) + padHex(rgb[2].toString(16))
	else
		rgb

window.stringColor = stringColor