if SERVER then
   hook.Add(eventName, uniqueName, func)
   Damagelog:EventHook("TTTTraitorButtonActivated")
else
   Damagelog:AddFilter("Show Button Presses", DAMAGELOG_FILTER_BOOL, true)
   Damagelog:AddColor("Button", Color(114,14,255))
end

local event = {}

event.Type = "MISC"

function event:TTTTraitorButtonActivated(ent, ply)

   if !IsValid(ply) or !ply:IsActiveTraitor() then return end

   if ent:GetClass() == "ttt_traitor_button" then

      self.CallEvent({
      [1] = (IsValid(ply) and ply:Nick() or "<Disconnected Player>"),
      [2] = (ply:GetRole()),
      [3] = ((IsValid(ent) and ent:GetName()) or "<UnknownEnt>"),
      [4] = (ply:SteamID())
      })
   

   end
   
end

function event:ToString(v)

   return string.format("%s [%s] has pressed the button %s", v[1], Damagelog:StrRole(v[2]), v[3])
end

function event:IsAllowed(tbl)
   return Damagelog.filter_settings["Show Button Presses"]
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