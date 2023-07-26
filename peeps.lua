PEEP_GEN_COOLDOWNS = {0.5, 0.75, 1, 2}
PEEP_FRAMES = {76, 77}
PEEP_COLORS = {4, 6, 7, 10, 15}
PEEP_SPEEDS = { 1, 2, 3, -1, -2, -3 }
PEEP_READY_AFTER = 2
PEEP_MAX_Y = 120
GUY_FRAME_CHANGE_COOLDOWN = 0.25
GUY_BOUNCE_AMP = 2

function make_peeps()
    local peeps = {}
    peeps.guys = {}
    peeps.update = _peeps_update
    peeps.draw = _peeps_draw
    peeps.new_guy_after = 0
    peeps.readied_at = 0

    return peeps
end

function _peeps_update(peeps)
    if game_state.ready and peeps.readied_at == 0 then
        peeps.readied_at = t()
    end
    if game_state.ready and t() > peeps.readied_at + PEEP_READY_AFTER then
        if t() > peeps.new_guy_after then
            add(peeps.guys, make_guy())
        end
    end

    local dead_guys = {}
    for guy in all(peeps.guys) do
        local dead_guy = guy:update()
        if dead_guy then
            add(dead_guys, guy)
        end
    end
    for dead_guy in all(dead_guys) do
        del(peeps.guys, dead_guy)
    end
end

function _peeps_draw(peeps)
    for guy in all(peeps.guys) do
        guy:draw()
    end
end

function make_guy()
    srand(t())
    local guy = {}
    guy.update = _guy_update
    guy.draw = _guy_draw
    guy.speed = rnd(PEEP_SPEEDS)
    guy.x = guy.speed > 0 and -8 or 128 + 8
    guy.y = PEEP_MAX_Y + rnd({0, 1, 2, 3, 4})
    guy.change_frame_after = 0
    guy.frame = rnd(PEEP_FRAMES)
    guy.flip_x = rnd({true, false})
    guy.bounce_offset = rnd(60)
    guy.color = rnd(PEEP_COLORS)

    return guy
end

function _guy_update(guy)
    srand(t())
    guy.x += guy.speed
    if t() > guy.change_frame_after then
        guy.change_frame_after = t() + GUY_FRAME_CHANGE_COOLDOWN
        guy.frame = rnd(PEEP_FRAMES)
        guy.flip_x = rnd(true, false)
    end

    local dead = false
    if guy.speed > 0 and guy.x > 128 + 8 then dead = true end
    if guy.speed < 0 and guy.x < -8 then dead = true end
    
    return dead
end

function _guy_draw(guy)
    local y_offset = sin(t() + guy.bounce_offset) * GUY_BOUNCE_AMP
    pal({[7] = guy.color})
    spr(guy.frame, guy.x, guy.y + y_offset, 1, 1, guy.flip_x)
    pal()
end