--for i=1,world.h*world.w do
  --  local tmpx1,tmpy1=t2d1d(i,world.w)
  --  if(tmpy1>16)then
  --    world.chunk.data[i]=love.math.random(table.count(world.tile.textures))
  --  end
  --end

chgen={f={}}

chgen.dirt=1
chgen.grass=2
chgen.stone=3
chgen.sand=4
chgen.wood=5
chgen.leaves=6
chgen.sandstone=7
chgen.cacti=8

local GeneratedBiome = 1

function chgen.f.curve(q,r,s,minmaxuse,min,max)
  r=r or 1
  local curve={}
  local prevy=s or 0
  for i=1,q do
    curve[i]=love.math.random(prevy-r,prevy+r)
    if(minmaxuse)then curve[i]=math.max(math.min(curve[i],max),min) end
    prevy=curve[i]
  end
  return curve
end

function chgen.f.gen(mode)--mode 0-cave 1-overworld 2-forest 3-sky
  local t=table.fill(world.w*world.h)
  local terrh=16
  local terrlen=16
  local terrlen_rand=2
  
  if(mode==1)then
    local curv=chgen.f.curve(world.w,1)
    local GenerateTreeInRad = 0
	local GenRad = {}
	GenRad[1] = 0
	
	
    for i=1,table.count(curv) do
	if GeneratedBiome == 1 then
      local tmpy_wg=curv[i]+terrh
	  if(love.math.random(1,30) < 15) then
      t[t1d2d(i,tmpy_wg,world.w)]=chgen.grass
	  else
	  t[t1d2d(i,tmpy_wg,world.w)]=chgen.grass
	  if GenerateTreeInRad < 1 then
	  GenerateTreeInRad = GenerateTreeInRad + 5
	  
	  t[t1d2d(i,tmpy_wg-1,world.w)]=chgen.wood
	  t[t1d2d(i,tmpy_wg-2,world.w)]=chgen.wood
	  t[t1d2d(i,tmpy_wg-3,world.w)]=chgen.wood
	  t[t1d2d(i,tmpy_wg-4,world.w)]=chgen.wood
	  t[t1d2d(i-1,tmpy_wg-5,world.w)]=chgen.leaves
	  t[t1d2d(i,tmpy_wg-5,world.w)]=chgen.leaves
	  t[t1d2d(i+1,tmpy_wg-5,world.w)]=chgen.leaves
	  t[t1d2d(i,tmpy_wg-6,world.w)]=chgen.leaves
	  end
	  if GenerateTreeInRad > 0 then
	  GenerateTreeInRad = GenerateTreeInRad - 1
	  end
	  
	  if math.random(1,500) > 490 then
		GeneratedBiome = 2
	  end
	  
	  
	  
	  
	  
	  end
	  
	  
      for k=terrh+terrlen-(terrlen_rand+1),world.h do
        t[t1d2d(i,k,world.w)]=chgen.stone
      end
      for k=tmpy_wg+1,terrh+terrlen+love.math.random(0,terrlen_rand) do
        t[t1d2d(i,k,world.w)]=chgen.dirt
      end
	  elseif GeneratedBiome == 2 then
	  
	  if math.random(1,500) > 490 then
		GeneratedBiome = 1
	  end
	  
		local tmpy_wg=curv[i]+terrh
		t[t1d2d(i,tmpy_wg,world.w)]=chgen.sand
		t[t1d2d(i,tmpy_wg,world.w)]=chgen.sand
		if math.random(1,30) > 20 and GenRad[1] < 1 then
			GenRad[1] = 2
			t[t1d2d(i,tmpy_wg-1,world.w)]=chgen.cacti
			t[t1d2d(i,tmpy_wg-2,world.w)]=chgen.cacti
			t[t1d2d(i,tmpy_wg-3,world.w)]=chgen.cacti
		else
			GenRad[1] = GenRad[1] - 1
		end
		
		
	  for k=terrh+terrlen-(terrlen_rand+1),world.h do
		if k < math.random(40,35) then
        t[t1d2d(i,k,world.w)]=chgen.sandstone
		else
		t[t1d2d(i,k,world.w)]=chgen.stone
		end
      end
      for k=tmpy_wg+1,terrh+terrlen+love.math.random(0,terrlen_rand) do
        t[t1d2d(i,k,world.w)]=chgen.sand
		
      end
		
	  end
    end
	
  end

  return t
end
