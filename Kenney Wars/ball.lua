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
  ball.holder = nil
  ball.isMoving = true
  ball.isHold = false

  table.insert(balls, ball)
end

function updateBall(dt, ball)
  if ball.isMoving then
    moveBall(dt, ball)
  end

  if ball.isHold then
    if ball.holder.left then
      ball.x = ball.holder.x - ball.w/2 - ball.holder.w / 2 - 10
      ball.y = ball.holder.y - ball.h/2
    elseif ball.holder.right then
      ball.x = ball.holder.x - ball.w/2 + ball.holder.w / 2 + 10
      ball.y = ball.holder.y - ball.h/2
    else
      if ball.holder.throw then
        debug = "a bola ve que era para ser lançada"
        ball.direction = ball.holder.rotation
        ball.isMoving = true
        ball.isHold = false
      end
      ball.x = ball.holder.x - ball.w/2
      ball.y = ball.holder.y - ball.h/2 - ball.holder.h / 2
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
