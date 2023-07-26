CITY_APPEAR_DURATION = 2
BACKDROP_END_Y = 64
BACKDROP_START_Y = 128 + 32
BACKDROP_COLOR = 1
BLACKTOP_HEIGHT = 9
BUILDING_START_Y = 128 + 32
BUILDING_END_Y = 128 - 36
BUILDING_DAMAGE_RATE = 0.01
BUILDING_OFFSET_COOLDOWN = 0.025
BUILDING_HEALTHY = 12
BUILDING_DAMAGED_1 = 64
BUILDING_DAMAGED_2 = 68
BUILDING_DESTROYED = 72

function make_city()
    local city = {}
    city.update = _update_city
    city.draw = _draw_city
    city.draw_backdrop = _draw_backdrop
    city.backdrop_y = BACKDROP_START_Y
    city.readied_at = 0
    city.buildings = {
        make_building(16),
        make_building(127 - 32 - 16)
    }

    return city
end

function _update_city()
    if game_state.ready and city.readied_at == 0 then
        city.readied_at = t()
    end

    if game_state.ready then
        local start_time = city.readied_at
        local end_time = city.readied_at + CITY_APPEAR_DURATION
        local progress = 1 + ((end_time -t()) / (start_time - end_time)) 
        progress = progress > 1 and 1 or progress

        city.backdrop_y = BACKDROP_START_Y + (progress * (BACKDROP_END_Y - BACKDROP_START_Y))
    end

    for building in all(city.buildings) do
        building:update(city)
    end
end

function _draw_city(city)
    city:draw_backdrop()
end

function _draw_backdrop(city)
    srand(70)
    local num_steps = 8 -- rnd({5, 6, 7})
    local steps = {}
    for step = 1, num_steps do
        add(steps, flr(rnd(17)) * rnd({1, -1}))
    end
    
    local width = ceil(128/num_steps) 
    for index, step in pairs(steps) do
        local start_x = (index -1) * width
        local end_x = start_x + width
        rectfill(start_x, 128, end_x, city.backdrop_y + step, BACKDROP_COLOR)
    end
    fillp(░)
    local difference = 128 - city.backdrop_y 
    local foo = difference <= 0 and 0 or difference
    local blacktop_y = difference / 8
    rectfill(0, 128, 127, 128 - blacktop_y, 0)
    fillp()

    for building in all(city.buildings) do
        building:draw()
    end
end

function make_building(x)
    local building = {}
    building.update = _building_update
    building.draw = _building_draw
    building.damage = _building_damage
    building.x = x
    building.y = BUILDING_START_Y
    building.frame = BUILDING_HEALTHY
    building.health = 1
    building.offset_y = 0
    building.offset_x = 0
    building.offset_after = 0
    
    return building
end

function _building_update(building, city)
    if game_state.ready then
        local start_time = city.readied_at
        local end_time = city.readied_at + CITY_APPEAR_DURATION
        local progress = 1 + ((end_time -t()) / (start_time - end_time)) 
        progress = progress > 1 and 1 or progress

        building.y = BUILDING_START_Y + (progress * (BUILDING_END_Y - BUILDING_START_Y))
    end
end

function _building_draw(building)
    spr(building.frame, building.x + building.offset_x, building.y + building.offset_y, 4, 4)
end

function _building_damage(building)
    srand(t())
    building.health -= BUILDING_DAMAGE_RATE
    building.health = building.health < 0 and 0 or building.health
    if building.health == 0 then
        building.frame = BUILDING_DESTROYED
    elseif building.health <= 0.33 then
        building.frame = BUILDING_DAMAGED_2
    elseif building.health < 0.66 then
        building.frame = BUILDING_DAMAGED_1
    end

    if t() > building.offset_after then
        building.offset_after = t() + BUILDING_OFFSET_COOLDOWN
        building.offset_x = rnd({1, 0, -1})
        building.offset_y = rnd({1, 0, -1})
    end
end