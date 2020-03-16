-- -- Functions
-- function HUDPaint()
--     local width = surface.ScreenWidth();
--     local height = surface.ScreenHeight();
--     local centerX = width / 2;
--     local centerY = height / 2;
--     local player = LocalPlayer();

--     surface.DrawCircle(centerX, centerY, 100 + math.max(1, (20 * (math.sin(lfo * 8) * 4))), 0, 0, 0, 255)
-- end

-- function EntityTakeDamage(ent, dmg)
--     MsgN(dmg)
-- end

-- -- Hooks
-- hook.Add("HUDPaint", "InflexHUDPaint", HUDPaint)
-- hook.Add("EntityTakeDamage", "InflexDamage", EntityTakeDamage)