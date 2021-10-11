Push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

BALL_WIDTH = 4
BALL_HEIGHT = 4

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- setup the random seed
    math.randomseed(os.time())

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

    BallX = VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2
    BallY = VIRTUAL_HEIGHT / 2 - BALL_HEIGHT / 2

    -- delta X and delta Y. means velocity
    BallDX = math.random(2) == 1 and 100 or -100
    BallDY = math.random(-50, 50)

    GameState = 'start'
end

function  love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        Player1Y = math.max(0, Player1Y + (-PADDLE_SPEED * dt))
    elseif love.keyboard.isDown('s') then
        Player1Y = math.min( VIRTUAL_HEIGHT - PADDLE_HEIGHT, Player1Y + (PADDLE_SPEED * dt))
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        Player2Y = math.max(0, Player2Y + (-PADDLE_SPEED * dt))
    elseif love.keyboard.isDown('down') then
        Player2Y = math.min(VIRTUAL_HEIGHT - PADDLE_HEIGHT, Player2Y + (PADDLE_SPEED * dt))
    end

    -- ball movement
    if GameState == 'play' then
        BallX = BallX + BallDX * dt
        BallY = BallY + BallDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'play'
        else
            GameState = 'start'

            BallX = VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2
            BallY = VIRTUAL_HEIGHT / 2 - BALL_HEIGHT / 2

            BallDX = math.random(2) == 1 and 100 or -100
            BallDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    Push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    love.graphics.setFont(SmallFont)

    if GameState == 'start' then
        love.graphics.printf('Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(ScoreFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, Player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, Player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- render ball (center)
    love.graphics.rectangle('fill', BallX, BallY, BALL_WIDTH, BALL_HEIGHT)
    -- end rendering at virtual resolution
    Push:apply('end')
end