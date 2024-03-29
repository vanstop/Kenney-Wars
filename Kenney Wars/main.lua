--Criado por Gabriel de Oliveira Belarmino
--Agradecimento especial a https://www.kenney.nl/assets pelos assets maravilhosos


-- Informações uteis
  --Player 1 refere-se ao personagem na parte superior da tela o de camisa azul.
  --Player 2 refere-se ao personagem na parte inferior da tela o de camisa marrom.

function love.load(arg)
  love.graphics.setBackgroundColor(0, 0, 0, 1) --Define a cor do plano de fundo (chão)

  debugMode = false

  if debugMode then
    love.window.setMode(1500, 700, {resizable=true}) --Define o tamanho da tela para suportar o debug mode
    love.window.setTitle("♠ DEBUG MODE ♠") --Define o tirulo da janela onde o jogo acontece
  else
    love.window.setMode(900, 700, {resizable=false}) --Define o tamanho da tela
    love.window.setTitle("♥ Kenney Wars ♥") --Define o tirulo da janela onde o jogo acontece
  end

  gameState = "Menu" --Variavel para controlar os estados do jogo
  --GameStates {"Menu", "HighScore", "Game", "Pause", "GameOver"}
  gameSubState = "Playing" --Variavel para controlar os sub estados do estado GameOver
  -- SubStates {"Playing", "Paused"}

  --Fonts utilizadas em jogo
  titleFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Rocket Square.ttf', 60)
  gameFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 15)
  debugFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 15)
  buttonFont = love.graphics.newFont('Assets/Fonts/Fonts/Kenney Mini Square.ttf', 25)

  players = {} --Armazena todos os players do jogo
  matchs = {} --Armazena todas as partidas do jogo
  balls = {} --Armazena as bolas do jogo
  buttons = {} --Armazena todos os botões do jogo
  sprites = {} --Armazena todos os sprites do jogo
  sounds = {} --Armazena todos os soms do jogo
  soundFX = {} --Armazena todos os efeitos sonoros do jogo
  soundsBackground = {} --Armazena todos as musicas de background do jogo

  joysticks = love.joystick.getJoysticks() --Armazena os controles que encontra conectados no computador

  --Define as variaveis de volume
  SFXVolume = 1
  SFXMute = false
  musicVolume = 1
  musicMute = false

  --Armazena a partida atual
  currentMatch = ""

  -- Importa os arquivos de audio para o jogo
  sounds.click = love.audio.newSource('Assets/Sounds/SoundFX/Audio/click3.ogg', "static")
  sounds.menu = love.audio.newSource('Assets/Sounds/SoundBackground/Musics/360608__sirkoto51__loading.wav', "stream")
  sounds.game = love.audio.newSource('Assets/Sounds/SoundBackground/Musics/378110__sirkoto51__retro-puzzle-music-loop.wav', "stream")
  sounds.startGame = love.audio.newSource('Assets/Sounds/SoundFX/Audio/434795__aditwayer__race-countdown.wav', "static")
  sounds.endGame = love.audio.newSource('Assets/Sounds/SoundFX/Audio/182351__kesu__alarm-clock-beep.wav', "static")
  sounds.holdBall = love.audio.newSource('Assets/Sounds/SoundFX/Audio/243621__octodisk__woop-sound.mp3', "static")
  sounds.throwBall = love.audio.newSource('Assets/Sounds/SoundFX/Audio/60007__qubodup__swipe-whoosh.wav', "static")
  sounds.ballsColliding = love.audio.newSource('Assets/Sounds/SoundFX/Audio/416886__whitelinefever__hammer-hitting-a-head.wav', "static")
  sounds.stun = love.audio.newSource('Assets/Sounds/SoundFX/Audio/390462__huminaatio__punch-in-the-face.wav', "static")
  sounds.win = love.audio.newSource('Assets/Sounds/SoundBackground/Musics/352283__sirkoto51__success-loop-1.wav', "stream")

  --Inicializa os sprites do jogo
  sprites.player1_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_stand.png')
  sprites.player1_stuned = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_stuned.png')
  sprites.player1_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_hold.png')
  sprites.player1_medal = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_medal.png')
  sprites.player1_icon = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Blue/manBlue_icon.png')
  sprites.player2_stand = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_stand.png')
  sprites.player2_stuned = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_stuned.png')
  sprites.player2_hold = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_hold.png')
  sprites.player2_medal = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_medal.png')
  sprites.player2_icon = love.graphics.newImage('Assets/Sprites/Game/PNG/Man Brown/manBrown_icon.png')
  sprites.button_up = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button00.png')
  sprites.button_down = love.graphics.newImage('Assets/Sprites/UI/PNG/green_button01.png')
  sprites.button_musicOn = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/musicOn.png')
  sprites.button_musicOff = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/musicOff.png')
  sprites.button_soundOn = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/audioOn.png')
  sprites.button_soundOff = love.graphics.newImage('Assets/Sprites/UI/gameicons/PNG/Black/1x/audioOff.png')
  sprites.background_menu = love.graphics.newImage('Assets/Sprites/Background/Samples/colored_talltrees.png')
  sprites.ball_blue = love.graphics.newImage('Assets/Sprites/Game/PNG/Balls/Blue/ballBlue_04.png')
  sprites.ball_yellow = love.graphics.newImage('Assets/Sprites/Game/PNG/Balls/Yellow/ballYellow_04.png')
  sprites.board_blue = love.graphics.newImage('Assets/Sprites/Game/PNG/KenneyWarsBoard.png')
  sprites.tribune = love.graphics.newImage('Assets/Sprites/Game/PNG/Objects/tribune_full.png')
  sprites.emote_Stuned = love.graphics.newImage('Assets/Sprites/UI/emote_stars.png')
  sprites.emote_Happy = love.graphics.newImage('Assets/Sprites/UI/emote_faceHappy.png')
  sprites.emote_Angry = love.graphics.newImage('Assets/Sprites/UI/emote_faceAngry.png')

  --Configura a imagem para poder ser repetida
  sprites.background_menu:setWrap("repeat", "repeat")
  sprites.background_quad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), sprites.background_menu:getWidth(), sprites.background_menu:getHeight())

  board = {}
  board.x = 200
  board.y = 75
  board.w = 500
  board.h = 550
  board.sprite = sprites.board_blue

  --Importa a "classe" player e a minha biblioteca pessoal
  require('player')
  require('match')
  require('button')
  require('audio')
  require('ball')
  require('myGeneralLibrary')

  newSFX(sounds.click)
  newSFX(sounds.startGame)
  newSFX(sounds.endGame)
  newSFX(sounds.stun)
  newSFX(sounds.ballsColliding)
  newSFX(sounds.holdBall)
  newSFX(sounds.throwBall)

  newMusic(sounds.menu)
  newMusic(sounds.game)
  newMusic(sounds.win)

  --Define quais musicas estarão em loop
  soundsBackground[1].sound:setLooping(true)
  soundsBackground[2].sound:setLooping(true)
  soundsBackground[3].sound:setLooping(true)

  --Instancia os players
  --newPlayer(x, y, w, h, s, d, speed, controlMode, spriteHold, spriteStand)
  newPlayer(450, 50, sprites.player1_hold:getWidth(), sprites.player1_hold:getHeight(), 1, "down", 250, "setas", sprites.player1_hold, sprites.player1_stand, sprites.player1_stuned)
  newPlayer(450, 650, sprites.player1_hold:getWidth(), sprites.player2_hold:getHeight(), 1, "up", 250, "wasd", sprites.player2_hold, sprites.player2_stand, sprites.player2_stuned)

  --Instancia uma bola
  --newBall(x, y, w, h, s, speed, sprite)
  --Distancia entre as bolas dentro do board
  spaceBetweenBalls = (board.w - sprites.ball_blue:getWidth()*5)/6
  for i = 1, 5 do
    newBall((spaceBetweenBalls * i) + sprites.ball_blue:getWidth()/2 + (sprites.ball_blue:getWidth()) * (i-1) + board.x, board.h + board.y + 30, sprites.ball_blue:getWidth(), sprites.ball_blue:getHeight(), 1, 250, sprites.ball_blue)
    newBall((spaceBetweenBalls * i) + sprites.ball_blue:getWidth()/2 + (sprites.ball_blue:getWidth()) * (i-1) + board.x, board.y - 30, sprites.ball_blue:getWidth(), sprites.ball_blue:getHeight(), 1, 250, sprites.ball_yellow)
  end

  --Intancia um novo botão
  --newButton(x, y, w, h, s, spriteUp, spriteDown, code)
  --Button Play
  NewButton(love.graphics.getWidth()/2 - sprites.button_up:getWidth()/2, 500, sprites.button_up:getWidth(), sprites.button_up:getHeight(), sprites.button_up, sprites.button_down, 'StartGame()', soundFX[1].sound, "return")
  --Button Mute Music
  NewButton(love.graphics.getWidth() - sprites.button_musicOn:getWidth(), 15, sprites.button_musicOn:getWidth(), sprites.button_musicOn:getHeight(), sprites.button_musicOn, sprites.button_musicOff, 'musicMute = not musicMute', soundFX[1].sound, "m")
  --Button Mute Audio
  NewButton(love.graphics.getWidth() - sprites.button_soundOn:getWidth(), 15 + sprites.button_musicOn:getHeight(), sprites.button_soundOn:getWidth(), sprites.button_soundOn:getHeight(), sprites.button_soundOn, sprites.button_soundOff, 'SFXMute = not SFXMute', soundFX[1].sound, "n")
  --Button Quit
  NewButton(-100, 15, sprites.button_up:getWidth(), sprites.button_up:getHeight(), sprites.button_up, sprites.button_down, 'love.event.quit(exitstatus)', soundFX[1].sound, "escape")
  --Button Back
  NewButton(-80, love.graphics.getHeight() - sprites.button_up:getHeight() - 5, sprites.button_up:getWidth(), sprites.button_up:getHeight(), sprites.button_up, sprites.button_down, 'gameState = "Menu"', soundFX[1].sound, "escape")
end


function love.update(dt)
  joysticks = love.joystick.getJoysticks()
  --Estão fora dos GameStates os updates que rodam durante todo o jogo
  updateAudios()

  if gameState == "Menu" then

    soundFX[2].sound:stop()
    soundFX[3].sound:stop()

    --Coisas que são atualizadas durante o menu
    UpdateButton(buttons[1])
    UpdateButton(buttons[2])
    UpdateButton(buttons[3])
    UpdateButton(buttons[4])

    soundsBackground[3].sound:stop()
    soundsBackground[2].sound:stop()
    soundsBackground[1].sound:play()

  elseif gameState == "HighScore" then
    --TO DO coisas que são atualizadas durante o highscore
  elseif gameState == "Game" then
    soundsBackground[1].sound:stop()

    UpdateButton(buttons[5])

    if gameSubState == "Playing" then
      love.graphics.setBackgroundColor(0.65, 0.78, 0.78, 1) --Define a cor do plano de fundo (chão)
      if currentMatch.state < 1 then --Os personagens só se movem se o jogo estiver rolando
        PlayerUpdate(dt, players[1], balls, joysticks)
        PlayerUpdate(dt, players[2], balls, joysticks)
      end

      for i = 1, 10 do
        updateBall(dt, balls[i], players, balls)
      end
      matchUpdate(dt, players, balls, currentMatch)
    elseif gameSubState == "Paused" then
      --TODO
    end
  end
end

function love.draw()
  --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
  if gameState == "Menu" then
    --Desenha o plano de fundo
    love.graphics.draw(sprites.background_menu, sprites.background_quad, 0, 0)

    love.graphics.setFont(titleFont)
    love.graphics.setColor(0, 0, 0, 1)
    --love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    love.graphics.printf("Kenney Wars", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    --Prepara a font para escrever os creditos
    love.graphics.setColor(math.random(0, 1), math.random(0, 1), math.random(0, 1), 1)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Created by: Gabriel de Oliveira Belarmino", 0, love.graphics.getHeight() - 75, love.graphics.getWidth(), "center")
    love.graphics.printf("Special Thanks: https://www.kenney.nl/assets", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Musics by: https://freesound.org/people/Sirkoto51", 0, love.graphics.getHeight() - 25, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(buttonFont)
    love.graphics.draw(buttons[4].currentSprite, buttons[4].x, buttons[4].y)
    love.graphics.draw(buttons[3].currentSprite, buttons[3].x, buttons[3].y)
    love.graphics.draw(buttons[2].currentSprite, buttons[2].x, buttons[2].y)
    love.graphics.draw(buttons[1].currentSprite, buttons[1].x, buttons[1].y)
    --Define a cor principal para preto antes de escrever JOGAR
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("JOGAR", buttons[1].x, buttons[1].y + buttons[1].h/2 - buttonFont:getHeight()/2, buttons[1].w, "center")
    love.graphics.printf("SAIR", buttons[4].x + 50, buttons[4].y + buttons[4].h/2 - buttonFont:getHeight()/2 - 3, buttons[1].w, "center")

    --Volta a cor principal para branco (Assim tudo fica bem)
    love.graphics.setColor(1, 1, 1, 1)
  elseif gameState == "HighScore" then
    --TO DO coisas que são desenhadas durante o highscore
  elseif gameState == "Game" then
    love.graphics.setColor(0.45, 0.58, 0.58, 1)
    love.graphics.rectangle("fill", board.x, board.y -60 , board.w, board.h + 120)
    love.graphics.rectangle("fill", board.x + 825, board.y -60 , board.w, board.h + 120)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(board.sprite, board.x, board.y)

    love.graphics.draw(sprites.tribune, 40, 350, math.rad(-90), 1.3, 1.3, sprites.tribune:getWidth()/2, sprites.tribune:getHeight()/2)
    love.graphics.draw(sprites.tribune, 860, 350, math.rad(90), 1.3, 1.3, sprites.tribune:getWidth()/2, sprites.tribune:getHeight()/2)

    --Desenha o relogio do jogo
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 10, 10, 160, 40 )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(buttonFont)
    love.graphics.printf("Time: " .. math.ceil(currentMatch.time), 10, 13, 160, "center")

    --Desenha o placar de rounds do jogo
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 730, 10, 160, 40 )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(buttonFont)
    love.graphics.print(currentMatch.rounds1 , 780, 13)
    love.graphics.print(currentMatch.rounds2 , 855, 13)
    love.graphics.draw(sprites.player1_icon, 740, 13, nil, .15, .15)
    love.graphics.draw(sprites.player2_icon, 815, 13, nil, .15, .15)

    love.graphics.draw(buttons[5].currentSprite, buttons[5].x, buttons[5].y) --Desenha o botão de Back
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("UOLTAR", buttons[5].x + 40, buttons[5].y + buttons[5].h/2 - buttonFont:getHeight()/2 - 3, buttons[5].w, "center")
    love.graphics.setColor(1, 1, 1, 1)

    if currentMatch.state == 1 then
      --Escreve na tela o nome do vencedor do round
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("fill", 370, 300, 160, 100)
      love.graphics.rectangle("fill", 205, 500, 490, 40)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setFont(buttonFont)
      if currentMatch.roundWinner ~= "Empate" then
        love.graphics.printf(currentMatch.roundWinner .. " Venceu o round", 370, 308, 160, "center")
      else
        love.graphics.printf("\nEmpate", 370, 300, 160, "center")
      end
      love.graphics.printf("Aperte [Enter] para jogar novamente", 205, 504, 490, "center")
    end

    if currentMatch.winner ~= "" then
      --Escreve na tela o nome do vencedor do jogo
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("fill", 370, 310, 160, 80)
      love.graphics.rectangle("fill", 205, 500, 490, 40)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setFont(buttonFont)
      love.graphics.printf(currentMatch.winner .. " Venceu", 370, 318, 160, "center")
      love.graphics.printf("Aperte [Enter] para jogar novamente", 205, 504, 490, "center")
      love.graphics.draw(currentMatch.spriteWinner, love.graphics.getWidth()/2, 200, nil, .5, .5, currentMatch.spriteWinner:getWidth()/2, currentMatch.spriteWinner:getHeight()/2)
    end

    --Desenha todas as bolas criadas
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    for i = 1, 10 do
      love.graphics.draw(balls[i].sprite, balls[i].x, balls[i].y, nil, balls[i].s, balls[i].s, balls[i].w/2, balls[i].h/2)
      love.graphics.setFont(debugFont)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.printf("Ball"..i.. " X: "..math.ceil(balls[i].x).. " Y: "..math.ceil(balls[i].y).. " moving: "..tostring(balls[i].isMoving).. " overlapping: "..tostring(balls[i].isOverlapping), 1050, 50 + i * 50, love.graphics.getWidth(), "left")
      love.graphics.setFont(gameFont)
      love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(players[1].sprite, players[1].x, players[1].y, players[1].rotation, players[1].s, players[1].s, players[1].w/2, players[1].h/2)
    love.graphics.draw(players[2].sprite, players[2].x, players[2].y, players[2].rotation, players[2].s, players[2].s, players[2].w/2, players[2].h/2)

    --HARDCODE
    for i = 1, 2 do
      if players[i].emotion ~= "" then
        if players[2].emotion == "Stuned" then
          love.graphics.draw(sprites.emote_Stuned, players[2].x + players[2].w/2, players[2].y - sprites.emote_Stuned:getHeight()/2, nil, 1, 1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        elseif players[2].emotion == "Happy" then
          love.graphics.draw(sprites.emote_Happy, players[2].x + players[2].w/2, players[2].y - sprites.emote_Stuned:getHeight()/2, nil, 1, 1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        elseif players[2].emotion == "Angry" then
          love.graphics.draw(sprites.emote_Angry, players[2].x + players[2].w/2, players[2].y - sprites.emote_Stuned:getHeight()/2, nil, 1, 1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        end

        if players[1].emotion == "Stuned" then
          love.graphics.draw(sprites.emote_Stuned, players[1].x + players[1].w/2, players[1].y + sprites.emote_Stuned:getHeight()/2, nil, 1, -1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        elseif players[1].emotion == "Happy" then
          love.graphics.draw(sprites.emote_Happy, players[1].x + players[1].w/2, players[1].y + sprites.emote_Stuned:getHeight()/2, nil, 1, -1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        elseif players[1].emotion == "Angry" then
          love.graphics.draw(sprites.emote_Angry, players[1].x + players[1].w/2, players[1].y + sprites.emote_Stuned:getHeight()/2, nil, 1, -1, sprites.emote_Stuned:getWidth(), sprites.emote_Stuned:getHeight())
        end
      end
    end
  end
end

function StartGame()
  --Intancia uma nova partida
  resetBalls(balls)
  resetPlayers(players)
  newMatch()
  currentMatch = matchs[table.getn(matchs)]
  gameState = "Game"
  soundFX[2].sound:stop()
  soundFX[2].sound:play()
end

function love.keypressed(key, scancode, isrepeat)
  keyPressed = key

  if gameState == "Game" and not players[1].stuned and not players[2].stuned then
    -- Verifica se o player 1 apertou o botão para pegar ou soltar a bola
    if key == "kp1" then
      if not players[1].isHolding then
        Hold(balls, players[1])
      elseif players[1].isHolding then
        Throw(players[1])
      end
    end

    -- Verifica se o player 2 apertou o botão para pegar ou soltar a bola
    if key == "space" then
      if not players[2].isHolding then
        Hold(balls, players[2])
      elseif players[2].isHolding then
        Throw(players[2])
      end
    end
  end
end

function love.keyreleased(key, scancode, isrepeat)
    keyPressed = ""
end

function love.joystickpressed(joystick,button)

  -- ATENCÃO HARDCODE PARA JOGAR COM OS CONTROLES SERA SUBSTITUIDOS PELAS VARIAVEIS CORRETAS
  if button == 8 then
    keyPressed = "return"
  end

  if button == 7 then
    keyPressed = "escape"
  end

  if gameState == "Game" and not players[1].stuned and not players[2].stuned then
    if button == 1 then
      -- Verifica se o player 1 apertou o botão para pegar ou soltar a bola
      if joystick == joysticks[2] then
        if not players[1].isHolding then
          Hold(balls, players[1])
        elseif players[1].isHolding then
          Throw(players[1])
        end
      end

      -- Verifica se o player 2 apertou o botão para pegar ou soltar a bola
      if joystick == joysticks[1] then
        if not players[2].isHolding then
          Hold(balls, players[2])
        elseif players[2].isHolding then
          Throw(players[2])
        end
      end
    end
  end
end

function love.joystickreleased(joystick, button)
  keyPressed = ""
end
