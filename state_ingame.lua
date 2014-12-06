-- #LD31 - 2014 by <weldale@gmail.com>

InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
  self.camera = Camera:new(0, 0, 480, 480)
  self.viewport = Viewport:new(160, 0, 480, 480)

  self.ee = Entity:new( 240, 240 )

end


