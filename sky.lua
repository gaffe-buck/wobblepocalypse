SKY_COLORS = { 12, 14, 13, 2 }
SKY_COLOR_CHANGE_DURATION = 2

function make_sky()
    local sky = {}
    sky.color = SKY_COLORS[1]
    sky.update = _update_sky
    sky.draw = _draw_sky
    sky.readied_at = 0
    
    return sky
end

function _update_sky(sky)
    if game_state.ready and sky.readied_at == 0 then
        sky.readied_at = t()
    end

    if game_state.ready then
        if t() > sky.readied_at + SKY_COLOR_CHANGE_DURATION * 0.75 then
            sky.color = SKY_COLORS[4]
        elseif t() > sky.readied_at + SKY_COLOR_CHANGE_DURATION * 0.5 then
            sky.color = SKY_COLORS[3]
        elseif t() > sky.readied_at + SKY_COLOR_CHANGE_DURATION * 0.25 then
            sky.color = SKY_COLORS[2]
        else
            sky.color = SKY_COLORS[1]
        end
    end
end

function _draw_sky(sky)
    cls(sky.color)
end