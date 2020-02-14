inv={selected=1}
player.inventory={{id=0,q=0},{id=0,q=0},{id=0,q=0},{id=0,q=0},{id=0,q=0}}
inv.slots=table.count(player.inventory)

function inv.findSlot(itemid)
  for i=1,inv.slots do --If item is in inventory return its slot
    if(player.inventory[i].id==itemid)then
      return i
    end
  end
  for i=1,inv.slots do --If not return empty slot
    if(player.inventory[i].id==0)then
      return i
    end
  end
  return nil --Inventory is full
end

function inv.addItem(id,q,slot)
  slot=slot or inv.findSlot(id)
  q=q or 1
  if slot then
    player.inventory[slot].id=id
    player.inventory[slot].q=player.inventory[slot].q+q
  end
  return slot
end

function inv.removeItem(id,q,slot)
  slot=slot or inv.findSlot(id)
  q=q or player.inventory[slot].q
  id=id or player.inventory[slot].id
  player.inventory[slot].q=player.inventory[slot].q-q
  if player.inventory[slot].q<1 then
    player.inventory[slot]={id=0,q=0}
  end
  return slot
end

function inv.draw()
  local c=love.graphics.setColor
  c(1,1,1,0.5)
  love.graphics.rectangle("fill",0,0,world.tile.w*inv.slots+1,world.tile.h+1)
  c(1,1,1)
  for i=1,inv.slots do
    local tmpx=(i-1)*world.tile.w
    if isInRect(mx,my,tmpx,0,tmpx+world.tile.w,world.tile.h) and m1 then
      inv.selected=i
    end
    if player.inventory[i].id>0 and player.inventory[i].q>0 then
      love.graphics.draw(world.tile.textures[player.inventory[i].id],tmpx,0)
      love.graphics.print("x"..player.inventory[i].q,tmpx,0)
    end
    if inv.selected==i then
      c(1,0.25,0.25)
      love.graphics.circle("fill",tmpx+6, 32-6, 5)
      c(1,1,1)
    end
  end
  c(1,1,1)
end
