require 'fox16'
load '3d_calc.rb'
load '3d_visual.rb'
load 'controls.rb'
include Fox

class TexViewer < FXCanvas

  attr_reader :texture
  
  def initialize(parent,application)
    super(parent,:opts=>LAYOUT_FILL)
    self.connect(SEL_PAINT,method(:on_paint))
    self.connect(SEL_MOTION,method(:on_motion))
    self.connect(SEL_LEFTBUTTONPRESS,method(:on_leftbuttonpress))
    @cell_size = 1
    @image = load_image("apple.jpeg",1024,1024)
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
    return resultat
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



class Fenetre_principale < FXMainWindow

  attr_reader :texview

  def initialize(application)
    super(application,"Texturing demo",nil,nil,DECOR_TITLE|DECOR_CLOSE,10,10,1024,1024)
    self.connect(SEL_CLOSE,method(:on_close))
    @texview = TexViewer.new(self,self.getApp())
  end

  def create
    super
    self.show(PLACEMENT_SCREEN)
  end

  def on_close(sender,sel,data)
    self.close
  end

end



application = FXApp.new
fenetre = Fenetre_principale.new(application) 
application.create
application.addTimeout(10,:repeat=>true) { fenetre.texview.paint() }
fenetre.show
application.run
