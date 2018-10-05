function newBall(x, y, w, h, s, speed, sprite)
  local ball = {}
  ball.x = x
  ball.y = y
  ball.w = w
  ball.h = h
  ball.s = s
  ball.speedX = speed
  ball.speedY = speed
  ball.sprite = sprite

  ball.direction = math.rad(45)
  ball.isMoving = true

  table.insert(balls, ball)
end

function updateBall(dt, ball)
  if ball.isMoving then
    moveBall(dt, ball)
  end
end

function moveBall(dt, ball)
  --Usa seno e coseno do angulo de direção da bola para mover corretamente tanto no eixo X como no Y
  ball.x = ball.x + math.cos(ball.direction) * ball.speedX * dt
  ball.y = ball.y + math.sin(ball.direction) * ball.speedY * dt
  --Rebate a bola
  onEdge(ball, board.x, board.y, board.w, board.h)
  --ball.direction = (2*(ball.direction)) - ((ball.direction) - 180)
end

function onEdge(ball, LimitX, LimitY, LimitW, LimitH)
  --Verificar colisão
  if ball.x < LimitX then
    ball.speedX = - ball.speedX
    ball.x = LimitX
  elseif LimitX+LimitW < ball.x + ball.w then
    ball.speedX = - ball.speedX
    ball.x = LimitX+LimitW - ball.w
  elseif ball.y < LimitY - 50 then
    ball.speedY = - ball.speedY
    ball.y = LimitY - 50
  elseif LimitY+LimitH + 50 < ball.y + ball.h then
    ball.speedY = - ball.speedY
    ball.y = LimitY+LimitH + 50 - ball.h
  else
    if ball.y < LimitY or LimitY + LimitH < ball.y + ball.h  then
      --ball.isMoving = false
    end
  end
end
