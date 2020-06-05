push = require 'push'
Class = require 'class'

require 'Ball'
require 'Paddle'

-- screen params
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 720

-- vitual screen params
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle speed
PADDLE_SPEED = 200

-- load function
function love.load()
    -- pixelate everything
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- get a random seed for random function
    math.randomseed(os.time())

    -- setup fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 32)

    -- set the default font
    love.graphics.setFont(smallFont)

    -- setup the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, 
        resizable = false, 
        vsync = true
    })

    -- scores
    player1Score = 0
    player2Score = 0

    -- initialize objects
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

-- update function
function love.update(dt)
    -- player 1 paddle movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 paddle movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

-- keyboard handling
function love.keypressed(key) 
    if key == 'escape' then 
        -- quit game when esc pressed
        love.event.quit() 
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            -- play the game when enter pressed while in the start state
            gameState = 'play'
        else
            -- reset game when enter pressed while in the play state
            gameState = 'start'

            -- reset ball position
            ball:reset()
        end
    end
end

-- draw function
function love.draw()
    push:apply('start')
    
    -- clear the screen with a color
    love.graphics.clear()

    -- main text
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH,'center')
    else
        love.graphics.printf('Game on!!!', 0, 20, VIRTUAL_WIDTH,'center')

    end
    
    -- scores
    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- paddles
    player1:render()
    player2:render()

    -- ball
    ball:render()
    push:apply('end')
end
