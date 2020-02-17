--crafting system
crafting={f={},c=0,gui={curBlocks={0,0,0,0,0,0,0,0,0},enable=false}}
api.crafting={}
crafting.items={}
local c=table.count
local l=love.graphics.setColor
local g=love.graphics

function crafting.f.shapeless(t,s)
  if s then
    e={}
    for i=1,table.count(t) do
      e[i]=t[i]
    end
    table.sort(e)
    return e
  else return t end
end

function api.crafting.addCraftTable(recipe,resultitem,q,shapeless)
  crafting.c=crafting.c+1
	crafting.items[crafting.c] = {recipe={0,0,0,0,0,0,0,0,0},output={id=0,q=0}}
  crafting.items[crafting.c].recipe = recipe
  crafting.items[crafting.c].shapeless = shapeless or false
  crafting.items[crafting.c].output.id = resultitem
  crafting.items[crafting.c].output.q = q or 1
  return crafting.c
end

api.crafting.addCraftTable({2,0,0,0,0,0,0,0,0},1,1,true)
api.crafting.addCraftTable({5,0,0,0,0,0,0,0,0},9,4,true)
api.crafting.addCraftTable({9,9,0,0,0,0,0,0,0},10,4,true)
api.crafting.addCraftTable({9,9,0,9,10,0,0,10,0},11,1,false)

function api.crafting.getResult(recipe)--(table) <<<--------------- BROKEN!!!
    local ts=table.toString
    local sl=crafting.f.shapeless
    for i=1,crafting.c do
      local issl=crafting.items[i].shapeless
      if(ts(sl(crafting.items[i].recipe,issl))==ts(sl(recipe,issl)))then
        return crafting.items[i].output
      end
    end
    return {id=0,q=0}
end

function api.crafting.getSlot(slotname) --(string)
  local x,y=0,0
  if slotname:find("center") then x,y=2,2 end
  if slotname:find("left") then x=1 end
  if slotname:find("right") then x=3 end
  if slotname:find("top")then y=1 end
  if slotname:find("bottom") then y=3 end
  return x+(y*3)
end

function api.crafting.openGui() crafting.gui.enable=true end
function api.crafting.closeGui() crafting.gui.enable=false end

--TODO REWRITE THIS (This function is for mod api only!!!)
function api.crafting.craft(recipe,doNotCraft,freeCraft,k,q) --(table,bool,bool,table or int,int)
  doNotCraft=not doNotCraft
  for i=1,9 do
    local plHasIt=false
  	for j=1,inv.slots do
   	 	if(player.inventory[j].id==recipe[i].id)then
          plHasIt=true
      end
		end
    if not(plHasIt) then
        return nil
    end
  end
  if doNotCraft then
    if not freeCraft then
  		for i=1,9 do
  			inv.removeItem(recipe[i],1)
  		end
    end
    --k,q=item.toIntAuto(k,q)
  	inv.addItem(k,q)
  end
  return true
end

function crafting.f.gui()
    local wx,wy,ww,wh = 0,35,(world.tile.w*5)+1,world.tile.w*3.25

    local function getBoxXY(i,enwh)
      local ta1,tb1=t2d1d(i-1,3)
      local ta,tb=wx+ta1*35,wy+tb1*35
      if not enwh then
      	return ta,tb
      else
      	return ta,tb,world.tile.w,world.tile.h
      end
    end

    if(crafting.gui.enable)then
      camera:fade(0.8, {0, 0, 0, 0.85})
      --BACKGROUND----------------------------------------------------
      l(1,1,1,0.5)
      g.rectangle('fill',wx,wy,ww,wh)
      --CRAFTING BOX--------------------------------------------------
      for i=1,9 do
        local tmpbx,tmpby=t2d1d(i-1,3)
        l(0.7,0.7,0.7,1)
        g.rectangle('fill',wx+tmpbx*35,wy+tmpby*35,world.tile.w,world.tile.h)
        if (crafting.gui.curBlocks[i] or 0)>0 then
          l(1,1,1,1)
        	g.draw(world.tile.textures[crafting.gui.curBlocks[i]],wx+tmpbx*35,wy+tmpby*35)
        end
      end
      --RESULT BOX----------------------------------------------------
      l(0.7,0.7,0.7,1)
      local tmx_rb=3.5
      g.rectangle('fill',wx+tmx_rb*35,wy+35,world.tile.w,world.tile.h)
      local result = api.crafting.getResult(crafting.gui.curBlocks)
      if type(result)=='table' then
          if(result.id>0)then
            l(1,1,1,1)
        	  g.draw(world.tile.textures[result.id],wx+tmx_rb*35,wy+35)
          end
          if(result.q>0)then
            g.print("x"..result.q,wx+tmx_rb*35,wy+35)
          end
      end
      l(1,1,1) --reset colors
      --ADD BLOCKS-----------------------------------------------------
      for i=1,9 do
        local b,n,m,k=getBoxXY(i,true)
        m,k=m+b,k+n
        --love.graphics.line(b,n,m,k)
      	if(isInRect(mx,my,b,n,m,k))then
          if(crafting.gui.curBlocks[i]==0 and m1)then
         	 	crafting.gui.curBlocks[i]=player.inventory[inv.selected].id
          	inv.removeItem(nil,1,inv.selected)
          elseif(crafting.gui.curBlocks[i]>0 and m2)then
            inv.addItem(crafting.gui.curBlocks[i],1)
            crafting.gui.curBlocks[i]=0
          end
        end
      end
      if(m1 and isInRect(mx,my,wx+tmx_rb*35,wy+35,world.tile.w+wx+tmx_rb*35,world.tile.h+wy+35))then
        inv.addItem(result.id,result.q)
        for i=1,9 do
          crafting.gui.curBlocks[i]=0
        end
      end
      ---------------------------------------------------------------
    else
      camera:fade(0.5, {0, 0, 0, 0})
    end
end
