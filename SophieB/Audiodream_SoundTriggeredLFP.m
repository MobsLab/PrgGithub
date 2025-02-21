
clear all
cd /media/nas7/BathellierLabData/SleepSounds_data
AllElements = dir;
num = 1;
count = 1;
for el = 1:length(AllElements)
    if AllElements(el).isdir ==1 & not(isempty(strfind(AllElements(el).name,'M')))
        MouseFolder{num} = AllElements(el).name;
        num = num+1;
    end
end

for mm = 1 : length(MouseFolder)
    cd(['/media/nas7/BathellierLabData/SleepSounds_data/',MouseFolder{mm}])
    AllElements = dir;
    for el = 1:length(AllElements)
        if AllElements(el).isdir ==1 & not(isempty(strfind(AllElements(el).name,'2023')))
            cd(['/media/nas7/BathellierLabData/SleepSounds_data/',MouseFolder{mm},filesep,AllElements(el).name])
            
            sync = readNPY('TTL/timestamps.npy');
            starttime = 0;%sync(1);
            
            channel_states = readNPY('TTL/states.npy');
            full_words = readNPY('TTL/full_words.npy');
            timestamps = readNPY('TTL/timestamps.npy');
            
            TTLtypes = (unique(abs(channel_states)));
            if sum(ismember(TTLtypes,3))>0
                clear TTLInfo evt
                dig = 3;
                % ONOFF
                id_on = find(channel_states == dig);
                
                TTLInfo{dig} = double((timestamps(id_on) - starttime));
                
                
                if length(TTLInfo{dig})>2000 & exist('ChannelsToAnalyse/AuCx.mat')>0
                    GoodFolder{count} = cd;
                    count = count +1;
                end
            end
        end
    end
end
% figure
% tiledlayout(5,8, 'Padding', 'none', 'TileSpacing', 'compact'); 


for mm = 1:length(GoodFolder)
%     nexttile
    cd(GoodFolder{mm})
    sync = readNPY('TTL/timestamps.npy');
    starttime = 0;%sync(1);
    
    channel_states = readNPY('TTL/states.npy');
    full_words = readNPY('TTL/full_words.npy');
    timestamps = readNPY('TTL/timestamps.npy');
    
    TTLtypes = (unique(abs(channel_states)));
    id_on = find(channel_states == dig);
    ttl = ts(double((timestamps(id_on) - starttime))*1e4);
    
    try,load('ChannelsToAnalyse/ThetaREM.mat')
    catch,
        try
        load('ChannelsToAnalyse/dHPC_rip.mat')
        catch
        load('ChannelsToAnalyse/dHPC_deep.mat')
        end
    end
    load(['LFPData/LFP',num2str(channel),'.mat'])
    try,load('SleepScoring_OBGamma.mat')
    catch
        load('SleepScoring_EMG.mat')
    end
    [M,T] = PlotRipRaw(LFP, Range(Restrict(ttl,Wake),'s'), [-1500 1500], 0,0,1);
%     plot(M(:,1),M(:,2))
    EvPot{1}(mm,:) = M(:,2);
    [M,T] = PlotRipRaw(LFP, Range(Restrict(ttl,SWSEpoch),'s'), [-1500 1500], 0,0,1);
    EvPot{2}(mm,:) = M(:,2);
%     hold on
%     plot(M(:,1),M(:,2))
%     [str,tok] = strsplit(GoodFolder{mm},'M');
%     title(str{2}(1:end-9))
%     
    LFP = tsd(Range(LFP),zscore(Data(LFP)));
    [M,T] = PlotRipRaw(LFP, Range(Restrict(ttl,Wake),'s'), [-1500 1500], 0,0,1);
    EvPot_Zsc{1}(mm,:) = M(:,2);
    [M,T] = PlotRipRaw(LFP, Range(Restrict(ttl,SWSEpoch),'s'), [-1500 1500], 0,0,1);
    EvPot_Zsc{2}(mm,:) = M(:,2);
    
    
end

figure
A = ((EvPot_Zsc{1}(:,500:3500)')');
subplot(5,2,[1,3,5,7])
for ii = 1:size(A,1)
    plot(M(500:3500,1),A(ii,:)+1*ii,'k')
    hold on
end
subplot(5,2,9)
plot(M(500:3500,1),A,'color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),nanmean(A),'color','k','linewidth',3)


A = ((EvPot_Zsc{2}(:,500:3500)')');
subplot(5,2,[1,3,5,7]+1)
for ii = 1:size(A,1)
    plot(M(500:3500,1),A(ii,:)+1*ii,'k')
    hold on
end
subplot(5,2,10)
plot(M(500:3500,1),A,'color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),nanmean(A),'color','k','linewidth',3)


figure
A = (zscore(EvPot{1}(:,500:3500)')');
subplot(5,2,[1,3,5,7])
for ii = 1:size(A,1)
plot(M(500:3500,1),A(ii,:)+4*ii,'k')
hold on
end
subplot(5,2,9)
plot(M(500:3500,1),A,'color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),nanmean(A),'color','k','linewidth',3)
A = (zscore(EvPot{2}(:,500:3500)')');
subplot(5,2,[1,3,5,7]+1)
for ii = 1:size(A,1)
plot(M(500:3500,1),A(ii,:)+4*ii,'k')
hold on
end
subplot(5,2,10)
plot(M(500:3500,1),A,'color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),nanmean(A),'color','k','linewidth',3)

figure
subplot(141)
imagesc(M(500:3500,1),1:40,A-A2)
title('wake-sleep')
subplot(142)
imagesc(M(500:3500,1),1:40,abs(A-A2))
title('abs(wake-sleep)')
subplot(222)
plot(M(500:3500,1),abs(A-A2)','color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),nanmean(abs(A-A2)),'color','k','linewidth',3)
title('abs(wake-sleep)')

subplot(224)
plot(M(500:3500,1),(A-A2)','color',[0.4 0.4 0.4])
hold on
plot(M(500:3500,1),(mean(A-A2)),'color','k','linewidth',3)
title('wake-sleep')
