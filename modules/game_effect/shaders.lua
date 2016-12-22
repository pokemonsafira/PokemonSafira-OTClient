MAP_SHADERS = {
  { name = 'Default', frag = '/shaders/default.frag' },
  { name = 'Bloom', frag = '/shaders/bloom.frag'}, -- Alto Contraste
  { name = 'Sepia', frag ='/shaders/sepia.frag' }, -- marrom e branco
  { name = 'Grayscale', frag ='/shaders/grayscale.frag' }, -- preto e branco
  { name = 'Pulse', frag = '/shaders/pulse.frag' }, -- nada ver
  { name = 'Old Tv', frag = '/shaders/oldtv.frag' }, -- Porygon Quest
  { name = 'Fog', frag = '/shaders/fog.frag', tex1 = '/shaders/clouds.png' }, -- nuvem
  { name = 'Party', frag = '/shaders/party.frag' }, --festa
  { name = 'Radial Blur', frag ='/shaders/radialblur.frag' }, -- pesadelo
  { name = 'Zomg', frag ='/shaders/zomg.frag' }, --labirinto
  { name = 'Heat', frag ='/shaders/heat.frag' }, --agua
  { name = 'Noise', frag ='/shaders/noise.frag' }, -- fire
  { name = 'Rain', frag ='/shaders/rain.frag', tex1 = '/data/shaders/rain.png'  },
  { name = 'Fog1', frag = '/shaders/fog1.frag', tex1 = '/data/shaders/clouds1.png' },
  { name = 'Fog2', frag = '/shaders/fog2.frag', tex1 = '/data/shaders/clouds2.png' },
}

local lastShader
local areas = {
{from = {x = 1, y = 1, z = 7}, to = {x = 1, y = 1, z = 7}, name = 'Default'},
}

function isInRange(position, fromPosition, toPosition)
    return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.z >= fromPosition.z and position.x <= toPosition.x and position.y <= toPosition.y and position.z <= toPosition.z)
end

function init()
   if not g_graphics.canUseShaders() then return end
   for _i,opts in pairs(MAP_SHADERS) do
     local shader = g_shaders.createFragmentShader(opts.name, opts.frag)

     if opts.tex1 then
       shader:addMultiTexture(opts.tex1)
     end
     if opts.tex2 then
       shader:addMultiTexture(opts.tex2)
     end
   end

   connect(LocalPlayer, {
     onPositionChange = updatePosition
   })
  
   local map = modules.game_interface.getMapPanel()
   map:setMapShader(g_shaders.getShader('Default'))
end

function terminate()

end

function updatePosition()
  local player = g_game.getLocalPlayer()
  if not player then return end
  local pos = player:getPosition()
  if not pos then return end
  
  local name = 'Default'  
  
  for _, TABLE in ipairs(areas) do
      if isInRange(pos, TABLE.from, TABLE.to) then
         name = TABLE.name
      end
  end
  if lastShader and lastShader == name then return true end
  
  lastShader = name
  local map = modules.game_interface.getMapPanel()
  map:setMapShader(g_shaders.getShader(name))
end       