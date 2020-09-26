------------------------------
--Vortex Cooldowns
--Summersisles-Blaumeux (classic)
--Classic Wow Profession Cooldowns
--https://www.curseforge.com/wow/addons/vortex-cooldowns

--order
--Chat warning options 300-350
--Special Warning options 350-400
--Global Tracking options 400-500
--color options 500-600
local addonName, VC = ...
local vortexColors = VC.vortexColors
local L = LibStub("AceLocale-3.0"):GetLocale(addonName);

VC.myOptionsTable = {
  name="",
  handler=VC,
  type = "group",
  childGroups ="tab",
  args = {
    titleText = {
			type = "description",
      image ="Interface\\Addons\\"..addonName.."\\person-touching-black-two-bell-alarm-clock-1198264.tga",
      imageWidth = 64,
      imageHeight = 64,
			name = "|cFFFF5100Vortex Cooldowns (v" .. GetAddOnMetadata(addonName, "Version") .. ")",
			fontSize = "large",
			order = 1,
		},
    vortexoptions={
      name = L["Vortex Options"],
      type = "group",
      order = 2,
      args={
        chatWarnHeader={
          type="header",
          name=L["Chat Warning"],
          order=300,
        },
        chatWarnDescription = {
          type="description",
          name=L["Display a warning in the default chat frame when something isn't on cooldown"],
          order=301,
        },
        chatWarnMoonclothToggle={
          type="toggle",
          name=L["Mooncloth"],
          order=301,
          get="getChatWarnMooncloth",
          set="setChatWarnMooncloth",
        },
        chatWarnSaltShakerToggle={
          type="toggle",
          name=L["Salt Shaker"],
          order=301,
          get="getChatWarnSaltShaker",
          set="setChatWarnSaltShaker",
        },
        chatWarnTransmuteToggle={
          type="toggle",
          name=L["Transmute"],
          order=301,
          get="getChatWarnTransmute",
          set="setChatWarnTransmute",
        },
        chatWarnMorrowgrainToggle={
          type="toggle",
          name=L["Morrowgrain"],
          order=302,
          get="getChatWarnMorrowgrain",
          set="setChatWarnMorrowgrain",
        },
        specialWarnHeader={
          type="header",
          name=L["Special Warning"],
          order=350,
        },
        specialWarnDescription = {
          type="description",
          name=L["Display a warning on the screen when something isn't on cooldown"],
          order=351,
        },
        specialWarnMoonclothToggle={
          type="toggle",
          name=L["Mooncloth"],
          order=351,
          get="getSpecialWarnMooncloth",
          set="setSpecialWarnMooncloth",
        },
        specialWarnSaltShakerToggle={
          type="toggle",
          name=L["Salt Shaker"],
          order=351,
          get="getSpecialWarnSaltShaker",
          set="setSpecialWarnSaltShaker",
        },
        specialWarnTransmuteToggle={
          type="toggle",
          name=L["Transmute"],
          order=351,
          get="getSpecialWarnTransmute",
          set="setSpecialWarnTransmute",
        },
        specialWarnMorrowgrainToggle={
          type="toggle",
          name=L["Morrowgrain"],
          order=352,
          get="getSpecialWarnMorrowgrain",
          set="setSpecialWarnMorrowgrain",
        },
        masterOverrideTrackerHeader={
          type="header",
          name=L["Master Override Tracker"],
          order=400,
        },
        masterOverrideTrackerDesc = {
          type="description",
          name=L["Unchecking these will not track any of these cooldowns for your account. See the Profession Data page to untrack individual characters."],
          order=401,
        },
        masterOverrideMoonclothToggle={
          type="toggle",
          name=L["Mooncloth"],
          order=405,
          get="getMasterOverrideMooncloth",
          set="setMasterOverrideMooncloth",
          confirm=true,
        },
        masterOverrideTransmuteToggle={
          type="toggle",
          name=L["Transmute"],
          order=405,
          get="getMasterOverrideTransmute",
          set="setMasterOverrideTransmute",
          confirm=true,
        },
        masterOverrideSaltShakerToggle={
          type="toggle",
          name=L["Salt Shaker"],
          order=405,
          get="getMasterOverrideSaltShaker",
          set="setMasterOverrideSaltShaker",
          confirm=true,
        },
        masterOverrideMorrowgrainToggle={
          type="toggle",
          name=L["Morrowgrain"],
          order=406,
          get="getMasterOverrideMorrowgrain",
          set="setMasterOverrideMorrowgrain",
        },

        colorHeader = {
          type="header",
          name=L["Color Options"],
          order=500,
        },
        moonclothColor = {
          type="color",
          desc=L["What is the Mooncloth color?"],
          name=L["Mooncloth Color"],
          get = "getMoonclothColor",
          set = "setMoonclothColor",
          hasAlpha = false,
          order = 505,
        },
        transmuteColor = {
          type="color",
          desc=L["What is the Transmute color?"],
          name=L["Transmute Color"],
          get= "getTransmuteColor",
          set= "setTransmuteColor",
          order = 505,
        },
        saltshakerColor = {
          type="color",
          desc=L["What is the Salt Shaker color?"],
          name=L["Salt Shaker Color"],
          get= "getSaltShakerColor",
          set= "setSaltShakerColor",
          order = 505,
        },
        colorResetExec = {
          type = "execute",
          desc = L["Reset the colors to their default"],
          name = L["reset"],
          func = "resetColors",
          width="half",
          order= 510,
        },
        dateOrTimeFormat = {
          name=L["Display the date or remaining days, hours, and minutes. When showing cooldowns."],
          type="select",
          style = "radio",
          get = "getdateOrTimeFormat",
          set = "setdateOrTimeFormat",
          order = 250,
          values = {
            ["datetime"] = L["Month Day"],
            ["dayshoursminutes"] = L["Days, Hours, Minutes"],
          },
        },
        dateFormat = {
          name=L["Date Format"],
          type="select",
          desc=L["Date Forms"],
          disabled ="disableDateFormat",
          order = 260,
          values = {
            ["%x"] = L["Computer Locale"],
            ["%m/%d/%Y"] = "mm/dd/yyyy",
            ["%m-%d-%Y"] = "mm-dd-yyyy",
            ["%d/%m/%Y"] = "dd/mm/yyyy",
            ["%d-%m-%Y"] = "dd-mm-yyyy",
            ["%m/%d/%y"] = "mm/dd/yy",
            ["%m-%d-%y"] = "mm-dd-yy",
            ["%d/%m/%y"] = "dd/mm/yy",
            ["%d-%m-%y"] = "dd-mm-yy",
          },
          get = "getDateFormat",
    			set = "setDateFormat",
        },
        timeFormat = {
          name=L["Time Format"],
          type="select",
          desc=L["Time Forms"],
          disabled = "disableDateFormat",
          order = 260,
          values = {
            ["%X"] = L["Computer Locale"],
            ["%I:%M %p"] = "hh:mm AM/PM",
            ["%H:%M"] = "HH:mm",
          },
          get = "getTimeFormat",
          set = "setTimeFormat",
        },
      }

    },
    professiondata={
      name = L["Profession Data"],
      type = "group",
      args={
        resetCharBtn= {
          name=L["Reset Character Data"],
          type="execute",
          confirm=true,
          func = "resetCharData",
        },
        resetAllBtn= {
          name=L["Reset All Data"],
          type="execute",
          confirm=true,
          func = "resetAllData",
        },
      }
    },
    sharingoptions={
      name = L["Sharing"],
      type = "group",
      args={
        masterOverrideTrackerDesc = {
          type="description",
          name=L["Coming at some point in the near future. You can check twitter for updates. https://twitter.com/vortexcooldowns"],
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


function VC:getSpecialWarnMooncloth(info)
  return self.db.global.VCOptions.specialWarnMooncloth;
end
function VC:setSpecialWarnMooncloth(info,value)
  self.db.global.VCOptions.specialWarnMooncloth = value;
end

function VC:getSpecialWarnSaltShaker(info)
  return self.db.global.VCOptions.specialWarnSaltShaker;
end
function VC:setSpecialWarnSaltShaker(info,value)
  self.db.global.VCOptions.specialWarnSaltShaker = value;
end

function VC:getSpecialWarnTransmute(info)
  return self.db.global.VCOptions.specialWarnTransmute;
end
function VC:setSpecialWarnTransmute(info,value)
  self.db.global.VCOptions.specialWarnTransmute = value;
end

function VC:getSpecialWarnMorrowgrain(info)
  return self.db.global.VCOptions.specialWarnMorrowgrain;
end
function VC:setSpecialWarnMorrowgrain(info,value)
  self.db.global.VCOptions.specialWarnMorrowgrain = value;
end

function VC:getChatWarnMooncloth(info)
  return self.db.global.VCOptions.chatMooncloth;
end
function VC:setChatWarnMooncloth(info,value)
  self.db.global.VCOptions.chatMooncloth = value;
end

function VC:getChatWarnSaltShaker(info)
  return self.db.global.VCOptions.chatSlatShaker;
end
function VC:setChatWarnSaltShaker(info,value)
  self.db.global.VCOptions.chatSlatShaker = value;
end

function VC:getChatWarnTransmute(info)
  return self.db.global.VCOptions.chatTransmute;
end
function VC:setChatWarnTransmute(info,value)
  self.db.global.VCOptions.chatTransmute = value;
end

function VC:getChatWarnMorrowgrain(info)
  return self.db.global.VCOptions.chatMorrowgrain;
end
function VC:setChatWarnMorrowgrain(info,value)
  self.db.global.VCOptions.chatMorrowgrain = value;
end
function VC:getDateFormat(info)
  return self.db.global.VCOptions.dateFormat;
end
function VC:setDateFormat(info,value)
  self.db.global.VCOptions.dateFormat = value;
end
function VC:getTimeFormat(info)
  return self.db.global.VCOptions.timeFormat;
end
function VC:setTimeFormat(info,value)
  self.db.global.VCOptions.timeFormat = value;
end

function VC:getdateOrTimeFormat(info)
  return self.db.global.VCOptions.dateOrTimeFormat;
end
function VC:setdateOrTimeFormat(info, value)
  self.db.global.VCOptions.dateOrTimeFormat = value;
end

function VC:disableDateFormat(info)
  if(VC:getdateOrTimeFormat() == "datetime") then
    return false;
  end
  return true;
end

function VC:resetAllData(info)
  self.db.global.VCCharacterInfo = {};
  VC:resetCharData(info);
  table.insert(self.db.global.VCCharacterInfo,VCPlayerInfo);
end

function VC:resetCharData(info)
  VC.VCPlayerInfo['LW'] = false;
  VC.VCPlayerInfo['Tailor'] = false;
  VC.VCPlayerInfo['Alch'] = false;
  VC.VCPlayerInfo['SaltCD'] = -1;
  VC.VCPlayerInfo['MoonCD'] = -1;
  VC.VCPlayerInfo['TransCD'] = -1;
  VC:VCSaveDB();
end
