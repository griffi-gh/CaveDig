phy={}
player.weight=6
player.jumpspeed=1

player.jumpairtime=10
player.jumpairtimeC=0

player.airtime=10
player.inair=0

player.gravity=0

local LoseHp = 0
local fallen = 0

phy.world  = bump.newWorld(128)
phy.blocks = {}
phy.player = {}

phy.nocollosion = {5,8}

function phy.init()
  phy.world:add(phy.player,(px or w/2),(py or h/2),world.tile.w-4,(world.tile.h*2)-4)
end

function phy.loop()
  local rpx2, rpy2, cols, len = phy.world:move(phy.player,px,py+player.gravity+(phy.player.Drop or 0))
  rpx=rpx2
  rpy=rpy2

  if nf(phy.relc)==0 then
    phy.reloadBlocks()
    phy.relc=5 --PHYSICS RELOAD EVERY x FRAMES // 0-EVERY FRAME
  else
    phy.relc=phy.relc-1
  end

  phy.jump()

  if phy.player.isOnGround(5) then
    phy.player.Drop=0
    if fallen > 30 then
      player.hp = player.hp - LoseHp
      LoseHp = 0
    end
	  fallen = 0
  else
    if not(player.jump) then
      LoseHp = LoseHp + 0.15
      fallen = fallen + 1
    end
  end
end


function phy.reloadBlocks()
  phy.clrBlock()
  for i=1,world.h*world.w do
    if world.chunk.data[i]>0 then
      local tmpx2,tmpy2=t2d1d(i,world.w)
      if(tmpx2*world.tile.w>0)then
	      if table.has_value(phy.nocollosion, world.chunk.data[i]) == false then
          phy.addBlock(tmpx2*world.tile.w,tmpy2*world.tile.h,world.tile.w,world.tile.h)
		    end
      end
    end
  end
end



function phy.addBlock(x,y,w,h)
    local block = {x=x,y=y,w=w,h=h}
    phy.blocks[#phy.blocks+1] = block
    phy.world:add(block, x,y,w,h)
    phy.uu=true
end

function phy.clrBlock()
  if phy.uu then
    for i=1,table.count(phy.blocks) do
      phy.world:remove(phy.blocks[i])
    end
    phy.blocks={}
  end
end

function phy.jump()
  if player.jump then
    player.gravity=-player.weight
    player.inair=player.inair+player.jumpspeed
    if(player.inair>player.airtime)then
      player.jumpairtimeC=player.jumpairtime
      player.jump=false
    end
  else
    if(player.jumpairtimeC>0) then
      player.jumpairtimeC=player.jumpairtimeC-1
      player.gravity=0.1
    else
      player.jumpairtimeC=0
      player.gravity=player.weight
      player.inair=0
      inair=0
    end
  end
end





function phy.player.isOnGround(s)
  s=s or 4
  local actualX, actualY, cols, len = phy.world:check(phy.player, nf(rpx), nf(rpy)+world.tile.h/2+s)
  if len>0 then return true else return false end
end

function phy.player.dropOnGround()
  phy.player.Drop=255
end
