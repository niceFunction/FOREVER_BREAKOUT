Player = require "Player"
Bricks = require "Brick"
Balls = require "Ball"

Manager = {}
Manager.Background = love.graphics.newImage("Background.png")
Manager.backgroundPosX = 0
Manager.backgroundPosY = 0
Manager.Logotype = love.graphics.newImage("logotype.png")
Manager.logoPosX = love.graphics.getWidth() * 0.5
Manager.logoPosY = love.graphics.getHeight() * 0.5
Manager.logoOrientation = 0
Manager.logoSizeX = 1
Manager.logoSizeY = 1
Manager.logoOriginX = Manager.Logotype:getWidth() * 0.5
Manager.logoOriginY = Manager.Logotype:getHeight() * 0.5
Manager.logoColor = {1 * 0, 1* 0, 1* 0, 0.25}

-- Menu, Game Over and How to Play variables
Manager.menuLogo = love.graphics.newImage("MenuLogotype.png")
Manager.howToPlayImage = love.graphics.newImage("HowToPlay.png")
Manager.gameOverImage = love.graphics.newImage("GameOverLogotype.png")
-- In Main Menu
Manager.enterToPlayImage = love.graphics.newImage("EnterToPlay.png")
Manager.enterToPlayOriginX = Manager.enterToPlayImage:getWidth() * 0.5
Manager.enterToPlayOriginY = Manager.enterToPlayImage:getHeight() * 0.5

Manager.pressHHowToPlayImage = love.graphics.newImage("HToHowToPlay.png")
Manager.pressHHowToPlayOriginX = Manager.pressHHowToPlayImage:getWidth() * 0.5
Manager.hpressHHowToPlayOriginY = Manager.pressHHowToPlayImage:getHeight() * 0.5

Manager.escToQuitImage = love.graphics.newImage("EscToQuit.png")
Manager.escToQuitOriginX = Manager.escToQuitImage:getWidth() * 0.5
Manager.escToQuitOriginY = Manager.escToQuitImage:getHeight() * 0.5
-- In How to Play
Manager.escToBackImage = love.graphics.newImage("EscToBack.png")

-- In Game Over
Manager.escToMenuImage = love.graphics.newImage("EscToMainMenu.png")
-- General for text images

Manager.gameOverOriginX = Manager.gameOverImage:getWidth() * 0.5
Manager.gameOverOriginY = Manager.gameOverImage:getHeight() * 0.5
Manager.howToPlayPosX = 100
Manager.howToPlayPosY = 50
Manager.howToPlayOrientation = 0
Manager.howToPlaySizeX = 1
Manager.howToPlaySizeY = 1

-- Game variables
Manager.Border = love.graphics.newImage("border.png")
Manager.borderPosX = 0
Manager.borderPosY = 940
Manager.defaultFont = love.graphics.newFont(12)
Manager.scoreFont = love.graphics.newFont("Square.ttf", 24)
Manager.Highscore = 0
Manager.countToTriggerMultiplier = 0
Manager.triggerMultiplier = 5
Manager.hasMultiplier = false
Manager.scoreMultiplier = 1
Manager.maxScoreMultiplier = 8
Manager.scorePosX = 10
Manager.scorePosY = 950

Window = {}
Window.Width = love.graphics.getWidth()
Window.Height = love.graphics.getHeight()
function Manager:resetGame()
  isPowerUpActive = false
  
  -- Reset bricks
  for i,b in ipairs(bricksLineController.bricks) do
    table.remove(bricksLineController.bricks, i)
  end
  
  -- Remove any additional balls on screen (it should do that)
    ballsController.balls[1].ballPosX = Player.posX - 8 
    ballsController.balls[1].ballPosY = Player.posY - 16
    ballsController.balls[1].stuckToPlayer = true
    ballsController.balls[1].extraSizeFactor = 1
    ballsController.balls[1].ballScaleFactor = 1
  if #ballsController.balls > 1 then
    for i = #ballsController.balls, 2, -1 do
      table.remove(ballsController.balls, i)
    end
  end

  -- Reset Power-Ups
  for i, p in pairs(powerUpsController.powerups) do
    table.remove(powerUpsController.powerups, i)
  end
  
  -- Reset Player position and velocity
  Player.posX = love.graphics.getWidth() * 0.5
  Player.posY = love.graphics.getHeight() - 80
  Player.Velocity = 0
  
  -- Reset score and multiplier
  Manager.Highscore = 0
  Manager.hasMultiplier = false
  Manager.scoreMultiplier = 1
  Manager.countToTriggerMultiplier = 0
  
end

function Manager:DebugMode()
    if love.keyboard.isDown("c") then
        love.graphics.setFont(Manager.defaultFont)
        -- Draws the Players origin position
        love.graphics.setColor(0, 0, 0, 1)
        for _,b in pairs(bricksLineController.bricks) do
          -- Draw outlines on bricks
          love.graphics.rectangle("line", b.brickPosX,
                                  b.brickPosY,
                                  50, 24)
        end
        love.graphics.setColor(1, 1, 1, 1)

        -- Draw Ball origin
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", Ball.ballPosX, Ball.ballPosY, 4, 4)
        -- Draw three lines on the player to determine the exact middle
        -- Draw left line
        love.graphics.rectangle("fill",
                                Player.posX - 2,
                                Player.posY,
                                1,
                                16)
        -- Draw middle line
        love.graphics.rectangle("fill",
                                Player.posX,
                                Player.posY,
                                1,
                                16)
        -- Draw right line
        love.graphics.rectangle("fill",
                                Player.posX + 2,
                                Player.posY,
                                1,
                                16)
        love.graphics.setColor(1, 1, 1, 1)

        -- Set a black background for the "debug menu"
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 5, 5, 135, 170)
        love.graphics.setColor(1, 1, 1, 1)

        -- Prints the word "DebugMode"
        love.graphics.print("DebugMode", 10, 10)
        -- Prints players position on X/Y
        love.graphics.print("Player X: "
                            ..string.format("%.0f", Player.posX),
                            10,
                            25)
        love.graphics.print("Player Y: "
                            ..Player.posY,
                            10,
                            40)
        -- In a number, shows where the players origin position is
        love.graphics.print("Player Origin X: "..Player.originX, 10, 55)
        -- Shows the players velocity
        love.graphics.print("Player Velocity: "..string.format(
                            "%.0f", Player.Velocity), 10, 70)
        -- Displays players total width/height
        love.graphics.print("Player Width: "..Player.Sprite:getWidth(), 10, 85)
        love.graphics.print("Player Height: "..Player.Sprite:getHeight(), 10, 100)
        -- Displays the ball's current X/Y position
        love.graphics.print("ballPosX: "
                            ..string.format("%.0f",Ball.ballPosX),
                            10,
                            120)
        love.graphics.print("ballPosY: "
                            ..string.format("%.0f", Ball.ballPosY),
                            10,
                            135)
        -- Displays a counter that every time it reaches '5' it will add to
        -- the multiplier
        love.graphics.print("x Trigger: "
                            ..Manager.countToTriggerMultiplier,
                            10,
                            155)

    end
end

function Manager:load()
end

function Manager:update(dt)
  Manager:DebugMode()
  -- Sets a maximum amount possible for multiplier
  if Manager.scoreMultiplier >= Manager.maxScoreMultiplier then
    Manager.scoreMultiplier = Manager.maxScoreMultiplier
  end

end

function Manager:draw()
  -- Draws background
  love.graphics.draw(Manager.Background,
                     Manager.backgroundPosX,
                     Manager.backgroundPosY)
  -- Draws a sprite that's placed below the player
  love.graphics.draw(Manager.Border,
                     Manager.borderPosX,
                     Manager.borderPosY)

  -- Draws the logotype in the background with opacity (alpha)
  love.graphics.setColor(Manager.logoColor)
  love.graphics.draw(Manager.Logotype,
                     Manager.logoPosX,
                     Manager.logoPosY,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.logoOriginX,
                     Manager.logoOriginY)
  love.graphics.setColor(1, 1, 1, 1)

  -- Draws the highscore
  love.graphics.setFont(Manager.scoreFont, 24)
  love.graphics.print("HI: "..Manager.Highscore,
                      Manager.scorePosX,
                      Manager.scorePosY)
  -- Displays the multiplier but only if the player has one
  if Manager.hasMultiplier == true then
    love.graphics.print(" x "..Manager.scoreMultiplier,
                        Manager.scoreFont:getWidth(Manager.Highscore) + 40,
                        Manager.scorePosY)
  else
    -- And if the player doesn't have a multiplier, it's false
    Manager.hasMultiplier = Manager.hasMultiplier
  end
end

return Manager
