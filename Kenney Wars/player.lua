
function playerUpdate(dt, player, balls)
  if not player.stuned then
    updateControls(player.controlMode, player, balls)
    movePlayer(dt, player)
    rotatePlayer(player)
  elseif player.timeToRecover <= 0 then
    player.stuned = false
    player.timeToRecover = 1
  else
    player.sprite = player.sprite_stuned
    player.timeToRecover = player.timeToRecover - love.timer.getDelta()
  end
end

function updateControls(controlMode, player, balls)
  --Define os controles deste player
  if controlMode == "Player 1" or controlMode == "wasd" then
    player.left = love.keyboard.isDown("a")
    player.right = love.keyboard.isDown("d")
    if love.keyboard.isDown("e") then
      if not player.isHolding then
        hold(balls, player)
      end
    elseif player.isHolding then
      throw(player)
    end
  elseif controlMode == "Player 2" or controlMode == "setas" then
    player.left = love.keyboard.isDown("left")
    player.right = love.keyboard.isDown("right")
    if love.keyboard.isDown("kp1") then
      if not player.isHolding then
        hold(balls, player)
      end
    elseif player.isHolding then
      throw(player)
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

  --Define o sprite do personagem de acordo com a nescessidade
  if player.isHolding then
    player.sprite = player.sprite_hold
  else
    player.sprite = player.sprite_stand
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
      if b.x + (b.w/2) < player.x + player.w / 2 and b.x + (b.w/2) > player.x - player.h / 2 and distanceBetween(player.x, player.y, b.x + (b.w/2), b.y + (b.h/2)) < 50 then
        b.isHold = true
        b.holder = player
        player.holdedBall = b
        player.isHolding = true
        player.throw = false
      end
    end
  end
end

function throw(player)
  player.throw = true
  player.holdedBall = nil
  player.isHolding = false
end

function newPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand, spriteStuned)
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
  player.sprite_stuned = spriteStuned
  player.directionDefault = d

  player.direction = player.directionDefault
  player.rotation = 4.71239
  player.isHolding = false
  player.left = false
  player.right = false
  player.holdedBall = nil
  player.throw = false
  player.stuned = false
  player.timeToRecover = 1
  player.sprite = player.sprite_stand

  table.insert(players, player)
end
