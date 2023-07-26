TITLE_START_Y = 4
TITLE_END_Y = -28
CREDIT_START_Y = 128-15
CREDIT_END_Y = 128+4
TITLE_DISAPPEAR_DURATION = 2

function make_title()
    local title = {}
    title.update = _update_title
    title.draw = _draw_title
    title.title_y = TITLE_START_Y
    title.credit_y = CREDIT_START_Y
    title.readied_at = 0

    return title
end

function _update_title(title)
    if game_state.ready and title.readied_at == 0 then
        title.readied_at = t()
    end

    -- munchie.y = munchie.start_y + (y_progress * (munchie.end_y - munchie.start_y))
    if game_state.ready then
        local start_time = title.readied_at
        local end_time = title.readied_at + TITLE_DISAPPEAR_DURATION
        local progress = 1 + ((end_time -t()) / (start_time - end_time)) 
        progress = progress > 1 and 1 or progress

        title.title_y = TITLE_START_Y + (progress * (TITLE_END_Y - TITLE_START_Y))
        title.credit_y = CREDIT_START_Y + (progress * (CREDIT_END_Y - CREDIT_START_Y))
    end
end

function _draw_title(title)
    -- title
    fancy_text({
        text = "\"wobblefowl\" in",
        text_colors = { 0 },
        background_color = 7,
        x = 32,
        y = title.title_y,
        bubble_depth = 1,
    })
    fancy_text({
        text = "wobblepocalypse",
        text_colors = { 5 },
        background_color = 7,
        bubble_depth = 2,
        x = 5,
        y = title.title_y +12,
        outline_color = 0,
        letter_width = 8,
        big = true
    })

    -- credit
    fancy_text({
        text = "by gaffe for wobblefowl",
        x = 64-48,
        y = title.credit_y,
        text_colors = { 7 },
        outline_color = 5
    })
    fancy_text({
        text = "art fight 2023",
        x = 64-32,
        y = title.credit_y +8,
        text_colors = { 7 },
        outline_color = 5
    })

end