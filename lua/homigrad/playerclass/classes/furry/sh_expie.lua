local CLASS = player.RegClass("expie")

function CLASS.Off(self)
	if CLIENT then return end

	ApplyAppearance(self,false,false,false,true)

	-- if self.oldspeed then
	-- 	self:SetRunSpeed(self.oldspeed)
	-- 	self.oldspeed = nil
	-- end

	if SERVER then
		self.organism.bloodtype = self.oldbloodtype or "o-"
	end

	self.JumpPowerMul = nil
	self.SpeedGainClassMul = nil
	self:SetNWInt("SpeedGainClassMul", nil)
	self.MeleeDamageMul = nil
	self.StaminaExhaustMul = nil
end

local sw, sh = CLIENT and ScrW() or nil, CLIENT and ScrH() or nil

local function Randomize(self)
	-- for _, bg in ipairs(self:GetBodyGroups()) do
	-- 	if bg.id > 0 and bg.num > 0 then
	-- 		self:SetBodygroup(bg.id, math.random(0, bg.num - 1))
	-- 	end
	-- end
	-- self:SetSkin(math.random(0, 5))

	if SERVER then
		local Appearance = self.CurAppearance or hg.Appearance.GetRandomAppearance()
		Appearance.AAttachments = ""
		Appearance.AColthes = ""
		local plycolor = Color(Appearance.AColor.r, Appearance.AColor.g, Appearance.AColor.b)

		-- local plycolor = self:GetPlayerColor()
		if plycolor then
			local h, s, l = plycolor:ToHSL()
			plycolor = HSLToColor(h, s / 4, l * 2)
			Appearance.AColor = plycolor

			plycolor = plycolor:ToVector()
		end

		self:SetNetVar("Accessories", "")
		self.CurAppearance = Appearance

		self:SetPlayerColor(plycolor or VectorRand(0.95, 1))
	end
end

CLASS.NoGloves = true
local col1 = Color(255, 192, 109)

function CLASS.On(self, data)
	if SERVER then
		if self.organism then
			self.oldbloodtype = self.organism.bloodtype
			self.organism.bloodtype = "c-"
		end

		local Appearance = self.CurAppearance or hg.Appearance.GetRandomAppearance()

		local name = "Experiment #" .. math.random(1000, 9999)

		self:SetNWString("PlayerName", name)
		Appearance.AName = name
	end

	if data.instant then
		if SERVER then
			-- self.oldspeed = self:GetRunSpeed()
			-- self:SetRunSpeed(3000)
			self.JumpPowerMul = 1.5
			self.SpeedGainClassMul = 5
			self.StaminaExhaustMul = 0.75
			self:SetNWInt("SpeedGainClassMul", self.SpeedGainClassMul)
	
			self.armors = {}
			//self.armors["torso"] = "cmb_armor"
			self:SyncArmor()

			zb.GiveRole(self, "Experiment", col1)
		end

		self:SetModel("models/logic/akittu_experiment/expie_pm.mdl")

		self:SetSubMaterial()

		if self.SetNetVar then
			self:SetNetVar("Accessories", "")
		end

		Randomize(self)

		for i = 1, self:GetFlexNum() - 1 do
			self:SetFlexWeight(i, 0)
		end

		return
	end

	--hook.Run("HG_OnAssimilation", self)
	-- Randomize(self)

	if CLIENT then
		//local ent = hg.GetCurrentCharacter(self)

		if IsValid(self.mdlfur) then
			self.mdlfur:Remove()
		end

		self.mdlfur = ClientsideModel("models/logic/akittu_experiment/expie_pm.mdl")
		self.mdlfur.GetPlayerColor = function() return self:GetPlayerColor() end
		local mdl = self.mdlfur
		mdl:SetNoDraw(true)

		hg.converging[self] = CurTime()

		return
	else
		-- self.oldspeed = self:GetRunSpeed()
		-- self:SetRunSpeed(3000)
		self.JumpPowerMul = 1.5
		self.SpeedGainClassMul = 5
		self:SetNWInt("SpeedGainClassMul", self.SpeedGainClassMul)
		self.StaminaExhaustMul = 0.75

		self.armors = {}
		//self.armors["torso"] = "cmb_armor"
		self:SyncArmor()

		if zb and zb.GiveRole then zb.GiveRole(self, "Experiment", col1) end
	end

	-- self:SetNWString("PlayerName", rank .. " " .. Appearance.AName)

	hg.Fake(self, nil, true)
	timer.Create("expie"..self:EntIndex(), 1.6, 1, function()
		if IsValid(self) then
			hg.SavePoses(self)
			hg.FakeUp(self, true, true)

			self:SetModel("models/logic/akittu_experiment/expie_pm.mdl")

			self:SetSubMaterial()

			if self.SetNetVar then
				self:SetNetVar("Accessories", "")
			end

			Randomize(self)

			for i = 1, self:GetFlexNum() - 1 do
				self:SetFlexWeight(i, 0)
			end

			hg.Fake(self, nil, true)
			hg.ApplyPoses(self)

			hg.organism.Clear( self.organism )

			if self.organism then
				self.oldbloodtype = self.organism.bloodtype
				self.organism.bloodtype = "c-"
			end
		end
	end)
end

local bluewhite = Color(187, 187, 255)

-- local symbols = {
-- 	[1] = {
-- 		symbol = "▓▓",
-- 		value = 7
-- 	},
-- 	[2] = {
-- 		symbol = "▒▒",
-- 		value = 4
-- 	},
-- 	[3] = {
-- 		symbol = "░░",
-- 		value = 1
-- 	},
-- }

// old shit!!!!!!

-- local aimvectorsmooth = Angle()
-- local hpcolor = Color(229, 56, 26)
-- local shadow = Color(0, 0, 0, 150)
-- local healthlerp = 0
-- local shadowbar = Color(50, 50, 75, 50)

-- -- 	draw.GlowingText("INTEGRITY", "ZB_ProotLarge", w / 2, h * 0.8, ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 255), TEXT_ALIGN_CENTER)
-- -- 	draw.GlowingText("NOMINAL", "ZB_ProotLarge", w / 2, h * 0.85, ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 255), TEXT_ALIGN_CENTER)

-- 	local frametime = 1 - math.exp(-0.5 * FrameTime())
-- 	if frametime > 0.01 then
-- 		frametime = 0.01
-- 	end

-- 	draw.SimpleText(":", "ZB_ProotLarge", sw * 0.2, sh * 0.8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
-- 	draw.SimpleTextOutlined("ЦЕЛОСТНОСТЬ:", "ZB_ProotLarge", sw * 0.2, sh * 0.8, bluewhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ColorAlpha(shadow, 50))
-- 		draw.GlowingText("ЦЕЛОСТНОСТЬ:", "ZB_ProotLarge2", sw * 0.2, sh * 0.8, ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 200), ColorAlpha(bluewhite, 100), TEXT_ALIGN_CENTER)

-- 	local HealthBar = ""

-- 	local health = LocalPlayer():Health()
-- 	healthlerp = Lerp(FrameTime(), healthlerp, health)

-- 	for i = 0, 9 do
-- 		if math.Round(healthlerp) >= ((i + 1) * (LocalPlayer():GetMaxHealth() / 10)) then
-- 			HealthBar = HealthBar .. "██ "
-- 		else
-- 			local LastDigits = healthlerp - (i * (LocalPlayer():GetMaxHealth() / 10))

-- 			local symbol = "  "

-- 			for i2 = 1, 3 do
-- 				if LastDigits >= symbols[i2].value then
-- 					symbol = symbols[i2].symbol
-- 					break
-- 				end
-- 			end

-- 			HealthBar = HealthBar .. symbol
-- 		end
-- 	end

-- 	draw.SimpleText("██ ██ ██ ██ ██ ██ ██ ██ ██ ██", "ZB_ProotLarge", sw * 0.12, sh * 0.81, shadowbar)
-- 	draw.SimpleText(HealthBar, "ZB_ProotLarge", sw * 0.12 + 1, sh * 0.81 + 1, shadow)
-- 	-- draw.SimpleTextOutlined(HealthBar, "ZB_ProotLarge", sw * 0.12, sh * 0.81, hpcolor, nil, nil, 1, ColorAlpha(shadow, 50))

-- 	draw.GlowingText(HealthBar, "ZB_ProotLarge2", sw * 0.12, sh * 0.81, ColorAlpha(bluewhite, 255), ColorAlpha(bluewhite, 200), ColorAlpha(bluewhite, 100))

local xbars = 17
local ybars = 30

local gradient_l = Material("vgui/gradient-l")

function CLASS.Guilt(self, victim)
    if victim:GetPlayerClass() == self:GetPlayerClass() then
        return 1
    end
end

if CLIENT then
	local white = Material("sprites/physbeama")

	hg.converging = hg.converging or {}

	local validBones = {
		["ValveBiped.Bip01_Pelvis"] = true,
		["ValveBiped.Bip01_Spine1"] = true,
		["ValveBiped.Bip01_Spine2"] = true,
		["ValveBiped.Bip01_R_Clavicle"] = true,
		["ValveBiped.Bip01_L_Clavicle"] = true,
		["ValveBiped.Bip01_R_UpperArm"] = true,
		["ValveBiped.Bip01_L_UpperArm"] = true,
		["ValveBiped.Bip01_L_Forearm"] = true,
		["ValveBiped.Bip01_L_Hand"] = true,
		["ValveBiped.Bip01_R_Forearm"] = true,
		["ValveBiped.Bip01_R_Hand"] = true,
		["ValveBiped.Bip01_R_Thigh"] = true,
		["ValveBiped.Bip01_R_Calf"] = true,
		["ValveBiped.Bip01_Head1"] = true,
		["ValveBiped.Bip01_Neck1"] = true,
		["ValveBiped.Bip01_L_Thigh"] = true,
		["ValveBiped.Bip01_L_Calf"] = true,
		["ValveBiped.Bip01_L_Foot"] = true,
		["ValveBiped.Bip01_R_Foot"] = true
	}

	function DrawConversion(ent, ply)
		if !hg.converging[ply] then
			if IsValid(ply.mdlfur) then
				ply.mdlfur:Remove()
			end

			return
		end
		
		local time = hg.converging[ply]

		if !IsValid(ent) then
			hg.converging[ply] = nil

			return
		end
		
		local status = math.ease.OutSine(1 - math.Clamp((time - CurTime() + 3) / 3, 0, 1))
		
		if status == 1 then
			hg.converging[ply] = nil
			
			if IsValid(ply.mdlfur) then
				ply.mdlfur:Remove()
			end

			return
		end
		
		render.SetStencilEnable( true )

		render.ClearStencil()
		render.SetStencilTestMask( 255 )
		render.SetStencilWriteMask( 255 )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILOPERATION_KEEP )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )

		render.SetStencilReferenceValue( 1 )
		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )

		if IsValid(ent) then
			ent:DrawModel()
		end

		render.SetStencilReferenceValue( 2 )

		render.SetMaterial(white)
		local pos = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Head1")):GetTranslation()
		render.DrawSphere(pos, 48 * math.max(status - 0.3, 0), 32, 32, color_white)
		local pos = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Spine1")):GetTranslation()
		render.DrawSphere(pos, 48 * math.max(status - 0.4, 0), 32, 32, color_white)
		local pos = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_L_Foot")):GetTranslation()
		render.DrawSphere(pos, 48 * math.max(status - 0.7, 0), 32, 32, color_white)
		local pos = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_R_Foot")):GetTranslation()
		render.DrawSphere(pos, 48 * math.max(status - 0.2, 0), 32, 32, color_white)
		//render.DrawSphere(pos + VectorRand(-16, 16), 64 * status, 32, 32, color_white)

		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilReferenceValue( 2 )

		render.DepthRange( 0, 1 )

		if IsValid(ply.mdlfur) then
			local mdl = ply.mdlfur
			mdl:SetPos(ent:GetPos())
			mdl:SetupBones()
			ent:SetupBones()
			//PrintBones(mdl)
			/*for i = 0, mdl:GetBoneCount() - 1 do
				local bon = ent:LookupBone(mdl:GetBoneName(i))
				if !bon then continue end
				local m1 = mdl:GetBoneMatrix(i)
				local m2 = ent:GetBoneMatrix(bon)

				if !m1 or !m2 then continue end
				
				local q1 = Quaternion()
				q1:SetMatrix(m1)

				local q2 = Quaternion()
				q2:SetMatrix(m2)
				local q3 = q1:SLerp(q2, status)

				local newmat = Matrix()
				newmat:SetTranslation(LerpVector(status, m1:GetTranslation(), m2:GetTranslation()))
				newmat:SetAngles(q3:Angle())

				hg.bone_apply_matrix(ent, i, newmat)
				//hg.bone_apply_matrix(mdl, i, newmat)
			end*/
			for i = 0, mdl:GetBoneCount() - 1 do
				local nam = ent:GetBoneName(i)
				if !validBones[nam] then continue end
				local bon = mdl:LookupBone(nam)
				if !bon then continue end
				local m1 = ent:GetBoneMatrix(i)

				hg.bone_apply_matrix(mdl, bon, m1)
			end
			//ent:DrawModel()
			mdl:DrawModel()
		end

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NOTEQUAL )

		ent:DrawModel()

		render.DepthRange( 0, 1 )
		
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.ClearStencil()

		render.SetStencilEnable( false )
	end
end