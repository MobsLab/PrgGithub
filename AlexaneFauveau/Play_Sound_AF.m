%% Code pour jouer les sons

% Ouvrir les différents fichier audio 
[Orage, FsO] = audioread('orage_70dB 1.wav');
[Ramps_down, FsRd] = audioread('Ramps_down7050_12kHz 1.wav');
[Ramps_up, FsRu] = audioread('Ramps_up5070_12kHz 1.wav');
[Sin20, FsS20] = audioread('Sin20Hz_12kHz_70dB 1.wav');
[Sin80, FsS80] = audioread('Sin80Hz_12kHz_70dB 1.wav');
[Tono, FsT] = audioread('Tono_70dB_12kHz 1.wav');
[WN, FsW] = audioread('WN_70dB 1.wav');
% 
t = (0:length(Orage)-1) / FsO ;
figure
plot(t, Orage*100)



% Jouer les différents sons
sound(Orage*0.1, FsO)
pause(1)
sound(Orage*0.5, FsO)
pause(1)
sound(Orage*0.75, FsO)
pause(1)
sound(Orage*1, FsO)
pause(1)
sound(Orage*1.5, FsO)
pause(1)
sound(Orage*2, FsO)
pause(1)
sound(Orage*2.5, FsO)
pause(1)
sound(Orage*3, FsO)
pause(1)
sound(Orage*3.5, FsO)
pause(1)
sound(Orage*4, FsO)
pause(1)
sound(Orage*5, FsO)
pause(1)
sound(Orage*6, FsO)
pause(1)
sound(Orage*7, FsO)
pause(1)
sound(Orage*8, FsO)
pause(1)
sound(Orage*9, FsO)
pause(1)
sound(Orage*10, FsO)
pause(1)
sound(Orage*15, FsO)
pause(1)
sound(Orage*20, FsO)
pause(2)

sound(Ramps_down*0.1, FsRd)
pause(1)
sound(Ramps_down*0.5, FsRd)
pause(1)
sound(Ramps_down*0.75, FsRd)
pause(1)
sound(Ramps_down*1, FsRd)
pause(1)
sound(Ramps_down*1.5, FsRd)
pause(1)
sound(Ramps_down*2, FsRd)
pause(1)
sound(Ramps_down*2.5, FsRd)
pause(1)
sound(Ramps_down*3, FsRd)
pause(1)
sound(Ramps_down*3.5, FsRd)
pause(1)
sound(Ramps_down*4, FsRd)
pause(1)
sound(Ramps_down*5, FsRd)
pause(1)
sound(Ramps_down*6, FsRd)
pause(1)
sound(Ramps_down*7, FsRd)
pause(1)
sound(Ramps_down*8, FsRd)
pause(1)
sound(Ramps_down*9, FsRd)
pause(1)
sound(Ramps_down*10, FsRd)
pause(1)
sound(Ramps_down*15, FsRd)
pause(1)
sound(Ramps_down*20, FsRd)
pause(2)

sound(Ramps_up*0.1, FsRu)
pause(1)
sound(Ramps_up*0.5, FsRu)
pause(1)
sound(Ramps_up*0.75, FsRu)
pause(1)
sound(Ramps_up*1, FsRu)
pause(1)
sound(Ramps_up*1.5, FsRu)
pause(1)
sound(Ramps_up*2, FsRu)
pause(1)
sound(Ramps_up*2.5, FsRu)
pause(1)
sound(Ramps_up*3, FsRu)
pause(1)
sound(Ramps_up*3.5, FsRu)
pause(1)
sound(Ramps_up*4, FsRu)
pause(1)
sound(Ramps_up*5, FsRu)
pause(1)
sound(Ramps_up*6, FsRu)
pause(1)
sound(Ramps_up*7, FsRu)
pause(1)
sound(Ramps_up*8, FsRu)
pause(1)
sound(Ramps_up*9, FsRu)
pause(1)
sound(Ramps_up*10, FsRu)
pause(1)
sound(Ramps_up*15, FsRu)
pause(1)
sound(Ramps_up*20, FsRu)
pause(2)


sound(Sin20*0.1, FsS20)
pause(1)
sound(Sin20*0.5, FsS20)
pause(1)
sound(Sin20*0.75, FsS20)
pause(1)
sound(Sin20*1, FsS20)
pause(1)
sound(Sin20*1.5, FsS20)
pause(1)
sound(Sin20*2, FsS20)
pause(1)
sound(Sin20*2.5, FsS20)
pause(1)
sound(Sin20*3, FsS20)
pause(1)
sound(Sin20*3.5, FsS20)
pause(1)
sound(Sin20*4, FsS20)
pause(1)
sound(Sin20*5, FsS20)
pause(1)
sound(Sin20*6, FsS20)
pause(1)
sound(Sin20*7, FsS20)
pause(1)
sound(Sin20*8, FsS20)
pause(1)
sound(Sin20*9, FsS20)
pause(1)
sound(Sin20*10, FsS20)
pause(1)
sound(Sin20*15, FsS20)
pause(1)
sound(Sin20*20, FsS20)
pause(2)


sound(Sin80*0.1, FsS80)
pause(1)
sound(Sin80*0.5, FsS80)
pause(1)
sound(Sin80*0.75, FsS80)
pause(1)
sound(Sin80*1, FsS80)
pause(1)
sound(Sin80*1.5, FsS80)
pause(1)
sound(Sin80*2, FsS80)
pause(1)
sound(Sin80*2.5, FsS80)
pause(1)
sound(Sin80*3, FsS80)
pause(1)
sound(Sin80*3.5, FsS80)
pause(1)
sound(Sin80*4, FsS80)
pause(1)
sound(Sin80*5, FsS80)
pause(1)
sound(Sin80*6, FsS80)
pause(1)
sound(Sin80*7, FsS80)
pause(1)
sound(Sin80*8, FsS80)
pause(1)
sound(Sin80*9, FsS80)
pause(1)
sound(Sin80*10, FsS80)
pause(1)
sound(Sin80*15, FsS80)
pause(1)
sound(Sin80*20, FsS80)
pause(2)


sound(Tono*0.1, FsT)
pause(1)
sound(Tono*0.5, FsT)
pause(1)
sound(Tono*0.75, FsT)
pause(1)
sound(Tono*1, FsT)
pause(1)
sound(Tono*1.5, FsT)
pause(1)
sound(Tono*2, FsT)
pause(1)
sound(Tono*2.5, FsT)
pause(1)
sound(Tono*3, FsT)
pause(1)
sound(Tono*3.5, FsT)
pause(1)
sound(Tono*4, FsT)
pause(1)
sound(Tono*5, FsT)
pause(1)
sound(Tono*6, FsT)
pause(1)
sound(Tono*7, FsT)
pause(1)
sound(Tono*8, FsT)
pause(1)
sound(Tono*9, FsT)
pause(1)
sound(Tono*10, FsT)
pause(1)
sound(Tono*15, FsT)
pause(1)
sound(Tono*20, FsT)
pause(2)

sound(WN*0.1, FsW)
pause(1)
sound(WN*0.5, FsW)
pause(1)
sound(WN*0.75, FsW)
pause(1)
sound(WN*1, FsW)
pause(1)
sound(WN*1.5, FsW)
pause(1)
sound(WN*2, FsW)
pause(1)
sound(WN*2.5, FsW)
pause(1)
sound(WN*3, FsW)
pause(1)
sound(WN*3.5, FsW)
pause(1)
sound(WN*4, FsW)
pause(1)
sound(WN*5, FsW)
pause(1)
sound(WN*6, FsW)
pause(1)
sound(WN*7, FsW)
pause(1)
sound(WN*8, FsW)
pause(1)
sound(WN*9, FsW)
pause(1)
sound(WN*10, FsW)
pause(1)
sound(WN*15, FsW)
pause(1)
sound(WN*20, FsW)
pause(2)

