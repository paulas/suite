def clr(hex_color)
	m = hex_color.match /#(..)(..)(..)/
	return Fox.FXRGB(m[1].hex, m[2].hex, m[3].hex)
end