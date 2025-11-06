local Behaviour = require(script.Behaviour)

for _, Boid in ipairs(workspace.Flock:GetChildren()) do
	Behaviour:Assign(Boid, workspace.Flock)
end
