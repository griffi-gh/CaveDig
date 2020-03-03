entities={textures={},list={},spawned={}}
api.entities={f={}}

function api.entities.getPosition(i)
  local et=entities
  local etbox={
    x=et.spawned[i].pos.x,
    y=et.spawned[i].pos.y,
    w=et.list[et.spawned[i].id].size.w,
    h=et.list[et.spawned[i].id].size.h,
    rx=et.spawned[i].pos.rx or et.spawned[i].pos.x,
    ry=et.spawned[i].pos.ry or et.spawned[i].pos.y,
  }
  return etbox
end

function api.entities.newEntity(texture,name,useAI,noGravity)
  local e=entities
  local Eid=#e.list+1
  e.textures[Eid]=love.graphics.newImage(texture)
  e.list[Eid]={}
  e.list[Eid].name=name
  e.list[Eid].useAI=useAI
  e.list[Eid].noGravity=noGravity
  e.list[Eid].size={w=e.textures[Eid]:getWidth(),h=e.textures[Eid]:getHeight()}
  --e.list[id].hp=hp
  return Eid
end

function api.entities.spawnEntity(x,posx,posy,chx,chy) --x is ID OR NAME
  if x==nil then error('missing entity id') end
  posx=posx or px or 0
  posy=posy or py or 0
  chx=chx or world.chunk.id.x or 0
  chy=chy or world.chunk.id.y or 0

  local e=entities
  if type(x)=='string' then
    for i,v in ipairs(e.list) do
      if v.name==x then
        x=i
        break
      end
    end
  end
  local n=#e.spawned+1
  e.spawned[n]={}
  e.spawned[n].id=x
  e.spawned[n].pos={
    x=posx,
    y=posy,
    cx=chx,
    cy=chy,
  }
  return n
end

--TODO ENTITY COLLISION

function api.entities.f.draw()
  local es=entities.spawned
  if(#es>0)then
    for i,v in ipairs(es) do
      if(v.pos.cx==world.chunk.id.x and v.pos.cy==world.chunk.id.y)then
        love.graphics.draw(entities.textures[v.id],v.pos.x,v.pos.y)
      end
    end
  end
end

--local dirt=api.entities.newEntity('textures/world/dirt.png','dirtii')
--api.entities.spawnEntity(dirt,10,128,0,0) --or api.entities.spawnEntity('dirtii')
