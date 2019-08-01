class Search
  def initialize(parent)
    tabs = []
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_SIDE_LEFT, :padding => 0, :hSpacing => 0, :padLeft => 32, :padRight => 32 })
    @wrapper.object.backColor = parent.backColor
    pages = JSON.load File.open "./cfg/navigation.json"
    pages.each do |page, path|
      tab = PageTab.new(@wrapper.object, page)
      tab.label.object.connect(SEL_LEFTBUTTONPRESS) { tabs.each { |k| $content.load_path(path); k.set_state(tab == k) } }
      tabs << tab
    end
    UserTab.new(@wrapper.object)
  end
end

class UserTab
  def initialize(parent)
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_Y|LAYOUT_SIDE_RIGHT, :padding => 0})
    @label = Text.new(@wrapper.object, Etc.getlogin, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|JUSTIFY_CENTER_Y, :padBottom => 4, :padLeft => 16, :padRight => 16 })
  end
end

class PageTab
  attr_accessor :label
  def initialize(parent, caption)
    @is_current = false
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_Y|LAYOUT_SIDE_LEFT, :padding => 0 })
    @wrapper.object.backColor = clr("#F1F1F1")
    @label = Text.new(@wrapper.object, caption, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|JUSTIFY_CENTER_Y, :padBottom => 4, :padLeft => 16, :padRight => 16 })
    @label.object.connect(SEL_ENTER) { on_enter }
    @label.object.connect(SEL_LEAVE) { on_leave }
    @label.object.backColor = clr("#FFFFFF")
    @label.object.textColor = clr("#B4B0CE")
  end

  def set_state(state)
    @is_current = state
    @label.object.textColor = clr(state ? "#000000" : "#B4B0CE")
    @wrapper.object.backColor = clr(state ? "#FA2360" : "#F1F1F1")
    state ? on_enter : on_leave
  end

  def on_enter
    unless @is_current
      @wrapper.object.padBottom = 4
      @label.object.padBottom = 0
    end
  end

  def on_leave
    unless @is_current
      @wrapper.object.padBottom = 0
      @label.object.padBottom = 4
    end
  end
end

