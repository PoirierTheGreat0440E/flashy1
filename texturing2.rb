require 'fox16'
load '3d_calc.rb'
load '3d_visual.rb'
load 'controls.rb'
include Fox

class TexWindow < FXTopWindow

  attr_reader :pecker, :texviewer

  def initialize(parent)
    super(parent,"Texture1",nil,nil,DECOR_TITLE|DECOR_CLOSE,10,10,1024,1024,0,0,0,0,0,0)
    self.connect(SEL_CLOSE,method(:on_close))
    @pecker = FXPacker.new(self,LAYOUT_FILL)
    @texviewer = TexViewer.new(@pecker,self.getApp)
  end

  def show_yourself(image_path)
    @texviewer.load_image(image_path,self.width,self.height)
    self.show(PLACEMENT_DEFAULT)
  end

  def on_close(sender,sel,event)
    self.hide
  end

  def painting()
      @texviewer.paint
  end

end



class TexViewer < FXCanvas

  attr_reader :texture
  
  def initialize(parent,application)
    super(parent,:opts=>LAYOUT_FILL)
    self.connect(SEL_PAINT,method(:on_paint))
    self.connect(SEL_MOTION,method(:on_motion))
    self.connect(SEL_LEFTBUTTONPRESS,method(:on_leftbuttonpress))
    @cell_size = 1
    @image = nil
    load_image("apple.jpeg",1024,1024)
    @cursor_positions = [0,0]
    @point_list = Array.new()
  end

  def place_grid_cell(dc,x,y)
    dc.drawRectangle( (x/@cell_size)*@cell_size - @cell_size/2,
                     (y/@cell_size)*@cell_size - @cell_size/2 ,
                     @cell_size,
                     @cell_size)
  end

  def paint()
    FXDCWindow.new(self) do |dc|
      dc.foreground = FXRGB(0,0,0)
      dc.fillRectangle(0,0,self.width,self.height)
      dc.drawImage(@image,0,0)
      self.place_grid_cell(dc,@cursor_positions[0],@cursor_positions[1])
      @point_list.each do |point|
        self.place_grid_cell(dc,point[0],point[1])
      end
    end 
  end
  
  def load_image(new_image,new_width,new_height)
    resultat = nil
    resultat = FXJPGImage.new(self.getApp(),nil,IMAGE_KEEP)
    FXFileStream.open(new_image,FXStreamLoad) { |stream| resultat.loadPixels(stream) }
    #puts "Initial shape : W=#{resultat.width} H=#{resultat.height}"
    @cell_size = (new_width/(resultat.width)).to_int
    resultat.scale(new_width,new_height)
    resultat.create
    @image = resultat
  end

  def on_paint(sender,sel,data)
    self.paint()
  end

  def on_motion(sender,sel,data)
    @cursor_positions = [ data.win_x , data.win_y ]
    puts @cursor_positions.to_s
  end

  def on_leftbuttonpress(sender,sel,data)
    @point_list.push([data.win_x,data.win_y])
  end

end



class TextureSelector < FXHorizontalFrame

  # The texture selector allows the user to select a jpg/jpeg image
  # so that he can place texel coordinates on the TexViewer.
  #
  # On the left is gonna be a preview of the selected image
  #
  # On the right is the file selector that only cares about .jpg/.jpeg files (for now)

  attr_reader :preview_image, :previewer, :file_selector, :texWindow

  def initialize(parent)

    super(parent,:opts=>LAYOUT_FILL|PACK_UNIFORM_WIDTH|FRAME_LINE)

    @preview_image = nil
    @previewer = FXCanvas.new(self,:opts=>LAYOUT_FILL)
    @previewer.connect(SEL_PAINT,method(:on_paint))

    @file_selector = FXFileSelector.new(self,nil,SELECTFILE_EXISTING,LAYOUT_FILL_X)
    @file_selector.setPatternList( ["*.jpeg","*.jpg"] )
    @file_selector.acceptButton.connect(SEL_COMMAND,method(:on_accept))
    @file_selector.cancelButton.connect(SEL_COMMAND,method(:on_cancel))
    
    # The window is shown whenever we double click the image/accept it.
    @texWindow = TexWindow.new(self)

  end

  def on_accept(sender,sel,data)
    puts "what???"
    @preview_image = self.load_preview_image(@file_selector.filename)
    self.paint
    @texWindow.show_yourself(@file_selector.filename)
    #puts @file_selector.filename
  end

  def on_cancel(sender,sel,data)
    puts "ayo..."
  end

  def on_paint(sender,sel,data)
    self.paint
  end

  def load_preview_image(new_image)
    resultat = nil
    resultat = FXJPGImage.new(self.getApp(),nil,IMAGE_KEEP)
    FXFileStream.open(new_image,FXStreamLoad) { |stream| resultat.loadPixels(stream) }
    resultat.scale(@previewer.width,@previewer.height)
    resultat.create
    return resultat
  end

  def paint()
    FXDCWindow.new(@previewer) do |dc|
      dc.foreground = FXRGB(255,0,0)
      dc.fillRectangle(0,0,@previewer.width,@previewer.height)
      if @preview_image
        dc.drawImage(@preview_image,0,0) 
      end
    end
  end

  def onCmdItemSelected(sender,sel,data)
    puts "BOUGNADERE"
  end

end



class Fenetre_principale < FXMainWindow

  attr_reader :texview, :selector

  def initialize(application)
    super(application,"Texturing demo",nil,nil,DECOR_ALL,10,10,700,300)
    self.connect(SEL_CLOSE,method(:on_close))
    @selector = TextureSelector.new(self)
  end

  def create
    super
    self.show(PLACEMENT_SCREEN)
  end

  def on_close(sender,sel,data)
    self.close
  end

end



#application = FXApp.new
#fenetre = Fenetre_principale.new(application) 
#application.create
#application.addTimeout(10,:repeat=>true) { fenetre.texview.paint() }
#application.addTimeout(10,:repeat=>true) { fenetre.selector.paint() }
#application.addTimeout(10,:repeat=>true) { fenetre.selector.texWindow.painting }
#fenetre.show
#application.run
