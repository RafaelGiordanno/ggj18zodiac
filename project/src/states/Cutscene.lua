--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local Timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local Tween         = Timer.tween
local map
local a
local b
local strength
local cnv

Cutscene = Gamestate.new()

local stuff = {}
local opacityTween
local cutscene_p1_xpos
local cutscene_p2_xpos
local cutscene_p3_xpos
local opacity_step
local xpos_step
local change_scene_once
local cutscene_active 

function Cutscene:enter()
  cutscene_active = true
  opacityTween = 0
  xpos_step = 8
  opacity_step = 4
  change_scene_once = true
  cutscene_p1_xpos = 2*GAME_WIDTH
  cutscene_p2_xpos = 2*GAME_WIDTH
  cutscene_p3_xpos = 2*GAME_WIDTH
end

function Cutscene:update(dt)
  if cutscene_active ~= true then
    return false
  end

  if opacityTween<256-opacity_step then
    opacityTween = opacityTween + opacity_step
  else 
    if cutscene_p1_xpos > xpos_step-1 then 
      cutscene_p1_xpos = cutscene_p1_xpos - xpos_step
    else
      if cutscene_p2_xpos > xpos_step-1 then 
        cutscene_p2_xpos = cutscene_p2_xpos - xpos_step
      else
        if cutscene_p3_xpos > xpos_step-1 then 
          cutscene_p3_xpos = cutscene_p3_xpos - xpos_step
        else

          goToGameState('Game')
          if change_scene_once then 
            change_scene_once = false
            cutscene_active = false
          end
      
        end
        
      end

    end
  end

  return Cutscene




end


local function drawFn2()
  if cutscene_active ~= true then
    return false
  end
    -- <Your drawing logic goes here.>
    -- love.graphics.draw(padLeft,a,2)
    love.graphics.setShader()
    cnv = love.graphics.newCanvas(320,180)
    cnv:renderTo(function()
      love.graphics.setColor(255,255,255,opacityTween)
      love.graphics.draw(Image.cutscene_01)
      love.graphics.draw(Image.cutscene_01_p1,cutscene_p1_xpos)
      love.graphics.draw(Image.cutscene_01_p2,cutscene_p2_xpos)
      love.graphics.draw(Image.cutscene_01_p3,cutscene_p3_xpos)

    end)


    love.graphics.setShader(shader_screen)
    strength = math.sin(love.timer.getTime()*2)
    shader_screen:send("abberationVector", {strength*math.sin(love.timer.getTime()*7)/200, strength*math.cos(love.timer.getTime()*7)/200})

    love.graphics.draw(cnv,0,0)
    
end

function Cutscene:draw()
  if cutscene_active ~= true then
    return false
  end


    screen:draw(drawFn2) -- Additional arguments will be passed to drawFn.


end