% 14.02.2016
% code donné par Sophie pour récupéré l'information "temps des stim" pour
% les souris ayant subi la rampe sur une journée (stim à différentes
% fréquences pendant le sommeil - janvier 2017)
clear all

% FileName{1}='/media/DataMOBS59/OptoSleepStim/Mouse363/20161201';
% FileName{2}='/media/DataMOBS59/OptoSleepStim/Mouse363/20161201';
% FileName{3}='/media/DataMOBS59/OptoSleepStim/Mouse459/20161123';
% FileName{4}='/media/DataMOBS59/OptoSleepStim/Mouse458/20161117';
% FileName{5}='/media/DataMOBS59/OptoSleepStim/Mouse458/20161116';
% 
% FileName{6}='/media/DataMOBS60/OptoSleepStim/Mouse465/20170126/Mouse465-OptoSleepstimramp_170126_082254';
% FileName{7}='/media/DataMOBS60/OptoSleepStim/Mouse465/20170127/Mouse465-OptoSleepstimramp_170127_084632';
% 
% FileName{8}='/media/MOBS67/Mouse466/20170130';
% FileName{9}='/media/MOBS67/Mouse466/20170131/Mouse466OptoRamp_170131_090353';

% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';

% FileName={
% '/media/DataMOBs61/Mouse496/20170404/FEAR-Mouse-496-04042017';  
% '/media/DataMOBs61/Mouse496/20170407/FEAR-Mouse-496-07042017';
% '/media/DataMOBs61/Mouse497/20170409/FEAR-Mouse-497-09042017';
% '/media/DataMOBs61/Mouse497/20170405/FEAR-Mouse-497-05042017';
% };

FileName={
% not used for these data in fact
'/media/DataMOBs57/Fear-March2017/Mouse-498/20170309-EXT-24-laser13/FEAR-Mouse-498-09032017';
'/media/DataMOBs57/Fear-March2017/Mouse-498/20170310-EXT-48-laser13/FEAR-Mouse-498-10032017';
'/media/DataMOBs57/Fear-March2017/Mouse-499/20170309-EXT-24-laser13/FEAR-Mouse-499-09032017';
'/media/DataMOBs57/Fear-March2017/Mouse-499/20170310-EXT-48-laser13/FEAR-Mouse-499-10032017';
};
% FileName={
% '/media/DataMOBs61/Mouse-540/FEAR-Mouse-540-21092017';  
% '/media/DataMOBs61/Mouse-542/FEAR-Mouse-542-20092017';
% '/media/DataMOBs61/Mouse-543/FEAR-Mouse-543-19092017';
% };

if 0
for mm=1:length(FileName)
    mm
    clear StimInfo
    cd(FileName{mm})
    load('LFPData/DigInfo4.mat')
    LaserOn=thresholdIntervals(DigTSD,0.9,'Direction','Above');
    LaserOn=mergeCloseIntervals(LaserOn,5*1e4);
    StimInfo.StartTime=Start(LaserOn,'s');
    StimInfo.StopTime=Stop(LaserOn,'s');
    dt=median(diff(Range(DigTSD,'s')));

    for k=1:length(StimInfo.StartTime)
        dattemp=Data(Restrict(DigTSD,subset(LaserOn,k)));
        StimInfo.Freq(k,1)=round(1./(median(diff(find(diff(dattemp)==1)))*dt));
    end
    
    save('StimInfo.mat','StimInfo', 'LaserOn')
end
end

% for Mice 540,542,543 digital info is in behavResources
% DIG1= start and end of recording
% DIG4 = end of recording
% DIG5 = ends of stimulation
% DIG7 = signals end of each bip (depends on stimulation frequency)
% DIG15 = signals start of each bip (depends on stimulation frequency)
for mm=1:length(FileName)
    mm
    clear StimInfo
    cd(FileName{mm})
    load('behavResources.mat', 'DIG5','DIG7','DIG15')

    A=Range(DIG15);
    ind2bin=(diff(A)<15000);
    Ac=A;
    Ac([logical(0);ind2bin])=[];

    B=Range(DIG5); % le nb de point entre A et B est different de qq point -> nécessaire d'enlever les points de B qui sont un TTL doublé
    ind2binB=(diff(B)<20000);%ind2binB=(diff(B)<2000);
    Bc=B;
    Bc([logical(0);ind2binB])=[];
    Bc(1)=[];
    try
    LaserOn=intervalSet(Ac,Bc);
    StimInfo.StartTime=Start(LaserOn,'s');
    StimInfo.StopTime=End(LaserOn,'s');
    catch
        keyboard % for manual corretion of vectors (removal of points)
        
        % for 543
        % Bc(167)=[];
    end

for k=1:length(Start(LaserOn))
    
    StartBip=Range(Restrict(DIG15,subset(LaserOn,k)));
    EndBip=Range(Restrict(DIG7,subset(LaserOn,k)));

    dt=median(EndBip-StartBip)*1E-4;
    StimInfo.Freq(k,1)=round(1./(dt*2));
end
    save('StimInfo.mat','StimInfo', 'LaserOn')
end

if 0
%% bricolag qui ne semble pas fonctionner tres bien
for mm=1:length(FileName)
    mm
    clear StimInfo
    cd(FileName{mm})
    load('behavResources.mat', 'DIG5','DIG7','DIG15')
    StimInfo.StopTimeTTLfromDIG=Range(DIG5);
    StimInfo.StopTimeTTLfromDIG(1)=[];    
    
    
    StimInfo.StartTime=[];
    StimInfo.StopTime=[];
    a=1;
    for k=1:length(StimInfo.StopTimeTTLfromDIG)
        Interval_OI=intervalSet(StimInfo.StopTimeTTLfromDIG(k)-310000, StimInfo.StopTimeTTLfromDIG(k));
        StartBip=Range(Restrict(DIG15,Interval_OI));
        EndBip=Range(Restrict(DIG7,Interval_OI));
        
        if ~isempty(StartBip)&~isempty(EndBip)
        
            if length(StartBip)==length(EndBip)
                LaserOn=intervalSet(StartBip,EndBip);

            elseif  EndBip(1)-StartBip(1)<400 % if negatif or if difference > 50ms (20Hz), aberrant point in EndBip
                EndBip(1)=[];
                if length(StartBip)==length(EndBip)
                    LaserOn=intervalSet(StartBip,EndBip);
                else
                    keyboard
                end
            else
                    keyboard
            end
            
            try
                StimInfo.StartTime=[StimInfo.StartTime;StartBip(1)];
                StimInfo.StopTime=[StimInfo.StopTime;EndBip(1)];
            catch 
                keyboard
            end
             dt=median(EndBip-StartBip)*1E-4;
             StimInfo.Freq(a,1)=round(1./(dt*2));
             a=a+1;
        else
            keyboard
            
        end
    end
    
%     StartBip=Range(DIG15);
%     EndBip=Range(DIG7);
%     LaserOn=intervalSet(StartBip,EndBip);
%     LaserOn=mergeCloseIntervals(LaserOn,1*1e4);
%     StimInfo.StartTime=Start(LaserOn,'s');
%     StimInfo.StopTime=Stop(LaserOn,'s');
% 
%     dt=median(diff(Range(DigTSD,'s')));
% 
%     for k=1:length(StimInfo.StartTime)
%         dattemp=Data(Restrict(DigTSD,subset(LaserOn,k)));
%         StimInfo.Freq(k,1)=round(1./(median(diff(find(diff(dattemp)==1)))*dt));
%     end
StimInfo.StartTime=StimInfo.StartTime*1E-4;
StimInfo.StopTime=StimInfo.StopTime*1E-4;
    save('StimInfo.mat','StimInfo', 'LaserOn')
end
end