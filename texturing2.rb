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
    @app = application
    @image = load_image("apple.jpeg")
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
    FXDCWindow.new(self,data) do |dc|
      dc.foreground = self.backColor
      dc.drawImage(@image,0,0)
    end
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
