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
      #self.connect(SEL_MOTION,method(:on_motion))
      @vertex_array = []
      @camera = Polar.new(3,0,0) 
      @cursor = Point.new(0,0,0)
    end

    def set_vertices_array(array)
      @vertex_array = array
    end
    
    def set_camera_coordinates(camera_coords)
      @camera.distance = camera_coords.distance
      @camera.angle1 = camera_coords.angle1
      @camera.hauteur =  camera_coords.hauteur
    end

    def set_cursor_coordinates(cursor)
      @cursor.pos_x = cursor.pos_x
      @cursor.pos_y = cursor.pos_y
      @cursor.pos_z = cursor.pos_z
    end

    def display_vertices()
      glBegin(GL_QUADS)
      glColor3f(1.0,0.0,1.0)
      @vertex_array.each do |element|
        glVertex3f(element.pos_x,element.pos_y,element.pos_z)
      end
      glEnd()
    end

    def on_paint(sender,sel,data)
      
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
