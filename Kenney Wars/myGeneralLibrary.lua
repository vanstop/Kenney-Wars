--Criado por Gabriel de Oliveira Belarmino

function isInside(target, pointerX, pointerY)
  --verifica se o pointer esta dentro do target
  if(pointerX > target.x and pointerY > target.y and pointerX < target.x + target.w and pointerY < target.y + target.h) then
    return true
  else
    return false
  end
end
