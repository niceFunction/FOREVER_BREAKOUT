Brick = require "Brick"
--Ball = require "Ball"
Player = require "Player"

powerUpDoubleBallSprite = love.graphics.newImage("doubleBallSprite.png")
powerUpDoubleBallColor = {}
powerUpBigBallSprite = love.graphics.newImage("bigBallSprite.png")

isPowerUpActive = false

addTime = 30
powerUpTimer = addTime
powerUpsController = {}
powerUpsController.powerups = {}

function powerUpsController:spawnPowerUp(posX, posY)
  powerUp = {}
  powerUp.powerUpPosX = posX
  powerUp.powerUpPosY = posY
  powerUp.powerUpOrientation = 0
  powerUp.powerUpScaleX = 1
  powerUp.powerUpScaleY = 1
  powerUp.powerUpOriginX = 0
  powerUp.powerUpOriginY = 0
  powerUp.powerUpVelocity = 2
  powerUp.powerUpDoubleX = Ball.ballPosX
  powerUp.powerUpDoubleY = Ball.ballPosY
  powerUp.powerUpSound = love.audio.newSource("PowerUpSound.wav", "static")
  powerUp.powerUpAddSizeFactor = 8
  local randomizePowerUp = love.math.random(1, 2)
    if randomizePowerUp == 1 then
      -- Line below is for testing
      powerUp.setRandomPowerUp = powerUpDoubleBallSprite
    elseif randomizePowerUp == 2 then
      powerUp.setRandomPowerUp = powerUpBigBallSprite
    end

  table.insert(powerUpsController.powerups, powerUp)

end

function powerUpsController:doubleBall()
  -- Keeps the amount of balls to 2
  if #ballsController.balls < 2 then
    ballsController.spawnBall(Ball.ballPosX, Ball.ballPosY)
  end
  
end

function powerUpsController:bigBall()
  Ball.extraSizeFactor = powerUp.powerUpAddSizeFactor
  Ball.ballScaleFactor = Ball.extraSizeFactor
end

function powerUpsController:update(dt)

  local playerHalfWidth = Player.Width * 0.5
  local playerHalfHeight = Player.Height * 0.5
  local randomizePowerUp = love.math.random(1, 2)
-- Removes power-up if it moves "outside" of the screen
  for i, p in pairs(powerUpsController.powerups) do
    -- Moves the power-up positively on Y

    p.powerUpPosY = p.powerUpPosY + p.powerUpVelocity
    local powerUpWidth = p.setRandomPowerUp:getWidth()
    local powerUpHeight = p.setRandomPowerUp:getHeight()

    if ((p.powerUpPosX <= (Player.posX + playerHalfWidth)) and
       ((p.powerUpPosX + powerUpWidth) >= Player.posX - playerHalfWidth) and
       ((p.powerUpPosY + powerUpHeight) >= Player.posY) and
       (p.powerUpPosY < Player.posY + playerHalfHeight)) then
         isPowerUpActive = true
        if p.setRandomPowerUp == powerUpDoubleBallSprite then
          powerUpsController.doubleBall()
        elseif p.setRandomPowerUp == powerUpBigBallSprite then
          powerUpsController.bigBall()
        end

        
         -- Adds 1000 points to Highscore and removes power-up
         Manager.Highscore = Manager.Highscore + 1000
         p.powerUpSound:setVolume(0.2)
         p.powerUpSound:play()
         table.remove(powerUpsController.powerups, i)
    end

    -- Removes power-up if it reaches a certain point
    if p.powerUpPosY >= 950 then
      table.remove(powerUpsController.powerups, i)
    end
  end

end

function powerUpsController:draw()
  --[[
     Depending on what power-up that spawns, change 'setRandomUp' (which is nil)
     into the appropriate Sprite.
    ]]

    if isPowerUpActive == true then
      love.graphics.print(math.floor(powerUpTimer),
                          love.graphics.getWidth() * 0.5,
                          love.graphics.getHeight() - 50)
    elseif powerUpTimer <= 0 then
      isPowerUpActive = false
    end
    for _,p in ipairs(powerUpsController.powerups) do
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.rectangle("fill", p.powerUpPosX, p.powerUpPosY, 4, 4)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(p.setRandomPowerUp,
                        p.powerUpPosX,
                        p.powerUpPosY,
                        p.powerUpOrientation,
                        p.powerUpScaleX,
                        p.powerUpScaleY,
                        p.powerUpOriginX,
                        p.powerUpOriginY)
    end

  end

  --love.graphics.setColor(1, 1, 1, 1)


return powerUpsController
