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

    -- set the title of application window
    love.window.setTitle('Pong')

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

    -- setup the sounds
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- scores
    player1Score = 0
    player2Score = 0

    -- initialize objects
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- set the serving player
    servingPlayer = 1

    -- set game state to start
    gameState = 'start'
end

-- update function
function love.update(dt)

    -- serve gameState
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    -- play state
    elseif gameState == 'play' then
        -- check collision with player 1
        if ball:collides(player1) then
            -- play a sound
            sounds['paddle_hit']:play()
            -- change dx direction with a little increment
            ball.dx = -ball.dx * 1.03
            -- change the position of the ball to the position of the collision
            ball.x = player1.x + 5

            -- randomizing the velocity with preserving the direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        -- check collision with player 1
        if ball:collides(player2) then
            -- play a sound
            sounds['paddle_hit']:play()
            -- change dx direction with a little increment
            ball.dx = -ball.dx * 1.03
            -- change the position of the ball to the position of the collision
            ball.x = player2.x -4

            -- randomizing the velocity with preserving the direction
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper boundary of the screen and change the dy direction when collide
        if ball.y <= 0 then
            -- play a sound
            sounds['wall_hit']:play()

            ball.y = 0
            ball.dy = -ball.dy
        end

        -- detect lower boundary of the screen and change the dy direction when collide
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            -- play a sound
            sounds['wall_hit']:play()

            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        -- check for left boundary for a collision with the ball and increment player 2 score
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- check for a winner
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        -- check for right boundary for a collision with the ball and increment player 1 score
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()
            
            -- check for a winner
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    -- player 1 paddle movement direction
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 paddle movement direction
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- update ball
    if gameState == 'play' then
        ball:update(dt)
    end

    -- update paddles
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            -- reset game when enter pressed while in the play state
            gameState = 'play'
        elseif gameState == 'done' then
            -- reset game when enter pressed while in the play state
            gameState = 'serve'

            -- reset the game
            ball:reset()
            player1Score = 0
            player2Score = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end

        end
    end
end

-- draw function
function love.draw()
    push:apply('start')
    
    -- clear the screen with a color
    love.graphics.clear()

    -- main text
    
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH,'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to serve the ball!', 0, 20, VIRTUAL_WIDTH,'center')
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH,'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart', 0, 50, VIRTUAL_WIDTH,'center')
        -- no message
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