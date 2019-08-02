def clr(hex_color)
	m = hex_color.match /#(..)(..)(..)/
	return Fox.FXRGB(m[1].hex, m[2].hex, m[3].hex)
end

def get_icon(filename)
	File.open(File.join("cfg/icons", "#{filename}.png"), "rb") { |f|
	  return FXPNGIcon.new($app, f.read)
	}
end

def app_icon(app)
  File.open(File.join("src", "icon.png"), "rb") { |f|
    return FXPNGIcon.new(app, f.read)
  }
end

def app_favicon(app)
  File.open(File.join("src", "favicon.png"), "rb") { |f|
    return FXPNGIcon.new(app, f.read)
  }
end

def get_barcode(data)
  `./src/zint/zint.exe --notext --scale=0.5 --height=12 --output=cfg/barcodes/#{data}.png --data=#{data}`
  if File.exists?("./cfg/barcodes/#{data}.png")
    File.open(File.join("cfg/barcodes", "#{data}.png"), "rb") { |f|
      return FXPNGIcon.new($app, f.read)
    }
  else
    until File.exists?("./cfg/barcodes/#{data}.png")
      get_barcode(data)
    end    
  end
end

def remove_children(parent)
	parent.each_child { |c| parent.removeChild(c) }
end