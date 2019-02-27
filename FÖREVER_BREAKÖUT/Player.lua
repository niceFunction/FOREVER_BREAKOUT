-- If the Player holds down/releases a key
local isLeftHeld
local isRightHeld
-- Velocity cap as to how fast the Player can move
local maxVelocity
-- If the Player isn't touching a key, do nothing
isLeftHeld = false
isRightHeld = false
-- Players intial velocity
baseVelocity = -800

-- Player table with variables
Player = {}
Player.Sprite = love.graphics.newImage("player.png")
Player.posX = love.graphics.getWidth() * 0.5
Player.posY = love.graphics.getHeight() - 80
Player.Orientation = 0
Player.scaleX = 1
Player.scaleY = 1
Player.originX = math.ceil(Player.Sprite:getWidth() * 0.5)
Player.originY = 0
Player.Width = Player.Sprite:getWidth()
Player.Height = Player.Sprite:getHeight()
Player.Velocity = 0
Player.maxVelocity = 4.25
Player.Direction = 1
Player.clampLeft = 42
Player.clampRight = love.graphics.getWidth() - 42

function Player:load(arg)
end

function Player:update(dt)

-- Move left if key is down and set direction to left
  if isLeftHeld == true then
    self.Velocity = baseVelocity
    self.Direction = 1
  elseif isRightHeld == true then
    -- Move right if key is down and set direction to right
    self.Velocity = baseVelocity
    self.Direction = -1
  else
    -- Slow down if nothing is happening
    self.Velocity = self.Velocity * 0.94
  end
  -- Update movement
  self.posX = self.posX + (self.Velocity * dt) * self.Direction
  -- Cap the Players velocity to maximum velocity allowed
  if self.Velocity > self.maxVelocity then
    self.Velocity = self.maxVelocity
  end
  -- Prevents the player from moving outside to the left
  if self.posX < self.clampLeft then
    self.posX = self.clampLeft
  elseif self.posX > self.clampRight then
    self.posX = self.clampRight
  end
end

function Player:draw()
  -- Draw the player
  love.graphics.draw(self.Sprite,
                     self.posX,
                     self.posY,
                     self.Orientation,
                     self.scaleX,
                     self.scaleY,
                     self.originX,
                     self.originY)
end

function Player:keypressed(key)
  -- If the player is pressing the key, it's true
  if key == 'left' then
    isLeftHeld = true
  end

  if key == 'right' then
    isRightHeld = true
  end
end

function Player:keyreleased(key)
  -- If the player isn't pressing the key, it's false
  if key == 'left' then
    isLeftHeld = false
  end

  if key == 'right' then
    isRightHeld = false
  end
end

return Player
