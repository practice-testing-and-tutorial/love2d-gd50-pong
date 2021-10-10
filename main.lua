Push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    SmallFont = love.graphics.newFont('font.ttf', 8)

    love.graphics.setFont(SmallFont)

    Push:setupScreen(
        VIRTUAL_WIDTH, 
        VIRTUAL_HEIGHT, 
        WINDOW_WIDTH, 
        WINDOW_HEIGHT, 
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        }
    )
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    Push:apply('start')

    -- love.graphics.clear(40, 45, 52, 255)

    love.graphics.printf(
        'GD50 Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4 , 4)
    -- end rendering at virtual resolution
    Push:apply('end')
end