require 'fox16'
load '3d_calc.rb'

include Fox


class ItemIcon < FXJPGIcon
  def initialize(application,image_path)
    super(application,nil,FXRGB(192,192,192),IMAGE_KEEP,20,20)
    FXFileStream.open(image_path,FXStreamLoad) { |stream| self.loadPixels(stream) }
    self.scale(20,20)
    self.create
  end
end


# The Lister allows the user to see the vertices, their associated quad and texels listed
# on lists. The user should be capable of selecting the vertex he wants and to interact with
# the quads and texels that are associated with the vertex.
class Lister < FXHorizontalFrame

  @@icon_vertex = nil
  @@icon_quad = nil
  @@icon_texel = nil

  def initialize(parent)
    super(parent,LAYOUT_FILL|PACK_UNIFORM_WIDTH,0,0,10,10,10,10,10,10,5,5)
    self.setBackColor(FXRGB(200,200,200))
    @selection_index = 0
    @selection_plane = Plane.new(Point.new(0,0,0),Point.new(0,0,0),Point.new(0,0,0),Point.new(0,0,0))

    # We initialize the icons for each type of listing.
    @@icon_vertex = ItemIcon.new(self.getApp(),"vertex_icon.jpg")
    @@icon_quad = ItemIcon.new(self.getApp(),"quad_icon.jpg")
    @@icon_texel = ItemIcon.new(self.getApp(),"texel_icon.jpg")

    # The list for the vertices
    @list_vertex = FXList.new(self,nil,0,LAYOUT_FILL|LIST_SINGLESELECT)
    @list_vertex.connect(SEL_COMMAND,method(:on_command))

    # The list for the quads
    @list_quad = FXList.new(self,nil,0,LAYOUT_FILL)
    @list_quad.setSelBackColor(FXRGB(220,220,220))

    # The list for the texels
    @list_texel = FXList.new(self,nil,0,LAYOUT_FILL)
    @list_texel.setSelBackColor(FXRGB(220,220,220))

    # The array that contrains every vertex.
    # It's coupled with the lists so that
    # they are automatically updated whenever
    # a vertex is inserted.
    @array_vertex = []
  end

  # Refreshes all the lists of the Lister
  # and displays the new, updated elements.
  def refresh_lists()
    @list_vertex.clearItems()
    @list_quad.clearItems()
    @list_texel.clearItems()
    
    index = 0
    @array_vertex.each do |item|
      @list_vertex.appendItem(item.to_s,@@icon_vertex)
      @list_quad.appendItem((index/4).to_s,@@icon_quad)
      @list_texel.appendItem("nothing",@@icon_texel)
      index = index + 1
    end
  end

  # When a new vertex is placed,
  # we need to push the new vertex
  # on the vertex array. Then we update
  # the lists.
  def add_vertex(new_vertex)
    @array_vertex.push(new_vertex)
    self.refresh_lists()
  end

  # Whenever a vertex is selected by the
  # user :
  # - We compute the index to indicate its quad and texels
  # - We update the selection plane so that it reflects the
  #   quad associated with the selected vertex.
  # - We communicate the selection plane with the Texturer
  #   so that the user can assign the texture with the right
  #   shape.

  def on_command(sender,sel,data)

    @selection_index = data/4

    (0...@array_vertex.length).each do |index|
      if index >= 4*@selection_index and index <= 4*@selection_index+3
        @list_quad.getItem(index).setSelected(true)
        @list_texel.getItem(index).setSelected(true)
      else
        @list_quad.getItem(index).setSelected(false)
        @list_texel.getItem(index).setSelected(false)
      end 
    end

    @list_quad.recalc
    @list_texel.recalc

    # We update the selection plane...
    @selection_plane.p1 = @array_vertex[4*@selection_index]
    @selection_plane.p2 = @array_vertex[4*@selection_index+1]
    @selection_plane.p3 = @array_vertex[4*@selection_index+2]
    @selection_plane.p4 = @array_vertex[4*@selection_index+3]

  end

  def send_selection_plane()
  end

end



class MainWindow < FXMainWindow

  def initialize(application)
    super(application,"VertexList demonstration",nil,nil,DECOR_ALL,0,0,700,300,0,0,0,0,0,0)
    @lister = Lister.new(self)
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
    @lister.add_vertex(Point.new(1,1,1))
  end

end



application = FXApp.new("VertexList DEMO")
mainWindow = MainWindow.new(application)
application.create
mainWindow.show
application.run
