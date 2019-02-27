Player = require "Player"

Bricks = {}
-- Find a method to place next set of brick lines directly the first one?
bricksLineTimer = 2
bricksLineController = {}
bricksLineController.bricks = {}
-- Moved this variables outside of Controller to make the bricks usable
brickSprite = love.graphics.newImage("brick.png")

function bricksLineController.spawnBrick(posX, posY)
  Brick = {}
  --Brick.brickSprite = love.graphics.newImage("brick.png")
  Brick.brickPosX = posX
  Brick.brickPosY = posY
  Brick.brickWidth = brickSprite:getWidth()
  Brick.brickHeight = brickSprite:getHeight()
  Brick.brickOriginX = 0
  Brick.brickOriginY = 0
  Brick.brickSpeed = 0.009
  if love.math.random(1, 10) < 2 then
    Brick.isPowerUp = true
  else
    Brick.isPowerUp = false
  end

  table.insert(bricksLineController.bricks, Brick)

end

function Bricks:load()
end

function Bricks:update(dt)


  bricksLineTimer = bricksLineTimer - 0.01
  brickHighestYPos = 1000
  for _, b in pairs(bricksLineController.bricks) do
    if b.brickPosY < brickHighestYPos then
      brickHighestYPos = b.brickPosY - 23
    end
  end
  --print("Brick Pos Y: "..brickHighestYPos)
  if( brickHighestYPos > -24) then
    for i = 0, 16 do
      for j = 1, 1 do
        -- 'i' is the one that spawns the bricks
        -- 'j' is the one that sets the height of the bricks
        -- Start spawning brick lines here?
        -- and maybe spawn 3 - 4 lines ahead?
        bricksLineController.spawnBrick(i * 50, -24)
      end
    end
  end
  for _,b in pairs(bricksLineController.bricks) do
    b.brickPosY = b.brickPosY + b.brickSpeed
  end
  for i, b in ipairs(bricksLineController.bricks) do
    if b.brickPosY >= 900 then
      currentScreen = 'gameOver'
      table.remove(bricksLineController.bricks, i)
      print("Removed BRICKS")
    end
  end
end

function Bricks:draw()
  local powerUpBrickColor = {math.random(0, 255) / 255,
                            math.random(0, 255) / 255,
                            math.random(0, 255) / 255,
                            1}

  for _, b in ipairs(bricksLineController.bricks) do
    if b.isPowerUp then
      love.graphics.setColor(powerUpBrickColor)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(brickSprite,
                       b.brickPosX,
                       b.brickPosY,
                       0, 1, 1)
  end

  love.graphics.setColor(1, 1, 1, 1)

end

return Bricks
