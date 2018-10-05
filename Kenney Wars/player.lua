
function playerUpdate(dt, player, balls)
  updateControls(player.controlMode, player, balls)
  movePlayer(dt, player)
  rotatePlayer(player)
end

function updateControls(controlMode, player, balls)
  --Define os controles deste player
  if controlMode == "Player 1" or controlMode == "wasd" then
    player.left = love.keyboard.isDown("a")
    player.right = love.keyboard.isDown("d")
    if love.keyboard.isDown("e") then
      hold(balls, player)
    end
  elseif controlMode == "Player 2" or controlMode == "setas" then
    player.left = love.keyboard.isDown("left")
    player.right = love.keyboard.isDown("right")
    if love.keyboard.isDown("kp1") then
      hold(balls, player)
    end
  end
end

function movePlayer(dt, player)
  --controla a movimentação do player
  if not player.right and not player.left then
    --rotaciona o personagem para frente
    player.direction = player.directionDefault
  else
    if player.right then
      --move e rotaciona para a direita
      player.x = player.x + player.speed * dt
      player.direction = "right"
    end

    if player.left then
      --move e rotaciona para a esquerda
      player.x = player.x - player.speed * dt
      player.direction = "left"
    end
  end
end

function rotatePlayer(player)
  --Use sprites that look to the right
  if player.direction == "up" then
    player.rotation = 4.71239
  elseif player.direction == "left" then
    player.rotation = 3.14159
  elseif player.direction == "right" then
    player.rotation = 0
  elseif player.direction == "down" then
    player.rotation = 1.5708
  end
end

function hold(balls, player)
  --TO DO verifica se esta perto de uma bola então a segura
  for i,b in ipairs(balls) do
    if not b.isMoving and not b.isHold then
      if b.x < player.x + player.w and b.x + b.w > player.x then
        b.isHold = true
        b.holder = player
      end
    end
  end
end

function newPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand)
  local player = {}
  player.x = x
  player.y = y
  player.w = w
  player.h = h
  player.s = s
  player.speed = speed
  player.controlMode = controlMode
  player.sprite_hold = spriteHold
  player.sprite_stand = spriteStand
  player.directionDefault = d

  player.direction = player.directionDefault
  player.rotation = 4.71239
  player.isHolding = false
  player.left = false
  player.right = false

  table.insert(players, player)
end
