local RunService = game:GetService("RunService")

local module = {}

local separationAffectRange = 12

function module:Assign(Boid:Model, folder)
	local hum = Boid.Humanoid
	local last_finalforce = Vector3.zero
	
	RunService.PostSimulation:Connect(function(dT)
		local separationForce = Vector3.zero
		local cohesionForce
		local goalForce = Vector3.zero
		local averagePos = Vector3.zero

		for _, otherboid in ipairs(folder:GetChildren()) do
			if otherboid == Boid then continue end
			averagePos += otherboid.PrimaryPart.Position

			local distance = (Boid.PrimaryPart.Position-otherboid.PrimaryPart.Position).Magnitude
			local inverse = math.clamp(separationAffectRange-distance, 0, separationAffectRange)

			separationForce += (Boid.PrimaryPart.Position-otherboid.PrimaryPart.Position).Unit*inverse
		end
		averagePos /= #folder:GetChildren()

		cohesionForce = (averagePos-Boid.PrimaryPart.Position).Unit*3
		goalForce = (folder:GetAttribute("TargetPos")-Boid.PrimaryPart.Position).Unit*10
		--=================================================
		local finalForce = separationForce+cohesionForce+goalForce
		finalForce -= Vector3.yAxis * finalForce
		finalForce = finalForce.Unit * math.min(finalForce.Magnitude, 1)
		finalForce = last_finalforce:Lerp(finalForce, 0.1)
		last_finalforce = finalForce
				
		hum.AutoRotate = finalForce.Magnitude > 0.05 
		--=================================================
		
		hum:Move(finalForce.Magnitude > 0.05 and finalForce or Vector3.zero)
	end)
end

return module
