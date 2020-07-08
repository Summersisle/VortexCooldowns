------------------------------
--Vortex Cooldowns
--Summersisles-Blaumeux (classic)
--Classic Wow Profession Cooldowns
--https://www.curseforge.com/wow/addons/vortex-cooldowns

--order
--Global Tracking options 400-500
--color options 500-600


VC.myOptionsTable = {
  name="",
  handler=VC,
  type = "group",
  childGroups ="tab",
  args = {
    titleText = {
			type = "description",
      image ="|TInterface\\Addons\\VortexCooldowns\\person-touching-black-two-bell-alarm-clock-1198264",
			name = "        |cFFFF5100Vortex Cooldowns (v" .. GetAddOnMetadata("VortexCooldowns", "Version") .. ")",
			fontSize = "large",
			order = 1,
		},
    vortexoptions={
      name = "Vortex Options",
      type = "group",
      order = 2,
      args={
        masterOverrideTrackerHeader={
          type="header",
          name="Master Override Tracker",
          order=400,
        },
        masterOverrideTrackerDesc = {
          type="description",
          name="Unchecking these will not track any of these cooldowns for your account. See the Profession Data page to untrack individual characters.",
          order=401,
        },
        masterOverrideMoonclothToggle={
          type="toggle",
          name="Mooncloth",
          order=405,
          get="getMasterOverrideMooncloth",
          set="setMasterOverrideMooncloth",
        },
        masterOverrideTransmuteToggle={
          type="toggle",
          name="Transmute",
          order=405,
          get="getMasterOverrideTransmute",
          set="setMasterOverrideTransmute",
        },
        masterOverrideSaltShakerToggle={
          type="toggle",
          name="Saltshaker",
          order=405,
          get="getMasterOverrideSaltShaker",
          set="setMasterOverrideSaltShaker",
        },
        masterOverrideMorrowgrainToggle={
          type="toggle",
          name="Morrowgrain",
          order=406,
          get="getMasterOverrideMorrowgrain",
          set="setMasterOverrideMorrowgrain",
        },

        colorHeader = {
          type="header",
          name="Color Options",
          order=500,
        },
        moonclothColor = {
          type="color",
          desc="What is the Mooncloth color?",
          name="Mooncloth Color",
          get = "getMoonclothColor",
          set = "setMoonclothColor",
          hasAlpha = false,
          order = 505,
        },
        transmuteColor = {
          type="color",
          desc="What is the Transmute color?",
          name="Transmute Color",
          get= "getTransmuteColor",
          set= "setTransmuteColor",
          order = 505,
        },
        saltshakerColor = {
          type="color",
          desc="What is the Salt Shaker color?",
          name="Salt Shaker Color",
          get= "getSaltShakerColor",
          set= "setSaltShakerColor",
          order = 505,
        },
        colorResetExec = {
          type = "execute",
          desc = "Reset the colors to their default",
          name = "reset",
          func = "resetColors",
          width="half",
          order= 510,
        }

      }

    },
    professiondata={
      name = "Profession Data",
      type = "group",
      args={
        -- more options go here
      }
    },
    sharingoptions={
      name = "Sharing",
      type = "group",
      args={
        masterOverrideTrackerDesc = {
          type="description",
          name="Coming at some point in the near future. You can check twitter for updates. https://twitter.com/vortexcooldowns",
          order=401,
        },
      }
    }
  }
};


-- VC.optionsDefault = {
--   moonclothColor = "ffF4F4F4",
--   saltshakerColor = "ffe28e1f",
--   transmuteColor = "ff3cddf2",
-- };
function VC:getMoonclothColor(info)
  --VC:Print("Mooncloth color"..self.db.global.VCOptions.moonclothColor)
  return VC:HexToRGB(self.db.global.VCOptions.moonclothColor);
end
function VC:setMoonclothColor(info,r,g,b)
  --VC:Print("Mooncloth color r:"..r.." g:"..g.." b:"..b)
  --VC:Print("Mooncloth color r:"..floor(r*255).." g:"..floor(g*255).." b:"..floor(b*255))
  self.db.global.VCOptions.moonclothColor = VC:RGBToHex(floor(r*255),floor(g*255),floor(b*255));
end

function VC:getTransmuteColor(info)
  --VC:Print("Transmute color"..vortexColors['Transmute'])
  return VC:HexToRGB(vortexColors['Transmute']);
end
function VC:setTransmuteColor(info,r,g,b)
  vortexColors['Transmute'] = VC:RGBToHex(floor(r*255),floor(g*255),floor(b*255));
end

function VC:getSaltShakerColor(info)
  --VC:Print("Salt Shaker color"..vortexColors['Salt Shaker'])
  return VC:HexToRGB(vortexColors['Salt Shaker']);
end
function VC:setSaltShakerColor(info,r,g,b)
  vortexColors['Salt Shaker'] = VC:RGBToHex(floor(r*255),floor(g*255),floor(b*255));
end

function VC:resetColors(info)
  self.db.global.VCOptions.moonclothColor = VC.defaults.global.VCOptions.moonclothColor;
  self.db.global.VCOptions.saltshakerColor= VC.defaults.global.VCOptions.saltshakerColor;
  self.db.global.VCOptions.transmuteColor= VC.defaults.global.VCOptions.transmuteColor;
end


function VC:getMasterOverrideMooncloth(info)
  return self.db.global.VCOptions.masterOverrideMooncloth;
end
function VC:setMasterOverrideMooncloth (info,value)
  self.db.global.VCOptions.masterOverrideMooncloth = value;
end

function VC:getMasterOverrideTransmute(info)
  return self.db.global.VCOptions.masterOverrideTransmute;
end
function VC:setMasterOverrideTransmute (info,value)
  self.db.global.VCOptions.masterOverrideTransmute = value;
end

function VC:getMasterOverrideSaltShaker(info)
  return self.db.global.VCOptions.masterOverrideSaltShaker;
end
function VC:setMasterOverrideSaltShaker (info,value)
  self.db.global.VCOptions.masterOverrideSaltShaker = value;
end

function VC:getMasterOverrideMorrowgrain(info)
  return self.db.global.VCOptions.masterOverrideMorrowgrain;
end
function VC:setMasterOverrideMorrowgrain (info,value)
  self.db.global.VCOptions.masterOverrideMorrowgrain = value;
end
