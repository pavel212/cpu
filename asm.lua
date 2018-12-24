local output = {}
local labels = {}

function mem(addr) return addr end
function label(name) if name then labels[name] = #output end end

local g = {}
setmetatable(_G, {
  __index = function(t, k, v) return g[k] end,
  __newindex = function(t, k, v) 
    if g[k] then table.insert(output, {g[k], v})
    else g[k]=v end 
  end
}) 

setmetatable(output, {
  __gc = function(o)
    for _,v in ipairs(o) do 
      if type(v[2]) == "string" then v[2] = labels[v[2]] or print("wrong label: ", v[2]) end
      print(string.format("%02X%02X", v[1] & 0xFF, v[2] & 0xFF)) 
    end 
  end
})