local Flowfield = {}
Flowfield.__index = Flowfield

local Grid = require(script.Grid)
local Queue = require(script.Queue)

local function getNeighbourIndexes(cell)
	local neighbourIndexes = {}

	neighbourIndexes[1] = cell.up and cell.up.index
	neighbourIndexes[2] = cell.down and cell.down.index
	neighbourIndexes[3] = cell.left and cell.left.index
	neighbourIndexes[4] = cell.right and cell.right.index

	return neighbourIndexes
end
--======================================================
function Flowfield.new()
	local self = setmetatable({}, Flowfield)
	
	self.Costs = {}
	self.FlowVectors = {}
	
	return self
end

function Flowfield:Generate(destinationCell)
	table.clear(self.Costs)
	table.clear(self.FlowVectors)
	
	self.Costs[destinationCell.index] = 0
	
	local Queue = Queue.new({destinationCell})
	
	repeat
		local rootCell = Queue:dequeue()
		local nCellCost = self.Costs[rootCell.index]+1
		
		if rootCell.up and not self.Costs[rootCell.up.index] then
			self.Costs[rootCell.up.index] = nCellCost
			Queue:enqueue(rootCell.up)
			workspace[rootCell.up.index].BrickColor = BrickColor.Yellow()
		end
		if rootCell.down and not self.Costs[rootCell.down.index] then
			self.Costs[rootCell.down.index] = nCellCost
			Queue:enqueue(rootCell.down)
			workspace[rootCell.down.index].BrickColor = BrickColor.Yellow()
		end
		if rootCell.left and not self.Costs[rootCell.left.index] then
			self.Costs[rootCell.left.index] = nCellCost
			Queue:enqueue(rootCell.left)
			workspace[rootCell.left.index].BrickColor = BrickColor.Yellow()
		end
		if rootCell.right and not self.Costs[rootCell.right.index] then
			self.Costs[rootCell.right.index] = nCellCost
			Queue:enqueue(rootCell.right)
			workspace[rootCell.right.index].BrickColor = BrickColor.Yellow()
		end
		
		workspace[rootCell.index].BrickColor = BrickColor.Green()
		task.wait()
	until Queue:getSize() == 0
	
	for index, cost in self.Costs do
		local cell = Grid.GRID[index]
		
		for i, neighbourIndex in getNeighbourIndexes(cell) do
			if cost - self.Costs[neighbourIndex] ~= 1 then continue end
		end
	end
end

return Flowfield
