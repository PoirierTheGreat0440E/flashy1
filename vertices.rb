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



class Lister < FXHorizontalFrame

  @@icon_vertex = nil
  @@icon_quad = nil
  @@icon_texel = nil

  def initialize(parent)
    super(parent,LAYOUT_FILL|PACK_UNIFORM_WIDTH,0,0,10,10,10,10,10,10,10,10)
    self.setBackColor(FXRGB(200,200,200))

    @@icon_vertex = ItemIcon.new(self.getApp(),"vertex_icon.jpg")
    @@icon_quad = ItemIcon.new(self.getApp(),"quad_icon.jpg")
    @@icon_texel = ItemIcon.new(self.getApp(),"texel_icon.jpg")

    @list_vertex = FXList.new(self,nil,0,LAYOUT_FILL|LIST_SINGLESELECT)
    @list_quad = FXList.new(self,nil,0,LAYOUT_FILL|LIST_SINGLESELECT)
    @list_texel = FXList.new(self,nil,0,LAYOUT_FILL|LIST_SINGLESELECT)

    @array_vertex = []
  end

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

  def add_vertex(new_vertex)
    @array_vertex.push(new_vertex)
    self.refresh_lists()
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
