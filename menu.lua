menu={buttons={},screen=0}
menu.buttons.code={"initGame()","love.event.quit()"}
-- rus menu.buttons.text={"Играть","Выход"}--"Вийди 3вiдси розбiйник"

menu.buttons.text={"Play","Exit"}

function menu.buttxy(i,f,t)
  f=f or fonts.menu
  t=t or menu.buttons.text[i]
  local x=(w/2)-(f:getWidth(t)/2)
  local y=(h/2)+(i*f:getHeight())
  return tonumber(x),tonumber(y)
end

function menu.buttwh(i,f)
  f=f or fonts.menu
  local w=f:getWidth(menu.buttons.text[i])
  local h=f:getHeight()
  return w,h
end

function initGame(wn)
  world.name=wn or world.name
  inGame=true
  if not(gameInit)then
    chl.f.init()
    phy.init()
    gameInit=true
  end
end

function menu.loop()
  if(menu.screen==0)then
    for i=1,table.count(menu.buttons.text) do
      local tm1,tm2=menu.buttxy(i)
      local xm1,xm2=menu.buttwh(i)
      if(isInRect(mx,my,tm1,tm2,tm1+xm1,tm2+xm2) and m1)then
        menu.buttons.code[i]()
      end
    end
  end

end

function menu.draw()
  if(menu.screen==0)then
    love.graphics.setFont(fonts.title)
    love.graphics.print(gameName,menu.buttxy(-1,fonts.title,gameName))

    for i=1,table.count(menu.buttons.text)do
      love.graphics.setFont(fonts.menu)
      love.graphics.setColor(1,1,1)
      --------------------------------------------------------------
      love.graphics.print(menu.buttons.text[i],menu.buttxy(i))
      --------------------------------------------------------------
      love.graphics.setFont(fonts.default)
    end
  end
end

function menu.init()
  for i=1,table.count(menu.buttons.code)do
    menu.buttons.code[i]=loadstring(menu.buttons.code[i])
  end
end
