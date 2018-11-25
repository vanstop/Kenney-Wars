function newButton(x, y, w, h, spriteUp, spriteDown, code, sound, keyboardEquivalent)
  local button = {}
  button.x = x
  button.y = y
  button.w = w
  button.h = h
  button.sprite_up = spriteUp
  button.sprite_down = spriteDown
  button.currentSprite = spriteUp
  button.code = code
  button.sound = sound
  button.keyboardEquivalent = keyboardEquivalent

  button.isDown = false
  button.isActive = false
  button.yWhenDown = button.y + 4
  button.yWhenUp = button.y

  table.insert(buttons, button)
end

function updateButton(button)
  --Verifica se o mouse esta em cima do botão
  if isInside(love.mouse.getX(), love.mouse.getY(), 1, 1, button.x, button.y, button.w, button.h) or keyPressed == button.keyboardEquivalent or isActive then
    button.currentSprite = button.sprite_down
    button.y = button.yWhenDown
    --Verifica se o mouse foi clicado enquanto estava em cima do botão
    if click or keyPressed == button.keyboardEquivalent then
      button.isActive = not button.isActive
      --Desliga as boleanas para evitar que o botão fique sendo apertado repetidamente
      click = false
      keyPressed = ""
      --Caso o botão tenha um som, ele é executado
      if button.sound then
        button.sound:play()
      end
      --Le uma string como código
      assert(loadstring(button.code))()
    end
  elseif not button.isActive then
    button.currentSprite = button.sprite_up
    button.y = button.yWhenUp
  end
end

function love.mousepressed(x, y, b)
  click = true
end

function love.mousereleased(x, y, b)
  click = false
end
