local CELL_SIZE = 4
local ROWS = 50
local COLUMNS = 50

local origin_offset = Vector3.new(CELL_SIZE/2, 0, CELL_SIZE/2)

local Grid = {}

Grid.GRID = {}

for y = 0, ROWS - 1 do
	for x = 0, COLUMNS - 1 do
		local index = (y*COLUMNS) + (x+1)
		Grid.GRID[index] = {index = index}
		
		local visualiseCell = Instance.new("Part")
		
		visualiseCell.Name = index
		visualiseCell.Size = Vector3.one*CELL_SIZE
		visualiseCell.Position = origin_offset + Vector3.new(CELL_SIZE*x, 0, CELL_SIZE*y)
		visualiseCell.Anchored = true
		visualiseCell.CanTouch = false
		visualiseCell.CanCollide = false
		visualiseCell.CastShadow = false
		
		visualiseCell.Parent = workspace
	end
end

for index, cell in Grid.GRID do
	cell.up = Grid.GRID[index-COLUMNS]
	cell.down = Grid.GRID[index+COLUMNS]

	if (index-1) % COLUMNS ~= 0 then
		cell.left = Grid.GRID[index-1]
	end
	if (index+1) % COLUMNS ~= 1 then
		cell.right = Grid.GRID[index+1]
	end
end

function Grid:AddWalls(indexes:{number})
	for _, index in indexes do
		local wallCell = Grid.GRID[index]

		workspace[index].BrickColor = BrickColor.Black()

		if wallCell.up then
			wallCell.up.down = nil
		end	
		if wallCell.down then
			wallCell.down.up = nil
		end	
		if wallCell.left then
			wallCell.left.right = nil
		end	
		if wallCell.right then
			wallCell.right.left = nil
		end	

		Grid.GRID[index] = nil
	end
end

return Grid
