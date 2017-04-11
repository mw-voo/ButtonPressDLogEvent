if SERVER then

   Damagelog:EventHook("TTTTraitorButtonActivated")
   Damagelog:EventHook("PlayerUse")
else
   Damagelog:AddFilter("Show TTT_Button Presses", DAMAGELOG_FILTER_BOOL, true)
   Damagelog:AddFilter("Show Regular_Button Presses", DAMAGELOG_FILTER_BOOL, false)
   Damagelog:AddColor("Button", Color(114,14,255))
end

local event = {}

event.Type = "MISC"
local sptime = CurTime()+5
function event:PlayerUse(ply, ent)
   if !IsValid(ply) then return end
   if ent:GetClass() == "func_button" then
      if sptime > CurTime() then return else sptime = CurTime()+4 end

      local ent_name = IsValid(ent) and ent:GetName()
      if #ent_name == 0 then ent_name = "<Unnamed Func_Button>" else ent_name = ent:GetName() end

      self.CallEvent({
         [1] = (IsValid(ply) and ply:Nick() or "<Disconnected Player>"),
         [2] = (ply:GetRole()),
         [3] = (IsValid(ent) and ent_name),
         [4] = (ply:SteamID()),
         [5] = 1
      })


   end 
end
function event:TTTTraitorButtonActivated(ent, ply)

   if !IsValid(ply) or !ply:IsActiveTraitor() then return end

   if ent:GetClass() == "ttt_traitor_button" then
      local ent_name = IsValid(ent) and ent:GetName()
      if #ent_name == 0 then ent_name = "<Unnamed TTT_Button>" else ent_name = ent:GetName() end

      self.CallEvent({
         [1] = (IsValid(ply) and ply:Nick() or "<Disconnected Player>"),
         [2] = (ply:GetRole()),
         [3] = (IsValid(ent) and ent_name),
         [4] = (ply:SteamID()),
         [5] = 2
      })
   

   end
   
end

function event:ToString(v)
   if v[5] == 1 then return string.format("%s [%s] has pressed the func_button [%s]", v[1], Damagelog:StrRole(v[2]), v[3]) 
   elseif v[5] == 2 then return string.format("%s [%s] has pressed the ttt_button [%s]", v[1], Damagelog:StrRole(v[2]), v[3]) end
   
end

function event:IsAllowed(tbl)
   if (tbl[5] == 1) and not Damagelog.filter_settings["Show Regular_Button Presses"] then return false end
   if (tbl[5] == 2) and not Damagelog.filter_settings["Show TTT_Button Presses"] then return false end
   return true
end

function event:Highlight(line, tbl, text)
   if table.HasValue(Damagelog.Highlighted, tbl[1]) then
      return true
   end
   return false
end

function event:GetColor(tbl)
   return Damagelog:GetColor("Button")
end

function event:RightClick(line, tbl, text)
   line:ShowTooLong(true)
   line:ShowCopy(true, { tbl[1], tbl[4] })
end

Damagelog:AddEvent(event)