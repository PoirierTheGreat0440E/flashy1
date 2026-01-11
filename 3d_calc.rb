
class Point

  attr_reader :pos_x, :pos_y, :pos_z

  def initialize(ini_x,ini_y,ini_z)
    @pos_x = ini_x
    @pos_y = ini_y
    @pos_z = ini_z
  end

  def pos_x=(new_x)
    @pos_x = new_x
  end
  
  def pos_y=(new_y)
    @pos_y = new_y
  end

  def pos_z=(new_z)
    @pos_z = new_z
  end

  def place(x,y,z)
    @pos_x = x
    @pos_y = y
    @pos_z = z
  end

end

class Polar < Point

  attr_reader :distance, :angle1, :hauteur

  def deg2rad(angle)
    rad = (angle*Math::PI)/180
  end

  def initialize(ini_dist,ini_angle1,ini_y)
    @distance = ini_dist
    @angle1 = deg2rad(ini_angle1)
    @hauteur = ini_y
    super(@distance*Math.cos(@angle1),
          @hauteur,
          @distance*Math.sin(@angle1)
          )
  end

  def distance=(new_dist)
    @distance = new_dist
    self.update_positions
  end

  def angle1=(new_a1)
    @angle1 = new_a1
    self.update_positions
  end

  def hauteur=(new_h)
    @hauteur=new_h
    self.update_positions
  end

  def up_vector()
    base = Point.new(0.0,0.0,0.0)
    inter1 = Polar.new(@distance,@angle1+deg2rad(10),@hauteur)
    vec1 = Vector.new(base,inter1)
    vec2 = Vector.new(base,self)
    up_vector = vec1.X(vec2)
    puts "WHAT : #{vec2.dot(up_vector)}"
  end

  def update_positions()
    @pos_x = @distance*Math.cos(@angle1)
    @pos_y = @hauteur
    @pos_z = @distance*Math.sin(@angle1)
  end

  def to_s()
    return "POLAR> d:#{@distance}, angle1:#{@angle1}, hauteur:#{@hauteur}"
  end


end

class Spherical < Point

  attr_reader :angle1, :angle2, :distance

  def deg2rad(angle)
    rad = (angle*Math::PI)/180
  end

  # The angles must be given in degrees ! not in radians !
  def initialize(ini_d,ini_a1,ini_a2)
    @angle1 = deg2rad(ini_a1)
    @angle2 = deg2rad(ini_a2)
    @distance = ini_d
    super(@distance*Math.cos(@angle1)*Math.sin(@angle2),
          @distance*Math.sin(@angle2),
          @distance*Math.cos(@angle1)*Math.cos(@angle2))
  end

  # The angle1 has to stay within the interval 
  def angle1=(new_angle1)
    @angle1 = new_angle1
  end
  
  # The angle2 has to stay within the interval ]-pi/2;pi/2[
  def angle2=(new_angle1)
    @angle2 = new_angle1
  end

  def distance=(new_dist)
    @distance = new_dist
  end

  def update_positions()
    @pos_x = @distance*Math.cos(@angle1)*Math.sin(@angle2)
    @pos_y = @distance*Math.sin(@angle2)
    @pos_z = @distance*Math.cos(@angle1)*Math.cos(@angle2)
  end  

  def to_s()
    "Spherical : DIST:#{@distance.round(2)} , ANGLE1:#{@angle1.round(2)} , ANGLE2:#{@angle2.round(2)}"
  end

end

class Vector

  attr_reader :ending1 , :ending2, :x_component, :y_component, :z_component

  def initialize(p1,p2)
    @ending1 = p1
    @ending2 = p2
    @x_component = p2.pos_x - p1.pos_x
    @y_component = p2.pos_y - p1.pos_y
    @z_component = p2.pos_z - p1.pos_z
  end

  def length()
    length = Math.sqrt(@x_component**2 + @y_component**2 + @z_component**2)
  end

  def dot(vector2)
    dotproduct = @x_component*vector2.x_component + @y_component*vector2.y_component + @z_component*vector2.z_component
  end

  def X(vector2)
    x_comp = @y_component*vector2.z_component - @z_component*vector2.y_component
    y_comp = @z_component*vector2.x_component - @x_component*vector2.z_component
    z_comp = @x_component*vector2.y_component - @y_component*vector2.x_component
    p1 = Point.new(@ending1.pos_x,@ending1.pos_y,@ending1.pos_z)
    p2 = Point.new(@ending1.pos_x+x_comp,@ending1.pos_y+y_comp,@ending1.pos_z+z_comp)
    return Vector.new(p1,p2)
  end

end

def demo1
  origine = Point.new(0,0,0)
  spherique1 = Spherical.new(1,10,10)
  spherique2 = Spherical.new(1,11,10)
  
  vecteur1 = Vector.new(origine,spherique1)
  vecteur2 = Vector.new(origine,spherique2)

  orthogonal1 = vecteur1.X(vecteur2)
  puts "RES : #{vecteur1.dot(orthogonal1).round()}"
end
