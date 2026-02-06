require 'fox16'
load 'vertices.rb'
load 'texturing2.rb'

include Fox

class Controler < FXVerticalFrame

  attr_reader :lister, :texture_selector

  def initialize(parent)
    super(parent,:opts=>LAYOUT_FILL|PACK_UNIFORM_HEIGHT)
    @lister = Lister.new(self)
    @texture_selector = TextureSelector.new(self)
  end

  def on_receiving_texel_coordinates(coords)
    @lister.on_receiving_texel_coordinates(coords)
  end

end

class MainWindow < FXMainWindow

  def initialize(application)
    super(application,"Controler demonstration",nil,nil,DECOR_ALL,0,0,700,300,0,0,0,0,0,0)
    @controler = Controler.new(self)
  end

end



#application = FXApp.new("Controler DEMO")
#mainWindow = MainWindow.new(application)
#application.create
#mainWindow.show
#application.run
