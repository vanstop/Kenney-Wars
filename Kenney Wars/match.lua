function newMatch()
  local match = {}
  match.round = 0 -- Rounds 0 to 2
  match.time = 60 -- 60 seconds
  match.points1 = 0 -- Balls in the Up Side
  match.points2 = 0 -- Balls in the Down Side
  match.rounds1 = 0 -- Rounds won by player 1
  match.rounds2 = 0 -- Rounds won by player 2
  match.state = 0 -- 0 To playing 1 to time between rounds 2 match is over
  match.winner = "" -- Vencedor da partida
  match.roundWinner = "" -- Vencedor do round
  match.spriteWinner = "" --Armazena o sprite do vencedor da partida

  table.insert(matchs, match)
end


function matchUpdate(dt, players, balls, match)
  if match.state == 0 then
    soundsBackground[2].sound:play()
    pointsUpdate(balls, match) -- Atualiza a pontuação

    -- Verifica se um dos players venceu por "Nocaute"
    if match.points1 == 10 then
      match.state = 1
      match.roundWinner = "Player 1"
      match.rounds1 = match.rounds1 + 1
    elseif match.points2 == 10 then
      match.state = 1
      match.roundWinner = "Player 2"
      match.rounds2 = match.rounds2 + 1
    end

    -- Quando o tempo acaba verifica quem foi o vencedor
    if match.time <= 0 then
      if match.points1 > match.points2 then
        match.state = 1
        match.roundWinner = "Player 1"
        match.rounds1 = match.rounds1 + 1
      elseif match.points1 < match.points2 then
        match.state = 1
        match.roundWinner = "Player 2"
        match.rounds2 = match.rounds2 + 1
      else
        --Empate
        match.state = 1
        match.roundWinner = "Empate"
      end
    end

    --Atualiza tempo
    match.time = match.time - dt

  elseif match.state == 1 then

    if keyPressed == "return" then -- Se apertar Enter o jogo reinicia
      resetMatch(balls, players, match) -- Junto com as linhas de baixo reseta a partida
    end

    --Verifica se alguem venceu o jogo
    if match.rounds1 >= 2 and match.rounds1 > match.rounds2 then
      --Player 1 venceu
      match.winner = "Player 1"
      match.spriteWinner = sprites.player1_medal
      players[1].emotion = "Happy"
      players[2].emotion = "Angry"
      match.state = 2
    elseif match.rounds2 >= 2 and match.rounds2 > match.rounds1 then
      --Player 2 venceu
      match.winner = "Player 2"
      match.spriteWinner = sprites.player2_medal
      players[2].emotion = "Happy"
      players[1].emotion = "Angry"
      match.state = 2
      soundsBackground[2].sound:stop()
      soundFX[3].sound:play()
      soundsBackground[3].sound:play()
    end

  elseif match.state == 2 then
    -- Fim da partida
    if keyPressed == "return" then -- Se apertar Enter o jogo reinicia
      resetMatch(balls, players, match) -- Junto com as linhas de baixo reseta a partida
      match.rounds1 = 0
      match.rounds2 = 0
    end
  end
end

function pointsUpdate(balls, match)
  match.points1 = 0
  match.points2 = 0
  for i,b in ipairs(balls) do
    if b.y == 45 then
      match.points2 = match.points2 + 1
    elseif b.y == 655 then
      match.points1 = match.points1 + 1
    end
  end
end

function resetBalls(balls) -- Reseta posição das bolas
  for i = 1, 5 do
    balls[i].x = (spaceBetweenBalls * i) + sprites.ball_blue:getWidth()/2 + (sprites.ball_blue:getWidth()) * (i-1) + board.x
    balls[i].y = board.h + board.y + 30
    balls[i].isMoving = false
    balls[i].isOverlapping = false

    balls[i+5].x = (spaceBetweenBalls * i) + sprites.ball_blue:getWidth()/2 + (sprites.ball_blue:getWidth()) * (i-1) + board.x
    balls[i+5].y = board.y - 30
    balls[i+5].isMoving = false
    balls[i+5].isOverlapping = false
  end
end

function resetPlayers(players) -- Reseta posição dos players
  players[1].y = 50
  players[1].emotion = ""
  players[1].stuned = false
  players[2].y = 650
  players[2].emotion = ""
  players[2].stuned = false
end

function resetMatch(balls, players, match) -- Prepara a partida para um novo round
  resetBalls(balls)
  resetPlayers(players)
  match.winner = ""
  match.time = 60
  match.state = 0
  soundsBackground[3].sound:stop()
  soundFX[2].sound:stop()
  soundFX[2].sound:play()
end
