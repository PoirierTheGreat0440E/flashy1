require 'fox16'
load '3d_calc.rb'
load '3d_visual.rb'
load 'controler.rb'
include Fox

class Fenetre_principale < FXMainWindow

  attr_reader :center , :canvas_zone , :control_zone , :zone1

  def initialize(application)

    super(application,"App1",nil,nil,DECOR_ALL,10,10,770,500)
    @application = application
    self.connect(SEL_CLOSE,method(:on_close))
    self.connect(SEL_UPDATE,method(:on_update))

    # We're adding the central container, an horizontal frame!
    @center = FXSplitter.new(self,LAYOUT_FILL|FRAME_SUNKEN,0,0,0,0)

    # On the left, the canvas and on the right, the controls !
    @canvas_zone = FXVerticalFrame.new(@center,LAYOUT_FILL|FRAME_LINE)
    # A square in the middle of the canvas zone, it contains the actual FXGLCanvas...
    @zone1 = FXPacker.new(@canvas_zone,FRAME_LINE)
    # A subclass of the FXGLCanvas. Where the stuff is drawn basically...
    @visuals = Canvas3D.new(@application,@zone1)

    # On the right, the control zone.
    @control_zone = Controler.new(@center)

    @center.setSplit(0,300)

  end

  def create
    super
    self.show(PLACEMENT_SCREEN)
  end

  def on_close(sender,sel,data)
    puts "Ay chingas !"
    self.close
  end

  # Called to change the size of the canvas.
  def on_update(sender,sel,data)
    # We change the size of the canvas 
    pad_left, pad_top = 0,0
    if @canvas_zone.width < @canvas_zone.height
      @zone1.resize(@canvas_zone.width-10,@canvas_zone.width-10)
      pad_left = (@canvas_zone.width-@zone1.width)/2
      pad_top = (@canvas_zone.height-@zone1.width)/2
          elsif @canvas_zone.height < @canvas_zone.width
      @zone1.resize(@canvas_zone.height-10,@canvas_zone.height-10)
      pad_left = (@canvas_zone.width-@zone1.height)/2
      pad_top = (@canvas_zone.height-@zone1.height)/2
    end
    @canvas_zone.setPadTop(pad_top)
    @canvas_zone.setPadLeft(pad_left)
    self.update
  end

  # When it receives the vertex array from the visuals,
  # it does this.
  def on_receiving_array_from_visuals(array)
    puts "RECEIVING ARRAY FROM VISUALS :"
    puts array
    @control_zone.lister.process_incoming_vertices_array(array)
  end

  def on_receiving_selection_plane_from_lister(plane)
  end


end

application = FXApp.new
fenetre = Fenetre_principale.new(application) 
application.addTimeout(100,:repeat=>true) { fenetre.update }
application.create
fenetre.show
application.run
