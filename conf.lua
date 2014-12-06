-- #LD31 -- by <weldale@gmail.com>

function love.conf(t)
  t.title = "LD31"
  t.identity = "LD31"
  t.author = "Alexander Weld <weldale@gmail.com>"
  t.modules.physics = false -- don't need that

  t.window.width      = 640
  t.window.height     = 480

  t.console = false
end
