local RunService = game:GetService("RunService")

local module = {}

local separationAffectRange = 12
local minSpeed = 0.2

function module:SetForces(flock : {Model}, flowfield, previousForces)
	local averagePos = Vector3.zero
	for _, boid in flock do
		averagePos += boid.PrimaryPart.Position
	end
	averagePos /= #flock
	
	for _, Boid in flock do
		local hum = Boid.Humanoid
		local separationForce = Vector3.zero
		local cohesionForce
		local goalForce = Vector3.zero

		for _, otherboid in flock do
			if otherboid == Boid then continue end
			averagePos += otherboid.PrimaryPart.Position

			local distance = (Boid.PrimaryPart.Position-otherboid.PrimaryPart.Position).Magnitude
			local inverse = math.clamp(separationAffectRange-distance, 0, separationAffectRange)

			separationForce += (Boid.PrimaryPart.Position-otherboid.PrimaryPart.Position).Unit*inverse
		end
		
		local flowvector = flowfield:WorldToFV(Boid.PrimaryPart.Position)
		
		if not flowvector then
			hum:Move(Vector3.zero)
			continue
		end

		cohesionForce = (averagePos-Boid.PrimaryPart.Position).Unit*2
		goalForce = flowvector*50
		--=================================================
		local finalForce = goalForce+cohesionForce+separationForce
		finalForce -= Vector3.yAxis * finalForce
		finalForce = finalForce.Unit * math.min(finalForce.Magnitude, 1)
		finalForce = (previousForces[Boid] or Vector3.zero):Lerp(finalForce, 0.1)
		previousForces[Boid] = finalForce

		hum.AutoRotate = finalForce.Magnitude > minSpeed
		--=================================================

		hum:Move(finalForce.Magnitude > minSpeed and finalForce or Vector3.zero)
	end
end

return module
