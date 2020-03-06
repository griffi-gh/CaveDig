lang = {}
api.lang = {}

local function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function api.lang.addItem(codename, text)
  lang[table.count(lang)+1] = {codename=codename,text=text}
  return lang[table.count(lang)]
end

function api.lang.get(codename)
  for k,v in ipairs(lang) do
    if lang[k].codename == codename then
      return lang[k].text
    end
  end
  return codename
end

function api.lang.load(file)
  for line in love.filesystem.lines(file) do
    local splite = split(line,"=")
    local codename = splite[1]
    local text = splite[2]
    lang[table.count(lang)+1] = {codename=codename,text=text}

  end

end
