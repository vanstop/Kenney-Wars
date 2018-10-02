function love.load(arg)
  love.window.setMode(900, 700) --Define o tamanho da tela
  love.graphics.setBackgroundColor(0, 1, 0, 1) --Define a cor do plano de fundo (chão)

  gameState = "Menu" --Variavel para controlar os estados do jogo

  players = {}
  sprites = {} --Armazena todos os sprites do jogo
  --Inicializa os sprites do jogo
  sprites.player1_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_stand.png')
  sprites.player1_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_hold.png')
  sprites.player2_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_stand.png')
  sprites.player2_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_hold.png')

  --Importa a "classe" player
  require('player')
  --spawnPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand)
  newPlayer(450, 100, sprites.player1_hold:getWidth(), sprites.player1_hold:getHeight(), 2, "down", 250, "wasd", sprites.player1_hold, sprites.player1_stand)
  newPlayer(450, 600, sprites.player1_hold:getWidth(), sprites.player2_hold:getHeight(), 2, "up", 250, "setas", sprites.player2_hold, sprites.player2_stand)
end


function love.update(dt)
  playerUpdate(dt, players[1])
  playerUpdate(dt, players[2])
end

function love.draw()
  --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
  love.graphics.draw(players[1].sprite_stand, players[1].x, players[1].y, players[1].rotation, players[1].s, players[1].s, players[1].w/2, players[1].h/2)
  love.graphics.draw(players[2].sprite_stand, players[2].x, players[2].y, players[2].rotation, players[2].s, players[2].s, players[2].w/2, players[2].h/2)
end
