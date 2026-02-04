require 'fox16'
require 'opengl'
require 'glu'
load '3d_calc.rb'

include Fox
include Gl
include GLU



class Canvas3D < FXGLCanvas



    attr_reader :visuel, :camera, :vertex_array



    def initialize(application,parent)

      @visuel = FXGLVisual.new(application,VISUAL_STEREO)
      super(parent,@visuel,:opts=>LAYOUT_FILL)

      self.connect(SEL_PAINT,method(:on_paint))
      self.connect(SEL_KEYPRESS,method(:on_keypress))
      
      @vertex_array = [] # This array stores the vertices placed by the cursor.
      @camera = Polar.new(3,0,0) # The camera uses polar coordinates.
      @cursor = Point.new(0,0,0) # The cursor uses cartesian coordinates.
    
    end



    def display_vertices()
      
      glBegin(GL_QUADS)
      glColor3f(1.0,0.0,1.0)
      @vertex_array.each do |element|
        glVertex3f(element.pos_x,element.pos_y,element.pos_z)
      end
      glEnd()

    end



    def on_keypress(sender,sel,data)
      
      # The first six keys are for moving the cursor.
      if data.code == KEY_a
        @cursor.pos_x += 0.2
      elsif data.code == KEY_q
        @cursor.pos_x -= 0.2
      elsif data.code == KEY_z
        @cursor.pos_y += 0.2
      elsif data.code == KEY_s
        @cursor.pos_y -= 0.2
      elsif data.code == KEY_e
        @cursor.pos_z += 0.2
      elsif data.code == KEY_d
        @cursor.pos_z -= 0.2
      end
      # The next six keys are for moving the camera.
      if data.code == KEY_i
        @camera.distance += 0.2
      elsif data.code == KEY_k
        @camera.distance -= 0.2
      elsif data.code == KEY_o
        @camera.angle1 += @camera.deg2rad(5)
      elsif data.code == KEY_l
        @camera.angle1 -= @camera.deg2rad(5)
      elsif data.code == KEY_p
        @camera.hauteur += 0.2
      elsif data.code == KEY_m
        @camera.hauteur -= 0.2
      end
      # The key for placing a vertex : SPACE
      if data.code == KEY_space
        puts "CURSOR > #{@cursor.to_s}"
        @vertex_array.push(@cursor.clone)
        self.getParent().getParent().getParent().getParent().on_receiving_array_from_visuals(@vertex_array)
      end
      self.paint

    end

    def on_paint(sender,sel,data)
      self.paint()
    end

    def paint()
      
      self.makeCurrent
      glLineWidth(3) 
      glPointSize(3)
      glViewport(0,0,self.width,self.height)
         
      glMatrixMode(GL_MODELVIEW) 
      glClearColor(0,0,0,0)
      glClear(GL_COLOR_BUFFER_BIT)
      glLoadIdentity()

      LookAt(@camera.pos_x,
             @camera.pos_y,
             @camera.pos_z,
             0.0,
             0.0,
             0.0,
             0.0,
             1.0,
             0.0)


      glBegin(GL_LINES)
      glColor3f(1.0,0.0,0.0)
      glVertex3f(0.0,0.0,0.0)
      glVertex3f(1.0,0.0,0.0)

      glColor3f(0.0,1.0,0.0)
      glVertex3f(0.0,0.0,0.0)
      glVertex3f(0.0,1.0,0.0)

      glColor3f(0.0,0.0,1.0)
      glVertex3f(0.0,0.0,0.0)
      glVertex3f(0.0,0.0,1.0)
      glEnd()

      glBegin(GL_POINTS)
      glColor3f(1.0,1.0,1.0)
      glVertex3f(@cursor.pos_x,@cursor.pos_y,@cursor.pos_z)
      glEnd()


      self.display_vertices()


      glMatrixMode(GL_PROJECTION)
      glLoadIdentity()
      Perspective(45,1,0.1,1000)
      glFlush()

      self.makeNonCurrent
    
    end

end
