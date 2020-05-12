require'f'
require'modapi'
require 'lang'
langfile = "testlang.lang"
api.lang.load(langfile)
gameName=api.lang.get("game.title")
version=38
OFFSCR=0.99
ru=false --///RUS LANG///
cheat=false --/// Q- fast break /// G- invert gravity ///
debug=1 --/// 0=off /// 1=FPS only /// 2=FPS and DT /// 3=2-line FPS,DT and AVG DT ///
enable3d=false

utf8=require("utf8")
baton = require 'lib.Baton.baton' --BATON INPUT
Camera = require 'lib.Camera.camera'  --STALKERX CAMERA
bump = require 'lib.bump.bump' --BUMP COLLISION

require'loadmusic'
require'chunk-generator'


local input = baton.new {
  controls = {
    up = {--[['key:up', 'key:w', 'axis:lefty-', 'button:dpup']]},
    down = {--[['key:down', 'key:s', 'axis:lefty+', 'button:dpdown']]},
    left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
    right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
    jump = {'key:space','button:a'},
    craft = {'key:c','button:x'},
  },
  pairs = {
    move = {'left', 'right','up','down'}
  },
  joystick = love.joystick.getJoysticks()[1],
}

if(rus)then
rtxt={"Не копай под себя","Также попробуйте Minecraft и Terraria","Постоянные вылеты!",
"OwO","Без ГМО","Что это за игра?","Скидка 100%","Красивые блоки","Не содержит сахар!",
"РACCKA3 O ПTNЦAX БE3 ГОЛ0СА","Привет, <ваше имя>.","Шоу русалок:15423","Баги везде!"}
else
rtxt={"Do not dig for yourself", "Also try Minecraft and Terraria", "Constant crashes!",
"OwO", "Non-GMO", "What kind of game is this?", "100% discount", "Beautiful blocks", "Sugar free!",
"tpt", "Hello, <your name>.", "Mermaid show: 15423", "Bugs everywhere!"}
end

texture_dir="textures/world/"
brk_texture_dir="textures/destroy/"
events={}
player={x=0,y=0,brk=0,jump=false}

player.hp = 20
player.maxhp = 20

world={chunk={},tile={}}
world.tile.textures={}
world.tile.texture_files={"dirt.png","grass.png","stone.png","sand.png","wood.png",
"leaves.png","sandstone.png","cactus.png","planks.png","stick.png","wooden_axe.png",
"iron_ore.png","wooden_pickaxe.png"}
--world.tile.strength={30,30,200,20,100,20,100,20,50}
world.tile.ItemData={}

world.tile.ItemData[1] = {type="block",strength=35} --dirt
world.tile.ItemData[2] = {type="block",strength=35} --grass
world.tile.ItemData[3] = {type="block_stone",strength=200} --stone
world.tile.ItemData[4] = {type="block",strength=30} --sand
world.tile.ItemData[5] = {type="block_wood",strength=100}--wood
world.tile.ItemData[6] = {type="block",strength=10}--leaves
world.tile.ItemData[7] = {type="block",strength=150}--sandstone
world.tile.ItemData[8] = {type="block",strength=20}--cactus
world.tile.ItemData[9] = {type="block",strength=100} --planks
world.tile.ItemData[10] = {type="item",strength=9999} --stick
world.tile.ItemData[11] = {type="item_axe",strength=2}--wooden axe
world.tile.ItemData[12] = {type="block_stone",strength=215}--iron ore
world.tile.ItemData[13] = {type="item_pickaxe",strength=2}--wooden pickaxe

world.tile.actions=table.fill(table.count(world.tile.texture_files),"")
world.tile.destroy_textures={}
world.tile.brktxt_count=10


world.w=64
world.h=64
world.name="World"
world.chunk.data=table.fill(world.h*world.w,0) -- blocks data
world.chunk.id={x=0,y=0}
world.tile.h=32
world.tile.w=32

require'font'
require'physics'
require'chunk-loader'
--require'menu'
require'item'
require'menu'
require'craft'
require'entity'

function love.textinput(text)
  menu.enterText(text,bs)
end

function love.mousepressed(x,y,button)
  menu.mousep(x,y,button)
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

function closeGame()
  if(gameInit)then chl.f.saveChunk() end
  love.window.close()
  love.event.quit()
end

function XYtoBlock(mx,my)
  local x=math.ceil(mx/world.w*2)
  local y=math.ceil(my/world.h*2)
  return x,y
end

function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
end

function love.keypressed(key,scancode,isrepeat) --DEBUG
  if key=='backspace' or key=='return' then
    love.textinput(key)
  end
  if(key=="k")then chl.f.saveChunk() end
  if(key=="escape")then
    inGame=false;
    menu.screen=0;
    XworldI=false;
    XworldName=nil;
  end
  if(cheat and inGame) then
    if(key=="q")then world.tile.ItemData=table.fill(#world.tile.ItemData) end
    if(key=="g")then player.weight=-player.weight end
  end
end

function love.load()
  love.window.setVSync(-1)
  love.window.setTitle(gameName.." v."..version.." - "..rtxt[love.math.random(1,table.count(rtxt))])
  h=love.graphics.getHeight()
  w=love.graphics.getWidth()
  for i=1,table.count(world.tile.texture_files) do
    world.tile.textures[i]=love.graphics.newImage(texture_dir..world.tile.texture_files[i])
  end
  for i=1,world.tile.brktxt_count do
    world.tile.destroy_textures[i]=love.graphics.newImage(brk_texture_dir..i..".png")
  end
  for i=1,table.count(world.tile.actions)do
    world.tile.actions[i]=loadstring(world.tile.actions[i])
  end

  ------------------------------------------------------------------------------
  --initGame()
  ------------------------------------------------------------------------------

  camera = Camera()
  camera:setBounds(0,0,(world.w-1)*world.tile.w, (world.h-1)*world.tile.h)
  camera:setFollowStyle('TOPDOWN_TIGHT')

  api.inner.init()
  menu.init()
end

function love.update(dt)

  udt=dt
  adt=love.timer.getAverageDelta()
  fps=love.timer.getFPS()

  if(fps>70)then
    love.window.setVSync(1)
    VsyncCompMode=true
  end

  collectgarbage("collect")
  inGui=crafting.gui.enable --or or or...

  m1, m2 = love.mouse.isDown(1),love.mouse.isDown(2)
  mx, my = love.mouse.getPosition()

  input:update()

  if not(inGame) then
    menu.loop()
  else
    if(input:pressed 'jump') and phy.player.isOnGround() then
      player.jump=true
    end

    if(input:pressed 'craft') and phy.player.isOnGround() then
      crafting.gui.enable=not crafting.gui.enable
    end

    inputx,inputy=input:get 'move';
    px,py= inputx*(4)+(rpx or w/2),inputy*(4)+(rpy or h/2)

    camera:update(dt)
    camera:follow((rpx or 0)-4-world.tile.w/2,(rpy or 0)+4-world.tile.h/2)

    mxw,myw=camera:toWorldCoords(mx,my)
    mxb,myb=XYtoBlock(mxw,myw)
    mouseBlock=world.chunk.data[t1d2d(mxb,myb,world.w)]

    if not inGui then
      if(m1 and mouseBlock>0 and (player.prevBlock==t1d2d(mxb,myb,world.w) or player.brk==0))then
        player.prevBlock=t1d2d(mxb,myb,world.w)
        local toadd = 0
    	  if (player.inventory[inv.selected].id > 0 and world.tile.ItemData[player.inventory[inv.selected].id].type == "item_axe" and  world.tile.ItemData[mouseBlock].type == "block_wood" ) then
          toadd = world.tile.ItemData[player.inventory[inv.selected].id].strength+1
        elseif (player.inventory[inv.selected].id > 0 and world.tile.ItemData[player.inventory[inv.selected].id].type == "item_pickaxe" and  world.tile.ItemData[mouseBlock].type == "block_stone" ) then
			toadd = world.tile.ItemData[player.inventory[inv.selected].id].strength+1
		  else
			toadd = 1
    	  end
        player.brk=player.brk+toadd

        if(player.brk>world.tile.ItemData[mouseBlock].strength)then
          inv.addItem(world.chunk.data[t1d2d(mxb,myb,world.w)])
          world.chunk.data[t1d2d(mxb,myb,world.w)]=0
        end
      else
        player.brk=0
      end
      if(m2)then
        if(world.chunk.data[t1d2d(mxb,myb,world.w)]==0)then
          if(player.inventory[inv.selected].q>0)then
            local type=world.tile.ItemData[player.inventory[inv.selected].id].type or ""
            local canPlace= type== "block" or type== "block_wood" or type== "block_stone"
            if(canPlace)then
              world.chunk.data[t1d2d(mxb,myb,world.w)]=player.inventory[inv.selected].id
              inv.removeItem(nil,1,inv.selected)
            end
          end
        else
          world.tile.actions[world.chunk.data[t1d2d(mxb,myb,world.w)]]()
        end
      end
    end

    local function movp(x,y)
      if x then px=x*world.tile.w end
      if y then py=y*world.tile.h end
      if x or y then phy.world:update(phy.player,px,py) end
    end

    if(px<0)then
      chl.f.moveToChunk(world.chunk.id.x-1,world.chunk.id.y)
      movp(world.w-2,-16)
      phy.player.dropOnGround();phy.player.dropOnGround()
    end
    if(px>world.w*world.tile.w)then
      chl.f.moveToChunk(world.chunk.id.x+1,world.chunk.id.y)
      movp(2,-16)
      phy.player.dropOnGround();phy.player.dropOnGround()
    end

    phy.loop()
  end
end

function love.draw()

  love.graphics.setBackgroundColor(0,0,0)
  if not(inGame) then
    menu.draw()
  else
    love.graphics.setBackgroundColor(0.5,0.5,1)

    camera:attach()

    blocksOnScreen={}

    for i=1,world.w-1 do
      for j=1,world.h-1 do
        rangex=OFFSCR*world.tile.h
        rangey=OFFSCR*world.tile.w
        local tmpx=(i*world.tile.w)-camera.x+w/2
        local tmpy=(j*world.tile.h)-camera.y+h/2
        if(tmpx>0-rangex and tmpx<w+rangex and tmpy>0-rangey and tmpy<h+rangey)then
          local texture_id=world.chunk.data[t1d2d(i,j,world.w)]
          if(texture_id>0)then
            blocksOnScreen[#blocksOnScreen+1]=t1d2d(i,j,world.w)
	    if enable3d then
		for z=-10,0 do
                love.graphics.setColor(math.abs(z)/10+0.6,math.abs(z)/10+0.6,math.abs(z)/10+0.6) --3D
                love.graphics.setColor(math.abs(z)/10,math.abs(z)/10,math.abs(z)/10,0.5) --FOG
                love.graphics.draw(world.tile.textures[texture_id],(i-1)*world.tile.h-z,(j-1)*world.tile.w-z)
            else
            	love.graphics.draw(world.tile.textures[texture_id],(i-1)*world.tile.h,(j-1)*world.tile.w)
            end
          end
        end
      end
    end

    --OwO


    if(player.brk>0)then
	  local toadd = 0
	  if (player.inventory[inv.selected].id > 0 and world.tile.ItemData[player.inventory[inv.selected].id].type == "axe" and  world.tile.ItemData[mouseBlock].type == "block_wood" ) then
      toadd = world.tile.ItemData[player.inventory[inv.selected].id].strength+1
    else
      toadd = 1
	  end
      local txtid=math.min(math.floor(player.brk/world.tile.ItemData[mouseBlock].strength*world.tile.brktxt_count)+toadd,10)
      love.graphics.draw(world.tile.destroy_textures[txtid],(mxb-1)*world.tile.h,(myb-1)*world.tile.h)
    end

    --player (white rect)
    love.graphics.rectangle('fill',(rpx or 0)-world.tile.h,(rpy or 0)-world.tile.w,world.tile.w-4,(world.tile.h*2)-4)

    --hp bar
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle('fill',(rpx or 0)-world.tile.h-15,(rpy or 0)-world.tile.w-35,60,10)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('fill',(rpx or 0)-world.tile.h-15,(rpy or 0)-world.tile.w-35,math.min(math.max(60-(player.maxhp-player.hp),0),60),10)

    love.graphics.setColor(0,0,0)
    love.graphics.setFont(fonts.default_s)
    love.graphics.print(math.floor(api.player.health.get()).."/"..api.player.health.getMax(),(rpx or 0)-world.tile.h-15,(rpy or 0)-world.tile.w-35)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(fonts.default)

    api.entities.f.draw()
    camera:detach()
    camera:draw()

    crafting.f.gui()
    inv.draw()
  end

  api.inner.loop()

  if(debug>=1)then
    local debLINE=1
    local debTXT="FPS:"..fps
    if(debug>=2)then
      debTXT=debTXT.." dt:"..udt
      if(debug>=3)then
        debTXT=debTXT.."\navg dt "..adt
        debLINE=2
      end
    end
    love.graphics.print(debTXT,0,h-12*(debLINE+0.25))
  end
end
