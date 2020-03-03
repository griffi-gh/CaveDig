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
phy.player = {type='player'}

phy.nocollosion = {5,8}


function phy.playerFilter(item, other)
  if other.type=='entity' then return 'cross' end
  return 'slide'
end

function phy.entFilter(item, other)
  if other.type=='player' then return 'cross' end
  return 'slide'
end

function phy.init()
  phy.world:add(phy.player,(px or w/2),(py or h/2),world.tile.w-4,(world.tile.h*2)-4)
end

function phy.loop()
  if nf(phy.relc)==0 then
    phy.reloadBlocks()
    phy.relc=5 --PHYSICS RELOAD EVERY x FRAMES // 0-EVERY FRAME
  else
    phy.relc=phy.relc-1
  end

  local rpx2, rpy2, cols, len = phy.world:move(phy.player,px,py+player.gravity+(phy.player.Drop or 0),phy.playerFilter)
  rpx=rpx2
  rpy=rpy2

  --[[local enableShittyGravity=true
  if(phy.entities and entities and enableShittyGravity)then
    for i,v in ipairs(phy.entities) do
      local gx,gy=entities.spawned[i].pos.x,entities.spawned[i].pos.y+1
      local rx,ry,cols,colc=phy.world:move(v,gx,gy,phy.entFilter)
      entities.spawned[i].pos.y=ry
      entities.spawned[i].pos.x=rx
    end
  end]]

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

  phy.entities={}
  local et=entities
  if(et)then
    for i=1,#et.spawned do
      local etbox=api.entities.getPosition(i)
      phy.entities[i]=phy.addBlock(etbox.x+etbox.w,etbox.y+etbox.h,etbox.w,etbox.h,'entity')
    end
  end

  for i=1,world.h*world.w do
    if world.chunk.data[i]>0 then
      local tmpx2,tmpy2=t2d1d(i,world.w)
      if(tmpx2*world.tile.w>0)then
        if table.has_value(blocksOnScreen or {i},i) then
  	      if table.has_value(phy.nocollosion, world.chunk.data[i]) == false then
            phy.addBlock(tmpx2*world.tile.w,tmpy2*world.tile.h,world.tile.w,world.tile.h,'block')
  		    end
        end
      end
    end
  end

end

function phy.addBlock(x,y,w,h,type)
    type=type or 'block'
    local block = {x=x,y=y,w=w,h=h,type=type}
    phy.blocks[#phy.blocks+1] = block
    phy.world:add(block, x,y,w,h)
    phy.uu=true
    return block
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
  phy.player.Drop=64
end

--phy.entities={}
--[[function phy.entityUpdate()
  local e=entities
  if(e)then
    for i=1,#phy.entities do
      phy.world:remove(phy.entities[i])
    end
    phy.entities={}
    for i=1,#e.spawned do
      if(e.spawned[i].pos.cx==world.chunk.id.x and e.spawned[i].pos.cy==world.chunk.id.y)then
        phy.entities[i]={
          type='entity',
          NotPlCol=true,
          x=e.spawned[i].pos.x,
          y=e.spawned[i].pos.y,
          w=e.list[e.spawned[i].id].size.w,
          h=e.list[e.spawned[i].id].size.h,
        }
        ce=phy.entities[i]
        phy.world:add(ce,ce.x,ce.y,ce.w,ce.h)
        phy.world:check(ce)
        print(phy.world:getRect(ce))
      end
    end
  end
end]]
