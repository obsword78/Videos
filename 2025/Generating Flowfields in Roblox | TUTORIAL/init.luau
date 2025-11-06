local Flowfield_module = require(script.Parent.Flowfield)
local Grid = require(script.Parent.Grid).GRID

local Flowfield = Flowfield_module.new()
Flowfield:Generate(Grid[40])
-- destination will be Grid Cell Index 40

local function ApplyArrow(cellIndex, neighbourTableIndex)
	print(neighbourTableIndex)
	local dir = (neighbourTableIndex == 1 and "up") or (neighbourTableIndex == 2 and "down") or (neighbourTableIndex == 3 and "left") or "right"
	local newArrow = game.ServerStorage[dir]:Clone()

	newArrow.Parent = workspace[cellIndex]
end
