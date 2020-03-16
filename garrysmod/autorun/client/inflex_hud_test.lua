-- 
lfo       = 0;
lfo2      = 0;
lfoHeight = 0;

-- Functions
function HUDPaint()
    local width = surface.ScreenWidth();
    local height = surface.ScreenHeight();
    local centerX = width / 2;
    local centerY = height / 2;

    if (lfo < 45) then
        lfo = lfo + 0.001;
    else 
        lfo = -45 
    end

    if (lfo2 < 180) then
        lfo2 = lfo2 + 0.0015;
    else
        lfo2 = -180
    end

    MsgN(CurTime());

    -- math.max(10, (20 * (math.sin(lfo * 4) * 1)))
    -- math.max(10, ...) - Limits bottom. Use min for limiting top. See FL Studio Peak.
    -- (20 * ...) - Circles maximum radius
    -- math.sin(...) produces 0-1 values based of input
    -- lfo * n - LFO: Angle from -360 to 360 | n: Speed < 1 slow > 1 fast
    -- * 1 - Increase \ Decrease Radius

    surface.DrawCircle(centerX, centerY, math.max(1, (20 * (math.sin(lfo * 8) * 4))), 0, 0, 0, 255)
    -- surface.DrawCircle(centerX, centerY, 100 * math.sin( UnPredictedCurTime() ), 0, 0, 0, 255)
end

-- Hooks
-- hook.Add("HUDPaint", "InflexHUDPaint", HUDPaint)
