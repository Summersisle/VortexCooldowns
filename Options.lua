------------------------------
--Vortex Cooldowns
--Summersisles-Blaumeux (classic)
--Classic Wow Profession Cooldowns
--https://www.curseforge.com/wow/addons/vortex-cooldowns


VC.myOptionsTable = {
  name="",
  type = "group",
  args = {
    titleText = {
			type = "description",
			name = "        |cFFFF5100Vortex Cooldowns (v" .. GetAddOnMetadata("VortexCooldowns", "Version") .. ")",
			fontSize = "large",
			order = 1,
		},
    moreoptions={
      name = "More Options",
      type = "group",
      args={
        -- more options go here
      }
    }
  }
}
