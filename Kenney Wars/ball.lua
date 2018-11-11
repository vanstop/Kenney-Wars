function newBall(x, y, w, h, s, speed, sprite)
  local ball = {}
  ball.x = x
  ball.y = y
  ball.w = w
  ball.h = h
  ball.s = s
  ball.speed = speed
  ball.speedX = speed
  ball.speedY = speed
  ball.sprite = sprite

  ball.direction = math.rad(45)
  ball.holder = nil
  ball.isMoving = false
  ball.isHold = false
  ball.isOverlapping = false
  ball.directionToAvoid = 0.1 --Positive to right and Negative to left, the value sets the speed

  table.insert(balls, ball)
end

function updateBall(dt, ball, players, balls)
  if ball.isOverlapping then
    ball.x = ball.x + ball.directionToAvoid * ball.speed * dt
  end
  if ball.isMoving then
    moveBall(dt, ball)
    for i, p in ipairs(players) do
      if distanceBetween(p.x, p.y, ball.x, ball.y) < 35 then
        p.stuned = true
      end
    end
  else
    if not ball.isHold then
      ifOverlaping(ball, balls)
      if ball.x - ball.w/2 < board.x then
        ball.x = board.x + ball.w/2
      elseif board.x + board.w < ball.x + ball.w/2 then
        ball.x = board.x + board.w - ball.w/2
      end
    end
  end

  if ball.isHold then
    if ball.holder.directionDefault == "up" then
      if ball.holder.direction == "left" then
        ball.x = ball.holder.x - ball.w
        ball.y = ball.holder.y
        ball.direction = math.rad(-45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = -ball.speed
      elseif ball.holder.direction == "right" then
        ball.x = ball.holder.x + ball.w
        ball.y = ball.holder.y
        ball.direction = math.rad(-45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = ball.speed
      else
        ball.x = ball.holder.x
        ball.y = ball.holder.y - ball.h
        ball.direction = ball.holder.rotation --Define a rotacao da bola com base na rotacao do player
      end

      if ball.holder.throw then
        ball.isMoving = true
        ball.isHold = false
      end

    elseif ball.holder.directionDefault == "down" then
      if ball.holder.direction == "left" then
        ball.x = ball.holder.x - ball.w
        ball.y = ball.holder.y
        ball.direction = math.rad(45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = - ball.speed
      elseif ball.holder.direction == "right" then
        ball.x = ball.holder.x + ball.w
        ball.y = ball.holder.y
        ball.direction = math.rad(45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = ball.speed
      else
        ball.x = ball.holder.x
        ball.y = ball.holder.y + ball.h
        ball.direction = ball.holder.rotation --Define a rotacao da bola com base na rotacao do player
      end

      if ball.holder.throw then
        ball.isMoving = true
        ball.isHold = false
      end
    end
  end
end

function moveBall(dt, ball)
  --Usa seno e coseno do angulo de direção da bola para mover corretamente tanto no eixo X como no Y
  ball.x = ball.x + math.cos(ball.direction) * ball.speedX * dt
  ball.y = ball.y + math.sin(ball.direction) * ball.speedY * dt
  --Rebate a bola
  ThisifOnEdgeBounce(ball, board.x, board.y, board.w, board.h)
end

function ifOverlaping(ball, balls)
  for i,b in ipairs(balls) do
    if b ~= ball and not b.isHold then
      if distanceBetween(b.x, b.y, ball.x, ball.y) < ball.w then
        ball.isOverlapping = true
        if ball.x < b.x then
          ball.directionToAvoid = -0.1
        else
          ball.directionToAvoid = 0.1
        end
        break
      else
        ball.isOverlapping = false
      end
    end
  end
end

function ThisifOnEdgeBounce(ball, LimitX, LimitY, LimitW, LimitH)
  --Verificar colisão
  if ball.y < LimitY - ball.h/2 or LimitY + LimitH + ball.h/2 < ball.y then
      ball.isMoving = false
  end

  if ball.x - ball.w/2 < LimitX then
    ball.speedX = - ball.speedX
    ball.x = LimitX + ball.w/2
  elseif LimitX+LimitW < ball.x + ball.w/2 then
    ball.speedX = - ball.speedX
    ball.x = LimitX+LimitW - ball.w/2
  end
end
