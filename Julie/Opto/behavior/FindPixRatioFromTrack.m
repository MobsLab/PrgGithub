
% FindPixRatioFromTrack.m 
% 17.08.2017

% dataset= FearJuly2017
%%%%%%%%%%%%%%%%%  EXT-24  %%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-27072017-01-EXT-24')
load Behavior.mat
subplot(141)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-27072017-01-EXT-24')
load Behavior.mat
subplot(142)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-27072017-01-EXT-24')
load Behavior.mat
subplot(143)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-27072017-01-EXT-24')
load Behavior.mat
subplot(144)
plot(PosMat(:,2), PosMat(:,3))
% 
% ginput
% 
% ans =
% 
%    11.3142   31.0609
%    42.4407   30.5443
% 
% ginput
% 
% ans =
% 
%     7.6186   19.6956
%    27.9743   19.5111
% 
% ginput
% 
% ans =
% 
%     7.7174   19.1421
%    28.3696   19.4188
% 
% ginput
% 
% ans =
% 
%     7.4209   17.1125
%    27.5791   16.7435


27.9743-7.6186 = 20.3557

28.3696-7.7174 = 20.6522

27.5791 -7.4209  = 20.1582

42.4407-11.3142=31.1265
pixratio=31.1/20.38;
  1.5260
  
  clear  
cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-27072017-01-EXT-24')
load Behavior.mat
save Behavior_before_correction
  Mov=Data(Movtsd);
  Movcorrected=Mov/(  1.526*  1.526);
  figure, plot(Movcorrected)
  figure, hist(Movcorrected,1000)
  Movtsd=tsd(Range(Movtsd),Movcorrected);
  save Behavior
  
  

%%%%%%%%%%%%%%%%%  EXT-48  %%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-28072017-01-EXT-48')
load Behavior.mat
subplot(141)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-28072017-01-EXT-48')
load Behavior.mat
subplot(142)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-28072017-01-EXT-48')
load Behavior.mat
subplot(143)
plot(PosMat(:,2), PosMat(:,3))


cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-28072017-01-EXT-48')
load Behavior.mat
subplot(144)
plot(PosMat(:,2), PosMat(:,3))


%  ginput
% 
% ans =
% 
%     6.6026   10.5801
%    27.2070   10.2533
% 
% ginput
% 
% ans =
% 
%     6.6026   10.7435
%    27.2985   11.1520
% 
% ginput
% 
% ans =
% 
%     7.2436    7.8840
%    28.1227    6.7402
% 
% ginput
% 
% ans =
% 
%   149.4505  242.1569
%   619.7802  234.3137
% 
% 619.8-149.5
% 
% ans =
% 
%   470.3000
% 
% 27.3-6.6
% 
% ans =
% 
%    20.7000

pixratio=470.3/20.7;
  22.7198
  
clear  
cd('/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-28072017-01-EXT-48')
load Behavior.mat
save Behavior_before_correction
  Mov=Data(Movtsd);
  Movcorrected=Mov/(22.7*22.7);
  figure, plot(Movcorrected)
  figure, hist(Movcorrected,1000)
  Movtsd=tsd(Range(Movtsd),Movcorrected);
  save Behavior
  
  
  
  
  
  