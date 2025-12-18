local Flowfield_module = require(script.Parent.Flowfield)
local Grid = require(script.Parent.Grid).GRID

local Flowfield = Flowfield_module.new()
Flowfield:Generate(Grid[40])
-- destination will be Grid Cell Index 40
