chl={f={}}

function chl.f.init()
  world.chunk.data=chgen.f.gen(1)
  chl.f.moveToChunk(world.chunk.id.x,world.chunk.id.y,true)
  chl.f.saveChunk()
end

function chl.f.formatFolder(worldName)
  worldName=worldName or world.name
  return "world_"..worldName
end
function chl.f.formatFile(worldName,CHX,XHY)
  worldName=worldName or world.name
  local CHX=CHX or world.chunk.id.x
  local CHY=XHY or world.chunk.id.y
  return chl.f.formatFolder(worldName).."/".. CHX ..",".. CHY ..".cdc"
end

function chl.f.isChunkSaved(w,x,y)
  if( love.filesystem.getInfo(chl.f.formatFile(w,x,y)) )then return true else return false end
end

function chl.f.saveChunk(wn)
  love.filesystem.createDirectory(chl.f.formatFolder())
  love.filesystem.write(chl.f.formatFile(wn),table.toString(world.chunk.data))
end

function chl.f.loadChunk(wn,x,y)
  if(chl.f.isChunkSaved(wn,x,y))then
    world.chunk.data=table.loadString(love.filesystem.read(chl.f.formatFile(wn,x,y)),true)
  end
end

function chl.f.moveToChunk(chx,chy,doNotSave,inWorld)
  inWorld=inWorld or world.name
  if not(doNotSave) then
    chl.f.saveChunk()
  end
  --print(" moveTo "..chx.." "..chy.." from "..world.chunk.id.x.." "..world.chunk.id.y)
  if chl.f.isChunkSaved(inWorld,chx,chy) then
    chl.f.loadChunk(inWorld,chx,chy)
  else
    world.chunk.data=chgen.f.gen(1)
  end
  world.chunk.id.x=chx
  world.chunk.id.y=chy
  world.name=inWorld
end
