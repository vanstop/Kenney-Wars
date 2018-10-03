function newSFX(sound)
  local SFX = {}
  SFX.sound = sound

  table.insert(soundFX, SFX)
end

function newMusic(sound)
  local music = {}
  music.sound = sound

  table.insert(soundsBackground, music)
end

function updateAudios()
  --Define o volume para todas os audios presentes no jogo
  for i = 1, #soundFX do
    if SFXMute then
      soundFX[i].sound:setVolume(0)
    else
      soundFX[i].sound:setVolume(SFXVolume)
    end
  end
  --Define o volume para todas as musicas presentes no jogo
  for i = 1, #soundsBackground do
    if musicMute then
      soundsBackground[i].sound:setVolume(0)
    else
      soundsBackground[i].sound:setVolume(musicVolume)
    end
  end
end
