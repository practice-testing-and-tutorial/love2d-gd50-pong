Push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

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

    love.window.setTitle('Om Pong')

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

    Player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    Player2 = Paddle(
        VIRTUAL_WIDTH - 10, 
        VIRTUAL_HEIGHT - 30, 
        PADDLE_WIDTH, 
        PADDLE_HEIGHT)

    Ball = Ball(
        VIRTUAL_WIDTH / 2 - BALL_WIDTH / 2, 
        VIRTUAL_HEIGHT / 2 - BALL_HEIGHT / 2, 
        BALL_WIDTH, 
        BALL_HEIGHT)

    -- players initial score
    Player1Score = 0
    Player2Score = 0

    ServingPlayer = 1

    GameState = 'start'
end

function  love.update(dt)

    if GameState == 'serve' then
        Ball.dy = math.random(-50, 50)

        if ServingPlayer == 1 then
            Ball.dx = math.random(140, 200)
        else
            Ball.dx = -math.random(140, 200)
        end
    elseif GameState == 'play' then
        -- handling collision with player 1
        -- speed up the ball and altering ball movement
        if Ball:collides(Player1) then
            Ball.dx = -Ball.dx * 1.02
            Ball.x = Player1.x + Player1.width + 1

            if Ball.dy < 0 then
                Ball.dy = -math.random(10, 150)
            else
                Ball.dy = math.random(10, 150)
            end
        end

        -- handling collision with player 1
        -- speed up the ball and altering ball movement
        if Ball:collides(Player2) then
            Ball.dx = -Ball.dx * 1.02
            Ball.x = Player2.x - Ball.width - 1

            if Ball.dy < 0 then
                Ball.dy = -math.random(10, 150)
            else
                Ball.dy = math.random(10, 150)
            end
        end

        -- handling collision with screen boundary
        if Ball.y <= 0 then
            Ball.y = 0
            Ball.dy = -Ball.dy
        end

        if Ball.y >= VIRTUAL_HEIGHT - Ball.height then
            Ball.y = VIRTUAL_HEIGHT - Ball.height
            Ball.dy = -Ball.dy
        end

        -- handling score
        if Ball.x < 0 then
            ServingPlayer = 1
            Player2Score = Player2Score + 1
            Ball:reset()
            GameState = 'serve'
        end

        if Ball.x + Ball.width > VIRTUAL_WIDTH then
            ServingPlayer = 2
            Player1Score = Player1Score + 1
            Ball:reset()
            GameState = 'serve'
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        Player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        Player1.dy = PADDLE_SPEED
    else
        Player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        Player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        Player2.dy = PADDLE_SPEED
    else
        Player2.dy = 0
    end

    -- ball movement
    if GameState == 'play' then
        Ball:update(dt)
    end

    Player1:update(dt)
    Player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if GameState == 'start' then
            GameState = 'serve'
        elseif GameState == 'serve' then
            GameState = 'play'
        end
    end
end

function love.draw()
    -- begin rendering at virtual resolution
    Push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    if GameState == 'start' then
        love.graphics.setFont(SmallFont)
        love.graphics.printf('Welcome to Om-Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'serve' then
        love.graphics.setFont(SmallFont)
        love.graphics.printf(
            'Player ' .. tostring(ServingPlayer) .. "'s serve!",
            0,
            10,
            VIRTUAL_WIDTH,
            'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif GameState == 'play' then
        -- nothing to display yet
    end

    DisplayScore()

    -- render first paddle (left side)
    Player1:render()

    -- render second paddle (right side)
    Player2:render()

    -- render ball (center)
    Ball:render()

    DisplayFPS()

    -- end rendering at virtual resolution
    Push:apply('end')
end

function DisplayFPS()
    love.graphics.setFont(SmallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function DisplayScore()
    love.graphics.setFont(ScoreFont)
    love.graphics.print(tostring(Player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(Player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end