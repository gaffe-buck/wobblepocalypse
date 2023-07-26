function _init()
    title = make_title()
    sky = make_sky()
    fowl = make_fowl()
    city = make_city()
    peeps = make_peeps()
    game_state = {
        ready = false
    }
end

function _update60()
    if not game_state.ready and btn(❎) then game_state.ready = true end

    sky:update()
    title:update()
    fowl:update()
    city:update()
    peeps:update()
end

function _draw()
    sky:draw()
    city:draw()
    title:draw()
    fowl:draw()
    peeps:draw()
end