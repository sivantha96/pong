Ball = Class{}

-- constructor function
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- set initial velocity to random
    self.dy = math.random(2) == 1 and -10 or 10
    self.dx = math.random(-100, 100)
end

-- collision fnction
function Ball:collides(paddle)
    -- check for vertical collision
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- check for horizontal collision
    if self.y >  paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    return true
end

-- function to reset the ball position and velocity
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(2) == 1 and -10 or 10
    self.dx = math.random(-100, 100)
end

-- function to update the ball position with time
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- function to render the ball to the screen
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end