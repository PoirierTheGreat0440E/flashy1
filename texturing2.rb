require 'fox16'
load '3d_calc.rb'
load '3d_visual.rb'
load 'controls.rb'
include Fox

class TexViewer < FXCanvas

  attr_reader :app ,:target_image
  
  def initialize(parent,application)
    super(parent,:opts=>LAYOUT_FILL|FRAME_LINE)
    self.connect(SEL_PAINT,method(:on_paint))
    self.connect(SEL_MOTION,method(:on_motion))
    self.connect(SEL_CONFIGURE,method(:on_configure))
    self.connect(SEL_LEFTBUTTONPRESS,method(:on_leftbuttonpress))
    @app = application
    @image = load_image("apple.jpeg",100,200)
  end

  def paint(data)
    FXDCWindow.new(self,data) do |dc|
      dc.foreground = self.backColor
      dc.fillRectangle(0,0,self.width,self.height)
      dc.drawImage(@image,0,0)
    end 
  end
  
  def load_image(new_image,new_width,new_height)
    resultat = nil
    resultat = FXJPGImage.new(@app,nil,IMAGE_KEEP)
    FXFileStream.open(new_image,FXStreamLoad) { |stream| resultat.loadPixels(stream) }
    resultat.scale(new_width,new_height)
    resultat.create
    self.getParent().resize(new_width,new_height)
    return resultat
  end

  def on_paint(sender,sel,data)
    self.paint(data)
  end

  def on_motion(sender,sel,data)
    #puts "SOURIS : X:#{data.win_x} et Y:#{data.win_y}"
  end

  def on_leftbuttonpress(sender,sel,data)
    puts "ahi!"
  end

  def on_configure(sender,sel,data)
    puts "Width : #{self.width} Height : #{self.height}"
  end

end


class TextureManipulator < FXHorizontalFrame

# The texture manipulator allows the user to place texels coordinates
# on an image and load the image into a canvas to make the process easier.
#
# On its left is going to be the TexViewer, which is basically a canvas
# On its right is a control panel with buttons and options to use at your liking.

  def initialize(parent)
    super(parent,LAYOUT_FILL|FRAME_THICK|PACK_UNIFORM_WIDTH)
    @tex_viewer = TexViewer.new(self,self.getApp())
    @control_panel = FXVerticalFrame.new(self,LAYOUT_FILL|FRAME_GROOVE)
  end

end



class Fenetre_principale < FXMainWindow

  attr_reader :center , :canvas_zone , :control_zone , :zone1

  def initialize(application)
    super(application,"App1",nil,nil,DECOR_ALL,10,10,770,500)
    @application = application
    self.connect(SEL_CLOSE,method(:on_close))
    @texmanip = TextureManipulator.new(self)
  end

  def create
    super
    self.show(PLACEMENT_SCREEN)
  end

  def on_close(sender,sel,data)
    puts "Ay chingas !"
    self.close
  end

end

application = FXApp.new
fenetre = Fenetre_principale.new(application) 
#application.addTimeout(100,:repeat=>true) { fenetre.update }
application.create
fenetre.show
application.run
