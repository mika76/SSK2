-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs
local strMatch = string.match; local strGSub = string.gsub; local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

local actions = ssk.actions
local rgColor = ssk.RGColor

ssk.misc.countLocals(1)

-- =============================================================
-- =============================================================
local test = {}

local oneStickOneTouch  = ssk.easyInputs.oneStickOneTouch

-- Forward Declarations
local drawRoom


function test.run( group, params )
   group = group or display.currentStage
   params = params or {}

  --
  -- Start and Configure  physics
  local physics = require "physics"
  physics.start()
  physics.setGravity(0,0)
  --physics.setDrawMode("hybrid")

  -- Initialize 'input'
  --
  oneStickOneTouch.create( group, { debugEn = true, joyParams = { doNorm = true } } )

  -- Create a room 
  --
  drawRoom( group )

  -- Create a 'player' as our player
  --
  local player = newImageRect( group, centerX, centerY - 50, "images/kenney/kenney1.png", { size = 80 }, { radius = 40 } )

  -- Prepare the player for inputs
  --
  player.isFixedRotation = true
  player.linearDamping = 0.5
  player.forceX = 0
  player.forceY = 0
  player.x = centerX
  player.y = centerY

  -- Start listening for enterFrame event
  --
  player.enterFrame = function( self )
    self:applyForce( self.forceX * self.mass, self.forceY * self.mass, self.x, self.y )
  end; listen( "enterFrame", player )


  -- Start listening for the one touch + one stick (onOneTouch + onJoystick) events
  --
  player.onJoystick = function( self, event )
    if( event.state == "on" ) then
      self.rotation = event.angle
    elseif( event.state == "off" ) then
    end
    return false
  end; listen( "onJoystick", player )

  player.onOneTouch = function( self, event )
    local vec = angle2Vector( self.rotation, true )
    vec = normVec( vec )

    if( event.phase == "began" ) then
      self.forceX = 15 * vec.x
      self.forceY = 15 * vec.y
    
    elseif( event.phase == "ended" ) then
      self.forceX = 0
      self.forceY = 0

    end
    return false
  end; listen( "onOneTouch", player )

end



-- Helper function to draw a simple room for our example
--
drawRoom = function( group )
  -- Walls
  --
  display.setDefault( "textureWrapY", "repeat" )
  local leftWall = newRect( group, left, centerY, { w = 80, h = fullh  }, { bodyType = "static" } )
  leftWall.fill = { type = "image", filename = "images/kenney/kenney_wood.png" }
  leftWall.fill.scaleY = 80/fullh
  local rightWall = newRect( group, right, centerY, { w = 80, h = fullh  }, { bodyType = "static" } )
  rightWall.fill = { type = "image", filename = "images/kenney/kenney_wood.png" }
  rightWall.fill.scaleY = 80/fullh
  display.setDefault( "textureWrapY", "clampToEdge" )

  -- Floor and Ceiling
  --
  display.setDefault( "textureWrapX", "repeat" )
  local floor = newRect( group, centerX, bottom, { w = fullw, h = 80  }, { bodyType = "static" } )
  floor.fill = { type = "image", filename = "images/kenney/kenney_stone.png" }
  floor.fill.scaleX = 80/fullw
  local ceiling = newRect( group, centerX, top, { w = fullw, h = 80  }, { bodyType = "static" } )
  ceiling.fill = { type = "image", filename = "images/kenney/kenney_stone.png" }
  ceiling.fill.scaleX = 80/fullw
  display.setDefault( "textureWrapX", "clampToEdge" )
end


return test
