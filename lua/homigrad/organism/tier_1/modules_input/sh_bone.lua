hook.Add("Bones", "BoneDislocationBreak", function(ply, dtime) -- kind of ugly, but it works :/
	if !IsValid(ply) or !ply.organism then return end
	local org = ply.organism
	
	local dislocations = {
		["r_forearm"] = {org.rarm, "rarm"},
		["r_hand"] = {org.rarmdislocation, "rarm"},
		["l_forearm"] = {org.larm, "larm"},
		["l_hand"] = {org.larmdislocation, "larm"},
		["r_calf"] = {org.rleg, "rleg"},
		["r_foot"] = {org.rlegdislocation, "rleg"},
		["l_calf"] = {org.lleg, "lleg"},
		["l_foot"] = {org.llegdislocation, "lleg"},
	}

	for i, v in pairs(dislocations) do
		local boneRot = hg.IsLocal(ply) and ply[v[2].."boneRot"] or ply:GetNWAngle(v[2].."boneRot", nil)

		boneRot = Angle(boneRot or angle_zero)
		boneRot:Mul(type(v[1]) == "number" and v[1] or (v[1] and 1 or 0))

		hg.bone.Set(ply, i, vector_origin, boneRot, "dislocation", 0.0001, dtime)
	end
end)