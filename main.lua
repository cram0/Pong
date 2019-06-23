push = require 'push'
Class = require 'class'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

PADDLE1_X = 5
PADDLE1_Y = 20
PADDLE2_X = VIRTUAL_WIDTH - 15
PADDLE2_Y = VIRTUAL_HEIGHT - 50

BALL_dx = 0
BALL_dy = 0
BALL_X = VIRTUAL_WIDTH / 2 - 4
BALL_Y = VIRTUAL_HEIGHT / 2 - 4

PLAYER1_SCORE = 0
PLAYER2_SCORE = 0

gameState = "start"

smallFont = love.graphics.newFont('font.ttf', 8)
largeFont = love.graphics.newFont('font.ttf', 16)
scoreFont = love.graphics.newFont('font.ttf', 32)
love.graphics.setFont(smallFont)

math.randomseed(os.time())

love.window.setTitle("Pong AI")

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT, {fullscreen = false})
end

function reset()
    BALL_X = VIRTUAL_WIDTH / 2 - 4
    BALL_Y = VIRTUAL_HEIGHT / 2 - 4
    BALL_dx = 0
    BALL_dy = 0
    gameState = "start"
end

function displaywinner()
    if PLAYER1_SCORE == 10 then
    love.graphics.print(tostring("Player 1 won"), VIRTUAL_WIDTH / 4, 40)
    elseif PLAYER2_SCORE == 10 then
    love.graphics.print(tostring("Player 2 won"), VIRTUAL_WIDTH / 4, 40)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if gameState == "start" then
         if key == "return" then
            BALL_dx = math.random(300)
            BALL_dy = math.random(-200,200)
            gameState = "live"
        end
    elseif gameState == "finished" then
        if key == "return" then
            BALL_dx = math.random(300)
            BALL_dy = math.random(-200,200)
            PLAYER1_SCORE = 0
            PLAYER2_SCORE = 0
            reset()
        end
    end

end

function love.update(dt)

    if love.keyboard.isDown("z") then
        PADDLE1_Y = PADDLE1_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown("s") then
        PADDLE1_Y = PADDLE1_Y + PADDLE_SPEED * dt
    end
    if love.keyboard.isDown("up") then
        PADDLE2_Y = PADDLE2_Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown("down") then
        PADDLE2_Y = PADDLE2_Y + PADDLE_SPEED * dt
    end

    if PADDLE2_Y + (30/2) > BALL_Y then
        PADDLE2_Y = PADDLE2_Y + -PADDLE_SPEED * dt
    elseif PADDLE2_Y + (30/2) < BALL_Y then
        PADDLE2_Y = PADDLE2_Y + PADDLE_SPEED * dt
    end

    --AABB Collision between Paddle 1 & Ball
    if BALL_X < PADDLE1_X + 10 and BALL_X + 4 > PADDLE1_X and BALL_Y < PADDLE1_Y + 30 and BALL_Y + 4 > PADDLE1_Y then
        BALL_dx = -BALL_dx * 1.07
        BALL_dy = BALL_dy + math.random(-50,50)
    end

    --AABB Collision between Paddle 2 & Ball
    if BALL_X < PADDLE2_X + 10 and BALL_X + 4 > PADDLE2_X and BALL_Y < PADDLE2_Y + 30 and BALL_Y + 4 > PADDLE2_Y then
        BALL_dx = -BALL_dx * 1.07
        BALL_dy = BALL_dy + math.random(-50,50)
    end

    -- Top & bottom Paddle 1 collision detection
    if PADDLE1_Y <= 0 then
        PADDLE1_Y = 0
    elseif PADDLE1_Y >= VIRTUAL_HEIGHT - 30 then
        PADDLE1_Y = VIRTUAL_HEIGHT - 30
    end

    --Top & bottom Paddle 2 collision detection
    if PADDLE2_Y <= 0 then
        PADDLE2_Y = 0
    elseif PADDLE2_Y >= VIRTUAL_HEIGHT - 30 then
        PADDLE2_Y = VIRTUAL_HEIGHT - 30
    end

    --Top & bottom Ball collision detection
    if BALL_Y + 4 >= VIRTUAL_HEIGHT then
        BALL_dy = -BALL_dy
        BALL_dx = BALL_dx
    elseif BALL_Y <= 0 then
        BALL_dy = -BALL_dy
        BALL_dx = BALL_dx
    end

    -- Horizontal Ball collision detection / Ball scored
    if BALL_X >= VIRTUAL_WIDTH then
        PLAYER1_SCORE = PLAYER1_SCORE + 1
        reset()
        if PLAYER1_SCORE == 10 then 
            gameState = "finished"
        end
    elseif BALL_X <= 0 then
        PLAYER2_SCORE = PLAYER2_SCORE + 1
        reset()
        if PLAYER2_SCORE == 10 then 
            gameState = "finished"
        end
    end

    --Acceleration
    BALL_X = BALL_X + BALL_dx * dt
    BALL_Y = BALL_Y + BALL_dy * dt

    

end

function love.draw()   
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    push:apply("start")
    displaywinner()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(PLAYER1_SCORE), VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(PLAYER2_SCORE), VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)
    love.graphics.rectangle("fill", PADDLE1_X,PADDLE1_Y, 10, 30)
    love.graphics.rectangle("fill", PADDLE2_X, PADDLE2_Y, 10, 30)
    love.graphics.rectangle("fill", BALL_X, BALL_Y , 4, 4)
    push:apply("end") 
end