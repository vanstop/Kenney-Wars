--Criado por Gabriel de Oliveira Belarmino
--Agradecimento especial a https://www.kenney.nl/assets pelos assets maravilhosos

function love.load(arg)
  love.window.setMode(900, 700) --Define o tamanho da tela
  love.window.setTitle("Kenney Wars") --Define o tirulo da janela onde o jogo acontece
  love.graphics.setBackgroundColor(0, 0, 0, 1) --Define a cor do plano de fundo (chão)

  gameState = "Menu" --Variavel para controlar os estados do jogo
  --GameStates {"Menu", "HighScore", "Game", "GameOver"}

  titleFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Rocket Square.ttf', 60)
  gameFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 15)
  buttonFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 25)

  players = {} --Armazena todos os players do jogo
  buttons = {} --Armazena todos os botões do jogo
  audios = {} --Armazena todos os audios do jogo
  sprites = {} --Armazena todos os sprites do jogo

  audios.soundsFX = {} --Armazena todos os efeitos sonoros do jogo
  audios.soundsBackground = {}--Armazena todos as musicas de background do jogo

  audios.soundsFX.click = love.audio.newSource('Assets/Sounds/SoundFX/Audio/click4.ogg', "static")
  audios.soundsBackground.menu = love.audio.newSource('Assets/Sounds/SoundBackground/Musics/412343__michorvath__sequence-8-bit-music-loop.wav', "stream")

  --Inicializa os sprites do jogo
  sprites.player1_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_stand.png')
  sprites.player1_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_hold.png')
  sprites.player2_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_stand.png')
  sprites.player2_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_hold.png')
  sprites.button_up = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button00.png')
  sprites.button_down = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button01.png')
  sprites.background_menu = love.graphics.newImage('Assets/Sprites/Background/Samples/colored_talltrees.png')
  --Configura a imagem para poder ser repetida
  sprites.background_menu:setWrap("repeat", "repeat")
  sprites.background_quad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), sprites.background_menu:getWidth(), sprites.background_menu:getHeight())

  --Importa a "classe" player e a minha biblioteca pessoal
  require('player')
  require('button')
  require('myGeneralLibrary')

  --Instancia os players
  --spawnPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand)
  newPlayer(450, 100, sprites.player1_hold:getWidth(), sprites.player1_hold:getHeight(), 2, "down", 250, "wasd", sprites.player1_hold, sprites.player1_stand)
  newPlayer(450, 600, sprites.player1_hold:getWidth(), sprites.player2_hold:getHeight(), 2, "up", 250, "setas", sprites.player2_hold, sprites.player2_stand)

  --Intancia um novo botão
  --newButton(x, y, w, h, s, spriteUp, spriteDown, code)
  newButton(love.graphics.getWidth()/2 - sprites.button_up:getWidth()/2, 500, sprites.button_up:getWidth(), sprites.button_up:getHeight(), sprites.button_up, sprites.button_down, 'gameState = "Game"', audios.soundsFX.click)
end


function love.update(dt)
  if gameState == "Menu" then
    --TO DO coisas que são atualizadas durante o menu
    updateButton(buttons[1])

  elseif gameState == "HighScore" then
    --TO DO coisas que são atualizadas durante o highscore
  elseif gameState == "Game" then
    love.graphics.setBackgroundColor(0, 1, 0, 1) --Define a cor do plano de fundo (chão)
    playerUpdate(dt, players[1])
    playerUpdate(dt, players[2])
  end
end

function love.draw()
  --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
  if gameState == "Menu" then
    --Desenha o plano de fundo
    love.graphics.draw(sprites.background_menu, sprites.background_quad, 0, 0)
    --Inicia a musica de background
    audios.soundsBackground.menu:play()

    love.graphics.setFont(titleFont)
    love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    love.graphics.printf("Kenney Wars", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    --Prepara a font para escrever os creditos
    love.graphics.setColor(math.random(0, 1), math.random(0, 1), math.random(0, 1), 1)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Programado por: Gabriel de Oliveira Belarmino", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Sprites por: https://www.kenney.nl/assets", 0, love.graphics.getHeight() - 25, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(buttonFont)
    love.graphics.draw(buttons[1].currentSprite, buttons[1].x, buttons[1].y)
    --Define a cor principal para preto antes de escrever JOGAR
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("JOGAR", buttons[1].x, buttons[1].y + buttons[1].h/2 - buttonFont:getHeight()/2, buttons[1].w, "center")

    --Volta a cor principal para branco (Assim tudo fica bem)
    love.graphics.setColor(1, 1, 1, 1)
  elseif gameState == "HighScore" then
    --TO DO coisas que são desenhadas durante o highscore
  elseif gameState == "Game" then
    love.graphics.draw(players[1].sprite_stand, players[1].x, players[1].y, players[1].rotation, players[1].s, players[1].s, players[1].w/2, players[1].h/2)
    love.graphics.draw(players[2].sprite_stand, players[2].x, players[2].y, players[2].rotation, players[2].s, players[2].s, players[2].w/2, players[2].h/2)
  end
end
