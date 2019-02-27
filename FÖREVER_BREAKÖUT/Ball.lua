Player = require "Player"
Bricks = require "Brick"
powerUp = require "Powerup"

numActiveBalls = 1

Balls = {}
ballsController = {}
ballsController.balls = {}

ballSprite = love.graphics.newImage("ball.png")

-- Ball Variables
function ballsController.spawnBall(posX, posY)
    Ball = {}
    Ball.ballPosX = Player.posX - 8 
    Ball.ballPosY = Player.posY - 16
    Ball.ballOriginX = 0
    Ball.ballOriginY = 0
    Ball.ballOrientation = 0
    Ball.ballScaleFactor = 1
    Ball.ballWidth = ballSprite:getWidth()
    Ball.ballHeight = ballSprite:getHeight()
    Ball.ballSpeed = 300
    Ball.ballMaxSpeed = 580
    love.math.setRandomSeed(love.timer.getTime())
    Ball.ballDirX = 0
    Ball.ballDirY = 1
    Ball.ballClampRoof = 0
    Ball.ballClampLeft = 0
    Ball.isBallAlive = true
    Ball.stuckToPlayer = true
    Ball.extraSizeFactor = 1
    Ball.hitPlayerSound = love.audio.newSource("hitPlayerSound.wav", "static")
    Ball.hitWallSound = love.audio.newSource("hitWallSound.wav", "static")
    Ball.hitBrickSound = love.audio.newSource("hitBrickSound.wav", "static")

    table.insert(ballsController.balls, Ball)
end

function Balls:ballStart(b)
  if (b.stuckToPlayer) then
    b.ballPosX = Player.posX - 8
    b.ballPosY = Player.posY - 16
    b.hitPlayerSound:pause()
  end
end

function Balls:handlePlayerBounce(isPlayer, b)
  local playerHalfWidth = Player.Sprite:getWidth() * 0.5
  local playerHalfHeight = Player.Sprite:getHeight() * 0.5
  local playerPosX = 0
  local playerPosY = 0
  local playerOriginOffset = 35

  if isPlayer then
    playerPosX = Player.posX
    playerPosY = Player.posY + playerOriginOffset -- ball origin offset
  end

  local playerToBallX = b.ballPosX + b.ballWidth * 0.5 - playerPosX
  local playerToBallY = b.ballPosY - playerPosY
  local ballToPlayerLength = math.sqrt(playerToBallX * playerToBallX +
                             playerToBallY * playerToBallY)

  b.ballDirX = playerToBallX / ballToPlayerLength
  b.ballDirY = playerToBallY / ballToPlayerLength

end

function Balls:handleBrickBounce(b)
  b.ballDirY = - b.ballDirY
end

function Balls:ballHitRoof(b)
  if b.ballPosY < b.ballClampRoof then
    b.ballPosY = ballSprite:getHeight()
    b.ballDirY = -b.ballDirY
    b.hitWallSound:setVolume(0.2)
    b.hitWallSound:play()
  end
end

function Balls:ballHitLeft(b)
  if b.ballPosX < 0 then
    b.ballPosX = 0
    b.ballDirX = -b.ballDirX
    b.hitWallSound:setVolume(0.2)
    b.hitWallSound:play()
  end
end

function Balls:ballHitRight(b)

-- When the Ball collides with the right wall, change direction
if b.ballPosX + ballSprite:getWidth() * b.extraSizeFactor >
   Window.Width then
    b.ballDirX = -b.ballDirX
    b.hitWallSound:setVolume(0.2)
    b.hitWallSound:play()
  end
end

function Balls:ballHitPlayer(b)
  local playerHalfWidth = Player.Sprite:getWidth() * 0.5
  local playerHalfHeight = Player.Sprite:getHeight() * 0.5
  local ballWidth = ballSprite:getWidth() * b.extraSizeFactor
  local ballHeight = ballSprite:getHeight() * b.extraSizeFactor
  local hasCollided = false

  if b.ballPosX <=
     Player.posX + playerHalfWidth and
     b.ballPosY + ballHeight >= Player.posY and
     b.ballPosY < Player.posY + Player.Height and
     b.ballPosX + ballWidth >= Player.posX - playerHalfWidth then
        Balls:handlePlayerBounce(true,b)
  end
end

function Balls:ballHitBrick(ball)
  local brickWidth = brickSprite:getWidth()
  local brickHeight = brickSprite:getHeight()
  local ballWidth = ballSprite:getWidth() * ball.extraSizeFactor
  local ballHeight = ballSprite:getHeight() * ball.extraSizeFactor
  local hasCollided = false
 
  -- Here's where the Balls collision with Bricks happens

  for i = #bricksLineController.bricks, 1, -1 do
      local b = bricksLineController.bricks[i]
      if ((ball.ballPosX <= (b.brickPosX + brickWidth)) and
        ((ball.ballPosX + ballWidth) >= b.brickPosX) and
        ((ball.ballPosY + ballHeight) >= b.brickPosY) and
        (ball.ballPosY < b.brickPosY + brickHeight)) then
        
        if hasCollided == false then
          Balls:handleBrickBounce(ball)
          hasCollided = true
        end

        if b.isPowerUp then
          powerUpsController:spawnPowerUp(b.brickPosX, b.brickPosY)
        end

        table.remove(bricksLineController.bricks, i)
         -- Highscore multiplier, multiplier will increase by 1 every 5th Brick
        Manager.countToTriggerMultiplier = Manager.countToTriggerMultiplier + 1
        if Manager.countToTriggerMultiplier >= Manager.triggerMultiplier then
          Manager.hasMultiplier = true
          Manager.scoreMultiplier = Manager.scoreMultiplier + 1
          Manager.countToTriggerMultiplier = 0
        end
        Manager.Highscore = Manager.Highscore + 10 * Manager.scoreMultiplier
        ball.hitBrickSound:setVolume(0.2)
        ball.hitBrickSound:play()
      end
    end
end

-- Update Ball if it's outside the screen
function Balls:ballReset(b)
  if b.ballPosY > Window.Height then
    -- Reset the Ball and Multiplier
    ballsController.spawnBall(0, 0)
    Manager.hasMultiplier = false
    Manager.scoreMultiplier = 1
    Manager.countToTriggerMultiplier = 0
  end
end

function Balls:update(dt)

  if isPowerUpActive == true then
    -- If the power-up is the big ball, display timer
    if powerUp.setRandomPowerUp == powerUpBigBallSprite then
      powerUpTimer = powerUpTimer - love.timer.getDelta()
    end
  end
  -- Checks if the Ball collides with Player, if it does play sound
  local playerHalfWidth = Player.Sprite:getWidth() * 0.5
  local playerHalfHeight = Player.Sprite:getHeight() * 0.5
  local ballWidth = ballSprite:getWidth() * Ball.extraSizeFactor
  local ballHeight = ballSprite:getHeight() * Ball.extraSizeFactor
  if Ball.ballPosX <=
     Player.posX + playerHalfWidth and
     Ball.ballPosY + ballHeight >= Player.posY and
     Ball.ballPosY < Player.posY + Player.Height and
     Ball.ballPosX + ballWidth >= Player.posX - playerHalfWidth then
        Ball.hitPlayerSound:setVolume(0.2)
        Ball.hitPlayerSound:play()
  end

  -- Manages several balls
  for _,b in pairs(ballsController.balls) do
     
    Balls:ballStart(b)
    -- Update "collisions" between the game window, bricks and player
    Balls:ballHitRoof(b)
    Balls:ballHitLeft(b)
    Balls:ballHitRight(b)
    Balls:ballHitPlayer(b)
    Balls:ballHitBrick(b)
    Balls:ballReset(b)

  -- When the timer has reached 0, reset the Ball size 
  -- Currently only revolves around the Big Ball
    if powerUpTimer <= 0 then
      isPowerUpActive = false
      b.extraSizeFactor = 1
      b.ballScaleFactor = 1
      powerUpTimer = addTime
    end
  
    b.ballPosX = b.ballPosX + (b.ballDirX * b.ballSpeed * dt)
    b.ballPosY = b.ballPosY + (b.ballDirY * b.ballSpeed * dt)
    
    if #ballsController.balls > 1 then
      for i = #ballsController.balls, 1, -1 do
        local ball = ballsController.balls[i]
        if ball.ballPosY >= love.graphics.getHeight() then
          print("removed a BALL")
          table.remove(ballsController.balls, i)

        end
      end
      print(#ballsController.balls)
    else
      local ball = ballsController.balls[1]
      if ball.ballPosY >= love.graphics.getHeight() then
        Balls:ballReset(ball)
      end
    end
  end
end

function Balls:draw()
  -- Draws several balls
  for _, b in pairs(ballsController.balls) do
    love.graphics.draw(ballSprite,
                       b.ballPosX,
                       b.ballPosY,
                       b.ballOrientation,
                       b.ballScaleFactor,
                       b.ballScaleFactor,
                       b.ballOriginX,
                       b.ballOriginY)
  end
end

function Balls:keypressed(key)
  -- Makes the ball "unstuck" from player
  if key == "space" then
    for _, b in pairs(ballsController.balls) do
      b.stuckToPlayer = false
      end
    
    print("In Ball:keypressed")
  end
end

return Balls
