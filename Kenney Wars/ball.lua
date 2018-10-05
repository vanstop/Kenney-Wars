function newBall(x, y, w, h, s, speed, sprite)
  local ball = {}
  ball.x = x
  ball.y = y
  ball.w = w
  ball.h = h
  ball.s = s
  ball.speed = speed
  ball.sprite = sprite

  ball.direction = math.rad(45)
  ball.isHolding = moving

  table.insert(balls, ball)
end

function updateBall(dt, ball)
  moveBall(dt, ball)
end

function moveBall(dt, ball)
  ball.x = ball.x + math.cos(ball.direction) * ball.speed * dt
  ball.y = ball.y + math.sin(ball.direction) * ball.speed * dt
  if onEdge(ball.x, ball.y, ball.w, ball.h, board.x, board.y, board.w, board.h) then
    ball.direction = ball.direction + math.rad(90)
  end
end

function onEdge(x, y, w, h, LimitX, LimitY, LimitW, LimitH)
  --Verificar colisão
  if x > LimitX and y > LimitY and LimitX+LimitW > x+w and LimitY+LimitH > y+h  then
    return false
  else
    return true
  end
end
