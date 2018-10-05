--Criado por Gabriel de Oliveira Belarmino

function isInside(target, pointerX, pointerY)
  --verifica se o pointer esta dentro do target
  if(pointerX > target.x and pointerY > target.y and pointerX < target.x + target.w and pointerY < target.y + target.h) then
    return true
  else
    return false
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

function AngleTo(looker, target)
  return math.atan2(looker.y - target.y,looker.x - target.x)
end

function isInside(x, y, w, h, LimitX, LimitY, LimitW, LimitH)
  --Verificar colisão
  if x > LimitX and y > LimitY and LimitX+LimitW > x+w and LimitY+LimitH > y+h  then
    return true
  else
    return false
  end
end

function ifOnEdgeBounce(ball, LimitX, LimitY, LimitW, LimitH)
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
