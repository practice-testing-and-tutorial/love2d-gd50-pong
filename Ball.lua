Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy =  math.random(-50, 50)
end

--[[
    we could refactor to make the ball movement handling processed inside
    this collides function.
    but it's just not a best practice,
    since we can do manything with the collides information
]]
function Ball:collides(paddle)
    --[[
        if ball is far right to the paddle
        or
        if paddle is far right to the ball
    ]]
    if self.x > paddle.x + paddle.width
    or paddle.x > self.x + self.width then
        return false
    end

    --[[
        if ball is far down to the paddle
        or
        if paddle is far down to the ball
    ]]
    if self.y > paddle.y + paddle.height
    or paddle.y > self.y + self.height then
        return false
    end

    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy =  math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end