local push = require 'push'

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

    -- initial paddle positions
    player1Y = 50
    player2Y = 50

    -- initial ball position
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- initial ball velocity
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

-- update function
function love.update(dt)
    -- player 1 paddle movement
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player 2 paddle movement
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
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
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- reset a random ball velocity
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
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
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH - 10), player2Y, 5, 20)

    -- ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    push:apply('end')
end
