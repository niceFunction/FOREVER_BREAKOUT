-- Executes modules
Player = require "Player"
Manager = require "GameManager"
Balls = require "Ball"
Bricks = require "Brick"
powerUp = require "Powerup"

--Noooway arkanoid tutorial: https://github.com/noooway/love2d_arkanoid_tutorial/wiki/Resolving-Collisions

--[[
  Creating exe
  https://www.youtube.com/watch?v=yLTYsW_Ab8k
  Menu solutions
  https://gamedev.stackexchange.com/questions/155299/create-a-game-start-up-menu-screen-with-lua-love-2d

]]

function love.load(arg)
 --if arg[#arg] == "-debug" then require("mobdebug").start() end

  currentScreen = 'menu'
  ballsController.spawnBall()
end

function love.update(dt)
  if currentScreen == 'menu' then
    menuUpdate(dt)
    Manager:resetGame()
  elseif currentScreen == 'game' then
    gameUpdate(dt)
  elseif currentScreen == 'howToPlay' then
    howToPlayUpdate(dt)
  elseif currentScreen == 'gameOver' then
    gameOverUpdate(dt)
  end

end

function love.draw()
  if currentScreen == 'menu' then
    menuDraw()
  elseif currentScreen == 'game' then
    gameDraw()
  elseif currentScreen == 'howToPlay' then
    howToPlayDraw()
  elseif currentScreen == 'gameOver' then
    gameOverDraw()
  end

end

function love.keypressed(key)
  Player:keypressed(key)
  Balls:keypressed(key)
  if currentScreen == 'menu' then
    if key == 'escape' then
      love.event.quit()
    end
  end

end

function love.keyreleased(key)
  Player:keyreleased(key)
end

function menuUpdate(dt)

  if love.keyboard.isDown('return') then
    currentScreen = 'game'
  elseif love.keyboard.isDown('h') then
    currentScreen = 'howToPlay'
  end
  

end

function menuDraw()
  love.graphics.draw(Manager.Background,
                     Manager.backgroundPosX,
                     Manager.backgroundPosY)
                   
  love.graphics.draw(Manager.menuLogo,
                     Manager.logoPosX,
                     Manager.logoPosY,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.logoOriginX,
                     Manager.logoOriginY)
                   
  love.graphics.draw(Manager.enterToPlayImage,
                     Manager.logoPosX,
                     650,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.enterToPlayOriginX,
                     Manager.enterToPlayOriginY)
 
  love.graphics.draw(Manager.pressHHowToPlayImage,
                     Manager.logoPosX,
                     700,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.pressHHowToPlayOriginX,
                     Manager.pressHHowToPlayOriginY)
    
  love.graphics.draw(Manager.escToQuitImage,
                     Manager.logoPosX,
                     780,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.escToQuitOriginX,
                     Manager.escToQuitOriginY)
end

function gameOverUpdate(dt)
  if currentScreen == 'gameOver' then
    if love.keyboard.isDown('escape') then
      currentScreen = 'menu'
    end
  end

end

function gameOverDraw()
  love.graphics.draw(Manager.Background,
                     Manager.backgroundPosX,
                     Manager.backgroundPosY)
                 
  love.graphics.draw(Manager.gameOverImage,
                     Manager.logoPosX,
                     Manager.logoPosY,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.gameOverOriginX,
                     Manager.gameOverOriginY)
  
  love.graphics.draw(Manager.escToMenuImage,
                     Manager.logoPosX,
                     900,
                     Manager.logoOrientation,
                     Manager.logoSizeX,
                     Manager.logoSizeY,
                     Manager.escToMenuImage:getWidth() * 0.5,
                     Manager.escToMenuImage:getHeight() * 0.5)
    

end

function howToPlayUpdate(dt)
  if currentScreen == 'howToPlay' then
    print("Inside: howToPlay")
    if love.keyboard.isDown('escape') then
      currentScreen = 'menu'
    end
  end
end

function howToPlayDraw()
    love.graphics.draw(Manager.Background,
                       Manager.backgroundPosX,
                       Manager.backgroundPosY)
    
    love.graphics.draw(Manager.howToPlayImage,
                       Manager.howToPlayPosX,
                       Manager.howToPlayPosY,
                       Manager.howToPlayOrientation,
                       Manager.howToPlaySizeX,
                       Manager.howToPlaySizeY)
    
    love.graphics.draw(Manager.escToBackImage,
                       Manager.logoPosX,
                       900,
                       Manager.logoOrientation,
                       Manager.logoSizeX,
                       Manager.logoSizeY,
                       Manager.escToQuitOriginX,
                       Manager.escToQuitOriginY)
end

function gameUpdate(dt)
  if currentScreen == 'game' then
    if love.keyboard.isDown('escape') then
      currentScreen = 'menu'
    end
  end
  Player:update(dt)
  Balls:update(dt)
  Bricks.update(dt)
  powerUpsController:update(dt)
  Manager:update(dt)
end

function gameDraw()
  Manager:draw()
  Player:draw()
  Balls:draw()
  Bricks:draw()
  powerUpsController:draw()
  
  Manager:DebugMode()
end
