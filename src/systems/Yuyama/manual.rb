class YuyamaManual
  def initialize(parent, prescription)
    @parent = parent
    @prescription = prescription
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0 })
    @splitter = HorizontalSplitter.new(@wrapper.object)
    @medication_frame = Box.new(@splitter.object, { :opts => LAYOUT_FIX_WIDTH, :width => 200 })
    @tray_frame = Box.new(@splitter.object, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0 })
    @tray_frame.object.backColor = clr("#FFAAFF")
    @tray_grid = HorizontalSplitter.new(@tray_frame.object)
    @tray_columns, @tray_pods = [], []
    (0...8).each { @tray_columns << Box.new(@tray_grid.object, { :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH, :width => 72, :vSpacing => 8 }) }
    (0...28).each { |k|
      frame = Box.new(@tray_columns[k % 7].object, { :opts => FRAME_LINE|LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, :height => 56 })
      label = FXLabel.new(frame.object, "", { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y }) { |k| k.font = FXFont.new($app, "Segoe UI,200,normal"); k.create }
      @tray_pods << [cardinal_to_coordinate(k), frame, label ] 
    }
    # Add meds
    med_options = []
    @manual_fills = get_manual_fill
    @manual_fills.each do |name, pods|
      med_options << Text.new(@medication_frame.object, name, { :opts => FRAME_LINE, :padding => 6, :padLeft => 8, :padRight => 8 })
      med_options.last.object.backColor = clr("#FFAAAA") if name == @manual_fills.first[0]
      med_options.last.object.connect(SEL_LEFTBUTTONPRESS) { |e| med_options.each { |k| k.object.backColor = k.object == e ? clr("#FFAAAA") : clr("#EFEFEF") }; highlight_pods(name) }
      highlight_pods(name) if name == @manual_fills.first[0]
    end
  end

  def clear_pods
    @tray_pods.each do |coordinate, frame, label|
      frame.object.backColor = label.backColor = clr("#EFEFEF")
      label.text = ""
    end
  end

  def highlight_pods(medication_name)
    def highlight_pod(pod, dose)
      @tray_pods.each do |coordinate, frame, label|
        if coordinate == pod
          frame.object.backColor = label.backColor = clr("#FFAAAA")
          label.text = dose.to_s
        end
      end
    end
    clear_pods
    @manual_fills.each do |name, pods|
      if name == medication_name
        pods.each do |pod, dose|
          highlight_pod(pod, dose)
        end
      end
    end
  end

  def cardinal_to_coordinate(value)
    value = value + 1
    across = ((value - 1) % 7).to_s
    down = (64 + (value / 7.0).ceil).chr
    return down + across
  end

  def get_manual_fill
    def add_manual_fill(list, medication_name, pod, dose)
      list.each do |name, info|
        if name == medication_name
          info << [pod, dose]
          return list
        end
      end
      list << [medication_name, [[pod, dose]]]
      return list
    end
    fills = []
    @prescription["pods"].each { |pod, contents|
      contents["medications"].each { |med|
        fills = add_manual_fill(fills, med["medication_name"], pod, med["dose"]) if med["canister"] == "MANUAL_FILL"
      }
    }
    return fills
  end

end