require 'fox16'
load '3d_calc.rb'
include Fox

class CoordinatesDisplayer < FXHorizontalFrame

  attr_reader :target_point

  def target_point=(new_tp)
    @target_point = new_tp
    self.update_labels
  end

  def update_labels()
    if @target_point.class.to_s == "Point"
      @label1.setText("X : #{@target_point.pos_x}")
      @label2.setText("Y : #{@target_point.pos_y}")
      @label3.setText("Z : #{@target_point.pos_z}")
    elsif @target_point.class.to_s == "Polar"
      @label1.setText("Distance : #{@target_point.distance.round(3)}")
      @label2.setText("Angle : #{@target_point.angle1.round(3)}")
      @label3.setText("Hauteur : #{@target_point.hauteur.round(3)}")
    else
      @label1.setText("Target point's class is unspecified !")
      @label2.setText("")
      @label3.setText("")
    end
  end


  def initialize(parent,ini_tp)
    super(parent,:opts=>LAYOUT_FILL_X|PACK_UNIFORM_WIDTH)
    @label1 = FXLabel.new(self,"")
    @label2 = FXLabel.new(self,"")
    @label3 = FXLabel.new(self,"")
    @target_point = ini_tp
  end

  
end

class ControlZone < FXVerticalFrame

  attr_reader :camera

 def initialize(parent,opts)
    super(parent,opts)
    @parent = parent
    @camera = Polar.new(1,0,0)
    # The first sub-zone contains buttons
    @Cd = CoordinatesDisplayer.new(self,Point.new(0,0,0))
    @Cd_camera = CoordinatesDisplayer.new(self,Polar.new(1,0,0))
    # The second one consists of a list
    # This list is gonna store every vertex
    @vertex_list = FXList.new(self,:opts=>LIST_EXTENDEDSELECT|LAYOUT_FILL)
    @vertex_list.connect(SEL_KEYPRESS,method(:on_keypress))
 end


 # Callback function to interact with the keyboard
 # Manipulates the cursor. 
 def on_keypress(sender,sel,data)

   # Keyboard buttons for the camera...
   if data.code == KEY_i
     @Cd_camera.target_point.angle1 += @Cd_camera.target_point.deg2rad(15)
   elsif data.code == KEY_k
     @Cd_camera.target_point.angle1 -= @Cd_camera.target_point.deg2rad(15)
   elsif data.code == KEY_o
     @Cd_camera.target_point.distance += 0.2
   elsif data.code == KEY_l
     if @Cd_camera.target_point.distance - 0.2 > 0.0
       @Cd_camera.target_point.distance -= 0.2
     end
   elsif data.code == KEY_p
     @Cd_camera.target_point.hauteur += 0.2
   elsif data.code == KEY_m
     @Cd_camera.target_point.hauteur -= 0.2
   end
   @Cd_camera.update_labels

    # Keyboard buttons for the cursor...
   if data.code == KEY_a
     @Cd.target_point.pos_x += 0.2
   elsif data.code == KEY_q
     @Cd.target_point.pos_x -= 0.2
   elsif data.code == KEY_z
     @Cd.target_point.pos_y += 0.2
   elsif data.code == KEY_s
     @Cd.target_point.pos_y -= 0.2
   elsif data.code == KEY_e
     @Cd.target_point.pos_z += 0.2
   elsif data.code == KEY_d
     @Cd.target_point.pos_z -= 0.2
   elsif data.code == KEY_space
     puts "SPACE"
   else
   end
   @Cd.update_labels

   self.getParent().getParent().process_keys(@Cd_camera.target_point,@Cd.target_point)

 end

end

