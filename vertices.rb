require 'fox16'

include Fox


class ItemIcon < FXJPGIcon

  def initialize(application,image_path)
    super(application,nil,FXRGB(192,192,192),IMAGE_KEEP,20,20)
    FXFileStream.open(image_path,FXStreamLoad) { |stream| self.loadPixels(stream) }
    self.scale(20,20)
    self.create
  end

end



class VertexList < FXList

  def initialize(parent)
    super(parent,nil,0,LIST_SINGLESELECT|LAYOUT_FILL)
    @array = [] # We start with an empty vertex array.
  end

end



class MainWindow < FXMainWindow

  def initialize(application)
    @icon1 = ItemIcon.new(application,"vertex_icon.jpg")
    @icon2 = ItemIcon.new(application,"quad_icon.jpg")
    @icon3 = ItemIcon.new(application,"texel_icon.jpg")
    super(application,"VertexList demonstration",nil,nil,DECOR_ALL,0,0,300,300,0,0,0,0,0,0)
    @vertexlist = VertexList.new(self)
    @vertexlist.appendItem("test",@icon1)
    @vertexlist.appendItem("test",@icon2)
    @vertexlist.appendItem("test",@icon3)
  end

end



application = FXApp.new("VertexList DEMO")
mainWindow = MainWindow.new(application)
application.create
mainWindow.show
application.run
