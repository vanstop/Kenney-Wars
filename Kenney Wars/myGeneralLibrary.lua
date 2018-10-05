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
