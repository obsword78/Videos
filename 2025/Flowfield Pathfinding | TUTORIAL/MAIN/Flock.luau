local Behaviour = require(script.Behaviour)
local Flowfield = require(script.Flowfield)
local Grid = require(script.Flowfield.Grid).GRID
local RunService = game:GetService("RunService")

local Flock = {}

function Flock.new(boids: {Model})
	local self = setmetatable({}, Flock)
	
	self.Boids = boids
	self.Flowfield = Flowfield.new()
	
	self.Flowfield:Generate(Grid[1600]) -- an index in the grid to be the destination
	
	self.PreviousForces = {}
	
	local t = 0
	RunService.PostSimulation:Connect(function(dT)
		t += dT
		if t < 0.06 then return end
		t = 0
		
		Behaviour:SetForces(self.Boids, self.Flowfield, self.PreviousForces)
	end)
	
	return self
end

return Flock
