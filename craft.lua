--crafting system
crafting={f={},gui={curBlocks={1,0,0,0,0,0,0,0,0},enable=1 or false}}
api.crafting={}
crafting.items={}
local c=table.count
local l=love.graphics.setColor
local g=love.graphics

item={}
function item.toIntAuto(k,q) --TODO : !!!MOVE TO ITEM.LUA!!!!
  if(type(k)=='table')then
    k=k.id
    if not q then
      q=k.q
    end
    return k,q
  end
end

function api.crafting.addCraftTable(recipe,resultitem,q) --(table,table or int, int)
  resultitem,q=item.toIntAuto(resultitem,q)
  local item_tmp=c(crafting.items)+1
	crafting.items[item_tmp] = {recipe={0,0,0,0,0,0,0,0,0},output={id=0,q=0}}
  crafting.items[item_tmp].recipe = recipe
  crafting.items[item_tmp].output={}
  crafting.items[item_tmp].output.id = resultitem
  crafting.items[item_tmp].output.q = q or 1
  return item_tmp
end


api.crafting.addCraftTable({1,0,0,0,0,0,0,0,0},2,1)

function api.crafting.getResult(recipe)--(table) <<<--------------- BROKEN!!!
    for i = 1, c(crafting.items) do
        if(crafting.items[i].recipe==recipe)then
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

function crafting.f.craft(recipe,doNotCraft,freeCraft,k,q) --(table,bool,bool,table or int,int)
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
    k,q=item.toIntAuto(k,q)
  	inv.addItem(k,q)
  end
  return true
end

function crafting.f.gui(forceOn)
    local wx,wy,ww,wh = w/2.5,h/2.5,world.tile.w*6,world.tile.w*4
    local function getBoxXY(i,enwh)
      local ta1,tb1=t2d1d(i,3)
      local ta,tb=wx+ta1*35,wy+tb1*35
      if not enwh then
      	return ta,tb
      else
      	return ta,tb,world.tile.w,world.tile.h
      end
    end

    if(crafting.gui.enable or forceOn)then

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
        	g.draw(world.tile.textures[i],wx+tmpbx*35,wy+tmpby*35)
        end
      end
      --RESULT BOX----------------------------------------------------
      l(0.7,0.7,0.7,1)
      g.rectangle('fill',wx+4*35,wy+35,world.tile.w,world.tile.h)
      local result = api.crafting.getResult(crafting.gui.curBlocks)
      if result.id>0 then
          l(1,1,1,1)
      	  g.draw(world.tile.textures[result.id],wx+4*35,wy+35)
      end
      l(1,1,1) --reset colors
      --ADD BLOCKS-----------------------------------------------------
      for i=1,9 do
      	if(isInRect(mx,my,getBoxXY(i,true)))then
          if(crafting.gui.curBlocks[i]==0 and m1)then
         	 	crafting.gui.curBlocks[i]=player.inventory[inv.selected].id
          	inv.removeItem(nil,1,inv.selected)
          elseif(crafting.gui.curBlocks[i]>0 and m2)then
            inv.addItem(crafting.gui.curBlocks[i],1)
            crafting.gui.curBlocks[i]=0
          end
        end
      end
      ---------------------------------------------------------------
    end
end
