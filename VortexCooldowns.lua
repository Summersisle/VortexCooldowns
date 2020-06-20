------------------------------
--Vortex Cooldowns
--Summersisles-Blaumeux (classic)
--
--

VC = LibStub("AceAddon-3.0"):NewAddon("VortexCooldowns", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");

--Variable to keep track of the current logged in char
VCPlayerInfo = {}
VCPlayerInfo['Realm'] = nil
VCPlayerInfo['Name'] = nil
VCPlayerInfo['Class'] = nil
VCPlayerInfo['LW'] = false
VCPlayerInfo['Tailor'] = false
VCPlayerInfo['Alch'] = false
VCPlayerInfo['SaltCD'] = -1
VCPlayerInfo['MoonCD'] = -1
VCPlayerInfo['TransCD'] = -1

vortexColors = {};
_, _, _, vortexColors['WARLOCK'] = GetClassColor("WARLOCK");
_, _, _, vortexColors['WARRIOR'] = GetClassColor("WARRIOR");
_, _, _, vortexColors['PRIEST'] = GetClassColor("PRIEST");
_, _, _, vortexColors['MAGE'] = GetClassColor("MAGE");
_, _, _, vortexColors['PALADIN'] = GetClassColor("PALADIN");
_, _, _, vortexColors['HUNTER'] = GetClassColor("HUNTER");
_, _, _, vortexColors['ROGUE'] = GetClassColor("ROGUE");
_, _, _, vortexColors['SHAMAN'] = GetClassColor("SHAMAN");
_, _, _, vortexColors['DRUID'] = GetClassColor("DRUID");
vortexColors['Mooncloth'] = "fff4f4f4";
vortexColors['Salt Shaker'] = "ffe28e1f";
vortexColors['Transmute'] = "ff3cddf2";

local defaults = {
  global = {
    optionA = true,
    optionB = false,
    subOptions = {
      subOptionsA = false,
      subOptionsB = true,
    },
    VCCharacterInfo = {},
  }
}

MoonClothTimer = nil;
SaltShakerTimer = nil;
TransmuteTimer = nil;

function VC:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("VCdatabase", defaults)
  VC:RegisterChatCommand("cooldowns", "CooldownsSlashProcessorFunc")
  --VC:RegisterChatCommand("VCSave", "VCSaveProcFunc")
  VC:RegisterChatCommand("VCTest", "VCTestProcFunc");
  VC:RegisterEvent("TRADE_SKILL_UPDATE","TradeSkillShowProcessorFunc")

  VC:Print("Vortex Cooldowns Initialized")
end

function VC:OnEnable()
    -- Called when the addon is enabled
    local newCharacter = true;
    local FullName, Realm = UnitFullName("player");
    --VC:Print(UnitFullName("player"))
    for k, charInfo in pairs(self.db.global.VCCharacterInfo) do               --DB for all the characters saved

      --Check if any cooldowns have completed since last log on
      if(charInfo['SaltCD'] < GetServerTime() and charInfo['SaltCD'] ~= -1) then
        VC:Print(charInfo['Realm'].."-"..charInfo['Name'].." Salt Shaker is OFF cooldown");
        charInfo['SaltCD'] = -1;
      elseif (charInfo['MoonCD'] < GetServerTime() and charInfo['MoonCD'] ~= -1) then
        VC:Print(charInfo['Realm'].."-"..charInfo['Name'].." Mooncloth is OFF cooldown");
        charInfo['MoonCD'] = -1;
      elseif (charInfo['TransCD'] < GetServerTime() and charInfo['TransCD'] ~= -1) then
        VC:Print(charInfo['Realm'].."-"..charInfo['Name'].." Transmute is OFF cooldown");
        charInfo['TransCD'] = -1;
      end

      --Load the cooldowns for the currently logged in player
      if (charInfo['Realm'] == Realm and charInfo['Name'] == FullName) then
        VCPlayerInfo['Realm'] = charInfo['Realm']
        VCPlayerInfo['Name'] = charInfo['Name']
        VCPlayerInfo['Class'] = charInfo['Class']
        VCPlayerInfo['LW'] = charInfo['LW']
        VCPlayerInfo['Tailor'] = charInfo['Tailor']
        VCPlayerInfo['Alch'] = charInfo['Alch']
        VCPlayerInfo['SaltCD'] = charInfo['SaltCD']
        VCPlayerInfo['MoonCD'] = charInfo['MoonCD']
        VCPlayerInfo['TransCD'] = charInfo['TransCD']
        newCharacter = false
        break
      end
    end
    --VC:Print(newCharacter)
    if (newCharacter == true) then --Didn't find a saved character so this must be a new character
      VCPlayerInfo['Name'], VCPlayerInfo['Realm'] = UnitFullName("player");
      __, VCPlayerInfo['Class'],__ = UnitClass("player");
      VC:Print("Registered new character "..VCPlayerInfo['Realm'].."-"..VCPlayerInfo['Name']);
      --VC:Print(VCPlayerInfo);
      table.insert(self.db.global.VCCharacterInfo,VCPlayerInfo);
    end

    MoonClothTimer = self:ScheduleTimer("TimerCooldown", 5);
    SaltShakerTimer =  self:ScheduleTimer("TimerCooldown", 5);
    TransmuteTimer =  self:ScheduleTimer("TimerCooldown", 5);

    VC:Print("Vortex Cooldowns Enabled");
end

function VC:VCSaveDB()
  local FullName, Realm = UnitFullName("player");

  for k, charInfo in pairs(self.db.global.VCCharacterInfo) do               --DB for all the characters saved
    if (charInfo['Realm'] == Realm and charInfo['Name'] == FullName) then
      self.db.global.VCCharacterInfo[k]['LW'] = VCPlayerInfo['LW'];
      self.db.global.VCCharacterInfo[k]['Tailor'] = VCPlayerInfo['Tailor'];
      self.db.global.VCCharacterInfo[k]['Alch'] = VCPlayerInfo['Alch'];
      self.db.global.VCCharacterInfo[k]['SaltCD'] = VCPlayerInfo['SaltCD'];
      self.db.global.VCCharacterInfo[k]['MoonCD'] = VCPlayerInfo['MoonCD'];
      self.db.global.VCCharacterInfo[k]['TransCD'] = VCPlayerInfo['TransCD'];
      if(VCPlayerInfo['Class'] == nil) then
        __, VCPlayerInfo['Class'],__ = UnitClass("player");
        self.db.global.VCCharacterInfo[k]['Class'] = VCPlayerInfo['Class'];
      end
      break
    end
  end

end


function VC:OnDisable()
  VC:VCSaveDB()
    -- Called when the addon is disabled
end


function VC:CooldownsSlashProcessorFunc(input)
  -- Process the slash command ('input' contains whatever follows the slash command)

  VC:VCSaveDB() -- Save the current character into the DB

  VC:CheckExpiredCooldown(false);

  VC:Print("Current Tradeskills that have a cooldown!");
  --local fullname, realm = UnitFullName("player");
  for k, charInfo in pairs(self.db.global.VCCharacterInfo) do
    --if (realm ~= charInfo['Realm']) then
      if(charInfo['LW'] == true) then
        if(charInfo['SaltCD'] == -1) then
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],false,"Salt Shaker",nil);
        else
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],true,"Salt Shaker",charInfo['SaltCD']);
        end
      end
      if(charInfo['Alch'] == true) then
        if(charInfo['TransCD'] == -1) then
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],false,"Transmute",nil);
        else
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],true,"Transmute",charInfo['TransCD']);
        end

      end
      if(charInfo['Tailor'] == true) then
        if(charInfo['MoonCD'] == -1) then
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],false,"Mooncloth",nil);
        else
          VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],charInfo['Class'],true,"Mooncloth",charInfo['MoonCD']);
        end

      end
    -- else
    --   if(charInfo['LW'] == true) then
    --     if(charInfo['SaltCD'] == -1) then
    --       VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],false,"Salt Shaker",nil);
    --     else
    --       VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],true,"Salt Shaker",charInfo['SaltCD']);
    --     end
    --   end
    --   if(charInfo['Alch'] == true) then
    --     if(charInfo['TransCD'] == -1) then
    --       VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],false,"Transmute",nil);
    --     else
    --     VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],true,"Transmute",charInfo['TransCD']);
    --     end
    --   end
    --   if(charInfo['Tailor'] == true) then
    --     if(charInfo['MoonCD'] == -1) then
    --       VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],false,"Mooncloth",nil);
    --     else
    --       VC:PrintCooldownMessage(charInfo['Realm'],charInfo['Name'],true,"Mooncloth",charInfo['MoonCD']);
    --     end
    --   end
    -- end
  end
end

function VC:TradeSkillShowProcessorFunc(input)
  local name, type, updated;
  for i=1,GetNumTradeSkills() do
     name, type, _, _, _, _ = GetTradeSkillInfo(i);
     if (name and type ~= "header") then
      if (name == "Cured Rugged Hide") then
        if(VCPlayerInfo['LW'] == false) then --Congrats on learning Leatherworking and getting Cured Rugged Hide
          VCPlayerInfo['LW'] = true
          return;
        end
        if(VCPlayerInfo['SaltCD'] ~= -1) then
          return;
        end
        -- Salt Shaker Item ID 15846
        local count = GetItemCount(15846,true);
        if (count ~= 0) then
          local startTime,duration,isEnabled = GetItemCooldown(15846);
          if(duration == 0) then
            if( self:TimeLeft(SaltShakerTimer) == 0) then
              VCPlayerInfo['SaltCD'] = -1;
              VC:Print("Salt Shaker OFF cooldown!");
              SaltShakerTimer = self:ScheduleTimer("TimerCooldown", 5);
              return;
            end
          else
            VCPlayerInfo['SaltCD'] = GetServerTime() + duration;
            VC:Print("Registered new Salt Shaker cooldown.");
            VC:Print("Salt Shaker will be off cooldown at "..date("%x %X", VCPlayerInfo['SaltCD']));
            VC:VCSaveDB();
            return;
          end
        end
      elseif (name == "Mooncloth") then
        if(VCPlayerInfo['Tailor'] == false) then --Congrats on learning Tailoring and getting your Mooncloth transmute
          VCPlayerInfo['Tailor'] = true
          return;
        end
        if(VCPlayerInfo['MoonCD'] ~= -1) then -- If there is already a duration then we are done
          return;
        end

        local duration =  GetTradeSkillCooldown(i); --returns nil if not on cooldown
        --Check if off cooldown
        if(duration == nil) then
          if( self:TimeLeft(TransmuteTimer) == 0) then
            VCPlayerInfo['MoonCD'] = -1;
            VC:Print("Mooncloth is OFF cooldown!");
            TransmuteTimer = self:ScheduleTimer("TimerCooldown", 5);
            return;
          end
        else
          VCPlayerInfo['MoonCD'] = GetServerTime() + duration;
          VC:Print("Registered new Mooncloth cooldown.");
          VC:Print("Mooncloth will be off cooldown at "..date("%x %X", VCPlayerInfo['MoonCD']));
          VC:VCSaveDB();
          return;
        end


      elseif (string.find(name,"Transmute")) then
        if (VCPlayerInfo['Alch'] == false) then --Congrats on learning Alchemy and getting your first transmute
              VCPlayerInfo['Alch'] = true
              return;
        end
        if (VCPlayerInfo['TransCD'] ~= -1) then --If there is already a duration then we are done
          return;
        end
        local duration =  GetTradeSkillCooldown(i);
        --Check if off cooldown
        if(duration == nil) then
          if( self:TimeLeft(SaltShakerTimer) == 0) then
            VCPlayerInfo['TransCD'] = -1;
            VC:Print("Transmute is OFF cooldown!");
            SaltShakerTimer = self:ScheduleTimer("TimerCooldown", 5);
            return;
          end
        else
          VCPlayerInfo['TransCD'] = GetServerTime() + duration;
          VC:Print("Registered new Transmute cooldown.");
          VC:Print("Transmute will be off cooldown at "..date("%x %X", VCPlayerInfo['TransCD']));
          VC:VCSaveDB();
          return;
        end

      end
     end
  end
end


function VC:UpdateSaltShaker()

end

function VC:UpdateMooncloth()

end

function VC:UpdateTransmute()

end


        --local days = math.floor(duration / 86400);
        --local hours = math.floor((duration - (days * 86400))/3600);
        --local minutes = math.floor((duration - ((days * 86400) + (hours * 3600)))/60);
        --VC:Print("Duration:"..duration);
        --VC:Print("Days:"..days);
        --VC:Print("Hours:"..hours);
        --VC:Print("Minutes:"..minutes);


function VC:PrintCooldownMessage(realm, name, class, onCD, type, time)
  if(onCD == true) then
    if(realm == VCPlayerInfo['Realm']) then
      VC:Print("|c"..vortexColors[class]..name.."|r |c"..vortexColors[type]..type.."|r will be off cooldown at "..date("%x %X",time));
    else
      VC:Print("|cff3cf2be"..realm.."|r-|c"..vortexColors[class]..name.."|r |c"..vortexColors[type]..type.."|r will be off cooldown at "..date("%x %X",time));
    end
  else
    if(realm == VCPlayerInfo['Realm']) then
      VC:Print("|c"..vortexColors[class]..name.."|r |c"..vortexColors[type]..type.."|r is OFF cooldown");
    else
      VC:Print("|cff3cf2be"..realm.."|r-|c"..vortexColors[class]..name.."|r |c"..vortexColors[type]..type.."|r is OFF cooldown");
    end
  end
end

--Checks the DB for all cooldowns that are expired
function VC:CheckExpiredCooldown(print)
  local currTime = GetServerTime();
  for k, charInfo in pairs(self.db.global.VCCharacterInfo) do
    if(self.db.global.VCCharacterInfo[k]['LW'] == true) then
      if (currTime > self.db.global.VCCharacterInfo[k]['SaltCD']) then
        self.db.global.VCCharacterInfo[k]['SaltCD'] = -1;
        if(print) then
          VC:PrintCooldownMessage(charInfo['realm'], charInfo['name'], false, "Salt Shaker", nil);
        end
      end
    end
    if(self.db.global.VCCharacterInfo[k]['Tailor'] == true ) then
      if (currTime > self.db.global.VCCharacterInfo[k]['MoonCD']) then
        self.db.global.VCCharacterInfo[k]['MoonCD'] = -1;
        if(print) then
          VC:PrintCooldownMessage(charInfo['realm'], charInfo['name'], false, "Mooncloth", nil);
        end
      end
    end
    if(self.db.global.VCCharacterInfo[k]['Alch'] == true) then
      if (currTime > self.db.global.VCCharacterInfo[k]['TransCD']) then
        self.db.global.VCCharacterInfo[k]['TransCD'] = -1;
        if(print) then
          VC:PrintCooldownMessage(charInfo['realm'], charInfo['name'], false, "Transmute", nil);
        end
      end
    end
  end
end


function VC:TimerPrint()
  VC:Print("5 seconds passed");
end

function VC:TimerCooldown()
    --Do Nothing!
end

function VC:VCTest()
  VC:Print(self:TimeLeft(MoonClothTimer));
end


function VC:VCTestProcFunc()



  VC:Print("|c"..vortexColors['warlock'].."This text is warlock|r |c"..vortexColors['priest'].."This text is priest |c"..vortexColors['warrior'].."This text is warrior|r |c"..vortexColors['hunter'].."This text is hunter|r");
end
