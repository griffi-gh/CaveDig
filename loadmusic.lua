c=[[
 _         ____               _____    __  __   _    _    _____   _____    _____       _                 
| |       / __ \      /\     |  __ \  |  \/  | | |  | |  / ____| |_   _|  / ____|     | |              1.0
| |      | |  | |    /  \    | |  | | | \  / | | |  | | | (___     | |   | |          | |  _   _    __ _ 
| |      | |  | |   / /\ \   | |  | | | |\/| | | |  | |  \___ \    | |   | |          | | | | | |  / _` |
| |____  | |__| |  / ____ \  | |__| | | |  | | | |__| |  ____) |  _| |_  | |____   _  | | | |_| | | (_| |
|______|  \____/  /_/    \_\ |_____/  |_|  |_|  \____/  |_____/  |_____|  \_____| (_) |_|  \__,_|  \__,_|
                              SIMPLE Love2D 1-channel BGM for games
]];c=nil;

mus_prevfile=""
function loadmusic(file,re,loop,isStatic)
  if(music)then
    local playing = music:isPlaying()
  end
  if(file)then
    if(isStatic)then isStatic="static" else isStatic="stream" end
    loop=loop or true
    if(not(mus_prevfile==file))or(re)then
        if(music)then music:stop() end
        music=love.audio.newSource(file,isStatic)
        mus_prevfile=file
        music:setLooping(loop)
        music:play()
    end
  else
    music:stop()
  end
  return playing
end