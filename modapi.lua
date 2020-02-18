api={inner={},loader={},blocks={}}
mods={data={}}
api.inner.mod_directory="mods"

function api.loader.modList()
  local filesTable =love.filesystem.getDirectoryItems(api.inner.mod_directory)
  local output={}
  local j=1
  for i,v in ipairs(filesTable) do
    --if love.filesystem.getInfo(v).type=='file' then
      if v:find(".lua") ~= nil then
        output[j]=v
        j=j+1
      end
    --end
  end
  return output
end

function api.blocks.createBlock(texture,strength,type,noCollision,action)
  local id=table.count(world.tile.textures)+1
  texture=api.inner.mod_directory.."/"..texture
  action=action or ""

  world.tile.texture_files[id]=texture
  world.tile.textures[id]=love.graphics.newImage(texture)
  if(noCollision)then
    phy.nocollosion[table.count(phy.nocollosion)+1]=id
  end
  world.tile.ItemData[table.count(world.tile.ItemData)+1].strength=strength or 5
  world.tile.ItemData[table.count(world.tile.ItemData)+1].type=type or "block"
  world.tile.actions[table.count(world.tile.actions)+1]=loadstring(action)
  return id
end

function api.inner.executeAll()
  local modlist=api.loader.modList()
  for i=1,table.count(modlist) do
    mods.data[i]=require(api.inner.mod_directory.."."..modlist[i]:gsub("%.lua",""))
  end
  api.inner.areModsLoaded=true
end

function api.inner.loop()
  if api.inner.areModsLoaded and table.count(mods.data)>0 then
    for i=1,table.count(mods) do
      if(mods.data[i].loop~=nil)then
        mods.data[i].loop()
      end
      if(mods.data[i].init~=nil and api.inner.areModsInit==nil)then
        mods.data[i].init()
        api.inner.areModsInit=true
      end
    end
  end
end

function api.inner.init()
  love.filesystem.createDirectory(api.inner.mod_directory)
  api.inner.executeAll()
end
