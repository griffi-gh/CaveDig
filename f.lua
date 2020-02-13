function isInRect(mx,my,x1,y1,x2,y2)
  return (mx>x1 and mx<x2 and my>y1 and my<y2)
end

function nf(i)
  return i or 0
end


function table.has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


function table.count(t)
  local count=0
  for k,v in pairs(t) do
    count = count + 1
  end
  return count
end

function table.tablify(str)
  local t={}
  str:gsub(".",function(c) table.insert(t,c) end)
  return t
end

table.defaultSp="|"
table.defaultEc="^"

function table.toString(t,sp,ec)
  if(t)then
    sp=sp or table.defaultSp
    ec=ec or table.defaultEc
    local str=""
    local tc=table.count(t)
    for i=1,tc do
      local tmp=""
      tmp=tmp..tostring(t[i] or "")
      if not(i==tc) then
        tmp=tmp..sp
      end
      str=str..tmp
    end
    str=str..ec
    return str
  else
    error "expected table[,string,string]"
  end
end

function table.loadString(str,ctn,sp,ec)
  sp=sp or table.defaultSp
  ec=ec or table.defaultEc

  local t={}
  local st=table.tablify(str)
  local st_tc=table.count(st)

  local i=1
  local i2=1;
  local cur=""

  local infloop=st_tc+5

  while true do
    local chr=(st[i] or "")

    if(chr==sp or chr==ec) then
      if ctn then
        t[i2]=tonumber(cur)
      else
        t[i2]=cur
      end
      cur=""
      i2=i2+1;
      if(chr==ec) then
        return t
      end
    else
      cur=cur..chr
    end

    if(i>infloop)then
      error("bad string (infinite loop) (is '^' char missing?)")
    end

    i=i+1
  end

end

function table.fill(l,s)
    s=s or 0
    local t={}
    for i=1,l do
      t[i]=s
    end
    return t
end

file={
  exists=function(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
  end
}

function t1d2d(x,y,w)
  return x+(y*w)
end

function t2d1d(i,w)
  local y=math.floor(i/w)
  local x=i-(y*w)
  return x,y
end
