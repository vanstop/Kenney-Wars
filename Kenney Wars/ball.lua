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

  table.insert(balls, ball)
end

function updateBall(dt, ball, players)
  debug = ball.direction
  if ball.isMoving then
    moveBall(dt, ball)
    for i, p in ipairs(players) do
      if distanceBetween(p.x, p.y, ball.x + (ball.w/2), ball.y + (ball.h/2)) < 35 then
        p.stuned = true
      end
    end
  end

  if ball.isHold then
    if ball.holder.directionDefault == "up" then
      if ball.holder.direction == "left" then
        ball.x = ball.holder.x - ball.w/2 - ball.holder.w / 2 - 10
        ball.y = ball.holder.y - ball.h/2
        ball.direction = math.rad(-45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = -ball.speed
      elseif ball.holder.direction == "right" then
        ball.x = ball.holder.x - ball.w/2 + ball.holder.w / 2 + 10
        ball.y = ball.holder.y - ball.h/2
        ball.direction = math.rad(-45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = ball.speed
      else
        ball.x = ball.holder.x - ball.w/2
        ball.y = ball.holder.y - ball.h/2 - ball.holder.h / 2
        ball.direction = ball.holder.rotation --Define a rotacao da bola com base na rotacao do player
      end

      if ball.holder.throw then
        ball.isMoving = true
        ball.isHold = false
      end

    elseif ball.holder.directionDefault == "down" then
      if ball.holder.direction == "left" then
        ball.x = ball.holder.x - ball.w/2 - ball.holder.w / 2 - 10
        ball.y = ball.holder.y - ball.h/2
        ball.direction = math.rad(45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = - ball.speed
      elseif ball.holder.direction == "right" then
        ball.x = ball.holder.x - ball.w/2 + ball.holder.w / 2 + 10
        ball.y = ball.holder.y - ball.h/2
        ball.direction = math.rad(45) --Define a rotacao da bola com base na rotacao do player
        ball.speedX = ball.speed
      else
        ball.x = ball.holder.x - ball.w/2
        ball.y = ball.holder.y + ball.h/2
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
  --ball.direction = (2*(ball.direction)) - ((ball.direction) - 180)
end

function ThisifOnEdgeBounce(ball, LimitX, LimitY, LimitW, LimitH)
  --Verificar colisão
  if ball.y < LimitY - 50 or LimitY + LimitH + 50 < ball.y + ball.h  then
      ball.isMoving = false
  end

  if ball.x < LimitX then
    ball.speedX = - ball.speedX
    ball.x = LimitX
  elseif LimitX+LimitW < ball.x + ball.w then
    ball.speedX = - ball.speedX
    ball.x = LimitX+LimitW - ball.w
  end
end
