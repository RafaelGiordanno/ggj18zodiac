local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")
local lume          = requireLibrary("lume")
local anim8         = requireLibrary("anim8")

--------------------------------------------------------------------------------
-- Class Definition
--------------------------------------------------------------------------------

ScreenMsg = Class{
  -- initializes the inventory
	init = function(self)
    self.box_x = 70
    self.box_y = 103
    self.box_w = 184
    self.box_h = 60
    self.ui_texto_y = -600
    self.txt_x = 70 
    self.txt_y = 103 
    self.tcount = 0
    self.msg = nil
    self.bg_img = Image.ui_texto
    self.button_press_sprite = Image.button_pressing
    self.button_press_grid = anim8.newGrid(self.button_press_sprite:getWidth()/4, self.button_press_sprite:getHeight(),
                                   self.button_press_sprite:getWidth(), self.button_press_sprite:getHeight())
    self.button_animation =  anim8.newAnimation(self.button_press_grid('1-4',1), 0.2)
  end,

  setMsg = function(self,msg)
    if self.msg ~= msg then 
      self.tcount = 0      
    end 

    self.msg = msg
  end,

  hasMsg = function(self)
    return self.msg ~= nil and string.len(self.msg)>1
  end,


  draw = function(self)
    -- the screen msg is only drawn if it exists!
    if self.hasMsg(self) then
      local t_limit = self.box_w-2
      local t_align = 'left'
      -- let's guarantee the background is drawn with proper alpha
      love.graphics.setColor( 255, 255, 255, 255 )

      -- we will tween it
      self.ui_texto_y  = lume.lerp(self.ui_texto_y , 0, .18)
      love.graphics.draw(self.bg_img  ,0,self.ui_texto_y )

      if self.tcount>0.7 then
        self.button_animation:draw(self.button_press_sprite,240,150)
      end

      -- now we draw the text on top of the dialog background
      love.graphics.setFont(font_Verdana2)
      love.graphics.setColor( 255, 255, 255, 255 )

      love.graphics.printf(self.msg,
        self.txt_x, self.txt_y+self.ui_texto_y,
        t_limit, t_align)
    else

      -- if we have no text, we just hide the dialog
      self.ui_texto_y  = lume.lerp(self.ui_texto_y , -600, .2)
      love.graphics.draw(self.bg_img,0,self.ui_texto_y )
    end
  end,
  update = function(self,dt)
    if self.hasMsg(self) then
      self.tcount = self.tcount + dt
      self.button_animation:update(dt)
    end
  end 
}

return ScreenMsg