--Criado por Gabriel de Oliveira Belarmino
--Agradecimento especial a https://www.kenney.nl/assets pelos assets maravilhosos

function love.load(arg)
  love.window.setMode(900, 700) --Define o tamanho da tela
  love.window.setTitle("Kenney Wars") --Define o tirulo da janela onde o jogo acontece
  love.graphics.setBackgroundColor(0, 0, 0, 1) --Define a cor do plano de fundo (chão)

  gameState = "Game" --Variavel para controlar os estados do jogo
  --GameStates {"Menu", "HighScore", "Game", "Pause", "GameOver"}

  titleFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Rocket Square.ttf', 60)
  gameFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 15)
  buttonFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 25)

  players = {} --Armazena todos os players do jogo
  balls = {} --Armazena as bolas do jogo
  buttons = {} --Armazena todos os botões do jogo
  sprites = {} --Armazena todos os sprites do jogo
  sounds = {} --Armazena todos os soms do jogo
  soundFX = {} --Armazena todos os efeitos sonoros do jogo
  soundsBackground = {} --Armazena todos as musicas de background do jogo

  board = {}
  board.x = 200
  board.y = 75
  board.w = 500
  board.h = 550

  --Define as variaveis de volume
  SFXVolume = 1
  SFXMute = false
  musicVolume = 1
  musicMute = false


  sounds.click = love.audio.newSource('Assets/Sounds/SoundFX/Audio/click3.ogg', "static")
  sounds.menu = love.audio.newSource('Assets/Sounds/SoundBackground/Musics/412343__michorvath__sequence-8-bit-music-loop.wav', "stream")
  --Inicializa os sprites do jogo
  sprites.player1_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_stand.png')
  sprites.player1_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_hold.png')
  sprites.player2_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_stand.png')
  sprites.player2_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_hold.png')
  sprites.button_up = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button00.png')
  sprites.button_down = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button01.png')
  sprites.button_musicOn = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/musicOn.png')
  sprites.button_musicOff = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/musicOff.png')
  sprites.button_soundOn = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/audioOn.png')
  sprites.button_soundOff = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/audioOff.png')
  sprites.background_menu = love.graphics.newImage('Assets/Sprites/Background/Samples/colored_talltrees.png')
  sprites.ball_blue = love.graphics.newImage('Assets/Sprites/Game/PNG/Balls/Blue/ballBlue_04.png')
  --Configura a imagem para poder ser repetida
  sprites.background_menu:setWrap("repeat", "repeat")
  sprites.background_quad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), sprites.background_menu:getWidth(), sprites.background_menu:getHeight())

  --Importa a "classe" player e a minha biblioteca pessoal
  require('player')
  require('button')
  require('audio')
  require('ball')
  require('myGeneralLibrary')

  newSFX(sounds.click)
  newMusic(sounds.menu)

  --Instancia os players
  --newPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand)
  newPlayer(450, 50, sprites.player1_hold:getWidth(), sprites.player1_hold:getHeight(), 2, "down", 250, "wasd", sprites.player1_hold, sprites.player1_stand)
  newPlayer(450, 650, sprites.player1_hold:getWidth(), sprites.player2_hold:getHeight(), 2, "up", 250, "setas", sprites.player2_hold, sprites.player2_stand)

  --Instancia uma bola
  --newBall(x, y, w, h, s, speed, sprite)
  newBall(200, 200, sprites.ball_blue:getWidth(), sprites.ball_blue:getHeight(), 1, 500, sprites.ball_blue)

  --Intancia um novo botão
  --newButton(x, y, w, h, s, spriteUp, spriteDown, code)
  --Button Play
  newButton(love.graphics.getWidth()/2 - sprites.button_up:getWidth()/2, 500, sprites.button_up:getWidth(), sprites.button_up:getHeight(), sprites.button_up, sprites.button_down, 'gameState = "Game"', soundFX[1].sound, "return")
  --Button Mute Music
  newButton(love.graphics.getWidth() - sprites.button_musicOn:getWidth(), 15, sprites.button_musicOn:getWidth(), sprites.button_musicOn:getHeight(), sprites.button_musicOn, sprites.button_musicOff, 'musicMute = not musicMute', soundFX[1].sound, "m")
  --Button Mute Audio
  newButton(love.graphics.getWidth() - sprites.button_soundOn:getWidth(), 15 + sprites.button_musicOn:getHeight(), sprites.button_soundOn:getWidth(), sprites.button_soundOn:getHeight(), sprites.button_soundOn, sprites.button_soundOff, 'SFXMute = not SFXMute', soundFX[1].sound, "n")
end


function love.update(dt)
  --Estão fora dos GameStates os updates que rodam durante todo o jogo
  updateAudios()

  if gameState == "Menu" then
    --TO DO coisas que são atualizadas durante o menu
    updateButton(buttons[1])
    updateButton(buttons[2])
    updateButton(buttons[3])

  elseif gameState == "HighScore" then
    --TO DO coisas que são atualizadas durante o highscore
  elseif gameState == "Game" then
    love.graphics.setBackgroundColor(0, 1, 0, 1) --Define a cor do plano de fundo (chão)
    playerUpdate(dt, players[1])
    playerUpdate(dt, players[2])
    updateBall(dt, balls[1])
  end
end

function love.draw()
  --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
  if gameState == "Menu" then
    --Desenha o plano de fundo
    love.graphics.draw(sprites.background_menu, sprites.background_quad, 0, 0)
    --Inicia a musica de background
    soundsBackground[1].sound:play()

    love.graphics.setFont(titleFont)
    love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    love.graphics.printf("Kenney Wars", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    --Prepara a font para escrever os creditos
    love.graphics.setColor(math.random(0, 1), math.random(0, 1), math.random(0, 1), 1)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Created by: Gabriel de Oliveira Belarmino", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Special Thanks: https://www.kenney.nl/assets", 0, love.graphics.getHeight() - 25, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(buttonFont)
    love.graphics.draw(buttons[3].currentSprite, buttons[3].x, buttons[3].y)
    love.graphics.draw(buttons[2].currentSprite, buttons[2].x, buttons[2].y)
    love.graphics.draw(buttons[1].currentSprite, buttons[1].x, buttons[1].y)
    --Define a cor principal para preto antes de escrever JOGAR
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("JOGAR", buttons[1].x, buttons[1].y + buttons[1].h/2 - buttonFont:getHeight()/2, buttons[1].w, "center")

    --Volta a cor principal para branco (Assim tudo fica bem)
    love.graphics.setColor(1, 1, 1, 1)
  elseif gameState == "HighScore" then
    --TO DO coisas que são desenhadas durante o highscore
  elseif gameState == "Game" then
    love.graphics.printf("DEBUG" .. balls[1].direction, buttons[1].x, buttons[1].y + buttons[1].h/2 - buttonFont:getHeight()/2, buttons[1].w, "center")

    love.graphics.rectangle("fill", board.x, board.y, board.w, board.h)
    love.graphics.draw(players[1].sprite_stand, players[1].x, players[1].y, players[1].rotation, players[1].s, players[1].s, players[1].w/2, players[1].h/2)
    love.graphics.draw(players[2].sprite_stand, players[2].x, players[2].y, players[2].rotation, players[2].s, players[2].s, players[2].w/2, players[2].h/2)
    love.graphics.draw(balls[1].sprite, balls[1].x, balls[1].y, nil, balls[1].s, balls[1].s)
  end
end
