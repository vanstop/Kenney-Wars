function newButton(x, y, w, h, spriteUp, spriteDown, code)
  local button = {}
  button.x = x
  button.y = y
  button.w = w
  button.h = h
  button.sprite_up = spriteUp
  button.sprite_down = spriteDown
  button.currentSprite = spriteUp
  button.code = code

  button.isDown = false
  button.yWhenDown = button.y + 4
  button.yWhenUp = button.y

  table.insert(buttons, button)
end

function updateButton(button)
  --Verifica se o mouse esta em cima do botão
  if isInside(button, love.mouse.getX(), love.mouse.getY()) then
    button.currentSprite = button.sprite_down
    button.y = button.yWhenDown
    --Verifica se o mouse foi clicado enquanto estava em cima do botão
    if love.mouse.isDown(1) then
      assert(loadstring(button.code))()
    end
  else
    button.currentSprite = button.sprite_up
    button.y = button.yWhenUp
  end
end
