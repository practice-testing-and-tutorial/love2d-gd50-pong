Push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    SmallFont = love.graphics.newFont('font.ttf', 8)
    ScoreFont = love.graphics.newFont('font.ttf', 32)

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

    -- players initial score
    Player1Score = 0
    Player2Score = 0

    -- paddles default y position
    Player1Y = 30
    Player2Y = VIRTUAL_HEIGHT - 50;
end

function  love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        Player1Y = Player1Y + (-PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        Player1Y = Player1Y + (PADDLE_SPEED * dt)
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        Player2Y = Player2Y + (-PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        Player2Y = Player2Y + (PADDLE_SPEED * dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    Push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    love.graphics.setFont(SmallFont)
    love.graphics.printf(
        'GD50 Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(ScoreFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, Player1Y, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, Player2Y, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4 , 4)
    -- end rendering at virtual resolution
    Push:apply('end')
end