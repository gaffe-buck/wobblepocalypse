FOWL_HAPPY = 0
FOWL_ANGRY = 4
FOWL_LAZER = 8
FOWL_ASCEND_DURATION = 2
FOWL_ASCEND_Y = 5
FOWL_START_Y = 64 - 8
FOWL_START_X = 64 - 16
FOWL_BOB_AMP = 4
FOWL_BOB_SPEED = 0.01
FOWL_LAZER_OUTLINE_SPEED = 0.025
FOWL_LAZER_OUTLINE_FRAMES = {
    { x = -1, y = 0 },
    { x = 0, y = -1 },
    { x = 1, y = 0 },
    { x = 0, y = 1 }
}
FOWL_HORIZ_SPEED = 0.5
FOWL_LAZER_END_Y = 124

function make_fowl()
    local fowl = {}
    fowl.x = FOWL_START_X
    fowl.y = FOWL_START_Y
    fowl.y_offset = 0
    fowl.update = _update_fowl
    fowl.draw = _draw_fowl
    fowl.frame = FOWL_HAPPY
    fowl.readied_at = 0
    fowl.bob_timer = 0
    fowl.lazer_started = false
    fowl.lazer_started_at = 0
    fowl.lazer_outline_frame = nil
    fowl.lazer_end_y = FOWL_LAZER_END_Y

    return fowl
end


function _update_fowl(fowl)
    if game_state.ready and fowl.readied_at == 0 then
        fowl.readied_at = t()
    end
    
    if game_state.ready then
        fowl.frame = FOWL_ANGRY
        
        if t() <= fowl.readied_at + FOWL_ASCEND_DURATION then
            local start_time = fowl.readied_at
            local end_time = fowl.readied_at + FOWL_ASCEND_DURATION
            local progress = 1 + ((end_time -t()) / (start_time - end_time)) 
            progress = progress > 1 and 1 or progress
            
            fowl.y = FOWL_START_Y + (progress * (FOWL_ASCEND_Y - FOWL_START_Y))
        else
            if btn(❎) then 
                if not fowl.lazer_started then
                    fowl.lazer_started = true
                    fowl.lazer_started_at = t()
                end
                
                local lazer_outline_frame = ((t() - fowl.lazer_started_at)\FOWL_LAZER_OUTLINE_SPEED + 1)
                if lazer_outline_frame > 4 then fowl.lazer_started_at = t() end
                lazer_outline_frame = lazer_outline_frame > 4 and 1 or lazer_outline_frame
                fowl.lazer_outline_frame = lazer_outline_frame
                fowl.frame = FOWL_LAZER

                for building in all(city.buildings) do
                    local lazer_l = fowl.x + 11
                    local lazer_r = fowl.x + 20
                    if lazer_l > building.x and lazer_r < building.x + 32 then
                        fowl.lazer_end_y = FOWL_LAZER_END_Y - 18
                        building:damage()
                        break
                    else
                        fowl.lazer_end_y = FOWL_LAZER_END_Y
                    end
                end
            else
                fowl.lazer_started = false
                fowl.lazer_outline_frame = nil
                fowl.frame = FOWL_ANGRY
                fowl.bob_timer += FOWL_BOB_SPEED
                fowl.y_offset = sin(fowl.bob_timer) * FOWL_BOB_AMP

                if btn(➡️) then
                    fowl.x += FOWL_HORIZ_SPEED
                elseif btn(⬅️) then
                    fowl.x -= FOWL_HORIZ_SPEED
                end
                fowl.x = fowl.x > 128-32 and 128-32 or fowl.x
                fowl.x = fowl.x < 0 and 0 or fowl.x
            end
        end
    end
end

function _draw_fowl(fowl)
    local y = fowl.y + fowl.y_offset

    if fowl.lazer_outline_frame then
        pal_all(8)
        local offset_x = FOWL_LAZER_OUTLINE_FRAMES[fowl.lazer_outline_frame].x
        local offset_y = FOWL_LAZER_OUTLINE_FRAMES[fowl.lazer_outline_frame].y
        spr(fowl.frame, fowl.x + offset_x, y + offset_y, 4, 4)
        pal()
    end
    spr(fowl.frame, fowl.x, y, 4, 4)

    if fowl.lazer_started then
        srand(t())
        local l_eye_x = fowl.x + 11
        local r_eye_x = l_eye_x + 7
        local eye_y = y + 7
        printh("draw: "..fowl.lazer_end_y)
        rectfill(l_eye_x, eye_y, l_eye_x + 2, fowl.lazer_end_y, 8)
        rectfill(r_eye_x, eye_y, r_eye_x + 2, fowl.lazer_end_y, 8)

        circfill(l_eye_x + 5 + rnd({1, -1, 3, -3, 4., -4}), fowl.lazer_end_y + rnd({1, -1, 3, -3, 4., -4}), rnd({3, 4, 5, 6}), 8)
        circfill(l_eye_x + 5 + rnd({1, -1, 3, -3, 4., -4}), fowl.lazer_end_y + rnd({1, -1, 3, -3, 4., -4}), rnd({3, 4, 5, 6}), 8)
        circfill(l_eye_x + 5 + rnd({1, -1, 3, -3, 4., -4}), fowl.lazer_end_y + rnd({1, -1, 3, -3, 4., -4}), rnd({3, 4, 5, 6}), 8)
    end
end