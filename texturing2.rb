require 'fox16'
load '3d_calc.rb'
load '3d_visual.rb'
load 'controls.rb'
include Fox

class TextureManipulator < FXCanvas

  attr_reader :app ,:target_image
  
  def initialize(parent,application)
    super(parent,:opts=>LAYOUT_FILL|FRAME_LINE)
    self.connect(SEL_PAINT,method(:on_paint))
    self.connect(SEL_MOTION,method(:on_motion))
    self.connect(SEL_ENTER,method(:on_enter))
    self.connect(SEL_LEAVE,method(:on_leave))
    self.connect(SEL_LEFTBUTTONPRESS,method(:on_leftbuttonpress))
    @app = application
    @image = load_image("apple.jpeg")
    @cursor_in = false
  end

  def paint(data)
    FXDCWindow.new(self,data) do |dc|
      dc.foreground = self.backColor
      dc.drawImage(@image,0,0)
      if @cursor_in == true
        puts "CURSOR IN !"
      end
    end 
  end
  
  def load_image(new_image)
    resultat = nil
    resultat = FXJPGImage.new(@app,nil,IMAGE_KEEP)
    FXFileStream.open(new_image,FXStreamLoad) { |stream| resultat.loadPixels(stream) }
    resultat.scale(1024,1024)
    resultat.create
    return resultat
  end

  def on_paint(sender,sel,data)
    self.paint(data)
  end

  def on_motion(sender,sel,data)
    #puts "SOURIS : X:#{data.win_x} et Y:#{data.win_y}"
  end

  def on_enter(sender,sel,data)
    @cursor_in = true
  end

  def on_leave(sender,sel,data)
    @cursor_in = false
  end

  def on_leftbuttonpress(sender,sel,data)
    puts "ahi!"
  end

end



class Fenetre_principale < FXMainWindow

  attr_reader :center , :canvas_zone , :control_zone , :zone1

  def initialize(application)
    super(application,"App1",nil,nil,DECOR_ALL,10,10,770,500)
    @application = application
    self.connect(SEL_CLOSE,method(:on_close))
    @texmanip = TextureManipulator.new(self,@application)
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
