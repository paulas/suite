require 'rubygems'
require 'bundler'
Bundler.setup(:default, :ci)

require 'fox16'
require 'fox16/colors'
include Fox

require 'FileUtils'
require 'active_support/time'
require 'json'
require 'csv'

require './src/global/global.rb'
require './src/ui/ui.rb'

class AppWindow < FXMainWindow
  def initialize(app, title, w, h)
    # Create window properties
    properties = { :width => w, :height => h }
    # Call window creation
    super(app, title, properties)
    # Capture resize event
    self.connect(SEL_CONFIGURE, method(:on_resize))
    self.connect(SEL_UPDATE, method(:on_resize))
    # Capture close event
    self.connect(SEL_CLOSE, method(:on_close))
  end
  
  def create
    @runtime = false
    super; show(PLACEMENT_SCREEN)
    # Initialize horizontal splitter
    opts = { :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL_X|LAYOUT_FILL_Y }
    @horizontal_splitter = FXSplitter.new(self, opts) { |k| k.barSize = 0; k.create }
    # Initialize navigation frame
    opts = { :opts => LAYOUT_FIX_WIDTH|LAYOUT_FILL_Y, :width => 200, :padding => 0 }
    $form_frame = FXPacker.new(@horizontal_splitter, opts) { |k| k.backColor = clr("#272A34"); k.create }
    # Initialize vertical splitter
    opts = { :opts => SPLITTER_VERTICAL|LAYOUT_FILL_X|LAYOUT_FILL_Y }
    @vertical_splitter = FXSplitter.new(@horizontal_splitter, opts) { |k| k.barSize = 0; k.create }
    # Initialize search frame
    opts = { :opts => LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, :height => 48, :padding => 0 }
    $search_frame = FXPacker.new(@vertical_splitter, opts) { |k| k.backColor = clr("#FFFFFF"); k.create }   
    # Initialize view frame
    opts = { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y }
    $content_frame = FXPacker.new(@vertical_splitter, opts) { |k| k.backColor = clr("#EFEFEF"); k.create }
    # Set runtime true
    @runtime = true
    # Add form
    @form = Form.new($form_frame)
    @search = Search.new($search_frame)
    $content = Content.new($content_frame, "./data/live/page_test.json")
  end

  def on_resize(sender, sel, event)
    # Resize vertical splitter
    @vertical_splitter.width = self.width - 430 if @runtime
  end

  def on_close(sender, sel, event)
    # Close application
    getApp().exit(0)
  end
end

def run_app
  $app = FXApp.new
  window = AppWindow.new($app, "", 960, 560)
  $app.create
  $app.run
end

run_app