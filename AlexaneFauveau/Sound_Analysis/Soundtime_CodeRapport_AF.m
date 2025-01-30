% Load analog file
analog = LoadBinary('analogin.dat');
analog = sqrt((analog-mean(analog)).^2);
analog = analog(1:10:end);
analog_tsd = tsd([1/2000:1/2000:length(analog)/2000]*1e4,movmean(analog,200));

load('journal_pause_table.mat')
try
    load('start_recording.mat')
catch
    load('journal_X.mat', 'start_recording')
end
load('journal_sons_table.mat')
load('journal_sons.mat')

% Get pause time
tstart = datetime(start_recording(1:end-4),'InputFormat','dd-MM-yyyy HH:mm:ss');
try
    tpause = datetime(journal_pause_table.journal_pause3{1}(1:end-4),'InputFormat','dd-MM-yyyy HH:mm:ss');
    PauseTime = seconds(tpause - tstart);
end
tsound1 = datetime(journal_sons_table.journal_sons4{1}(1:end-4),'InputFormat','dd-MM-yyyy HH:mm:ss');

% First rough guess at sound times
% t0 = 1.292;
t0 = 0;
time_nextsound = cumsum(journal_sons_table.journal_sons6)+t0;
try
    time_nextsound(find(time_nextsound>PauseTime)) = time_nextsound(find(time_nextsound>PauseTime))...
        +  3600*2- journal_sons_table.journal_sons6(find(time_nextsound>PauseTime,1,'first')-1);
end


time_nextsound = [time_nextsound];

% figure
% for sound = 1 :length(journal_sons_table.journal_sons6)
%     subplot(6,5,sound)
%     Window = intervalSet((time_nextsound(sound)-20)*1e4,(time_nextsound(sound)+20)*1e4);
%     LittleAnalogin = Restrict(analog_tsd,Window);
%     SoundEpoch = thresholdIntervals(LittleAnalogin,20,'Direction','Above');
%     SoundEpoch = dropShortIntervals(SoundEpoch,0.3*1e4);
%     plot(Range(LittleAnalogin,'s'),Data(LittleAnalogin))
%     hold on
%     if length(Start(SoundEpoch,'s'))>0 & length(Start(SoundEpoch,'s')) <2 & DurationEpoch(SoundEpoch)
%         time_nextsound(sound) = Start(SoundEpoch,'s');
%         plot(time_nextsound(sound),100,'r*')
%     else
% %         time_nextsound(sound) = time_nextsound(sound-1) +journal_sons_table.journal_sons6(sound-1);
%         plot(time_nextsound(sound),100,'b*')
%     end
% end

% Changed 06/08/2024 by CH : To detect the sounds by difference
% to average

figure
time_nextsound_corrected = [];
for sound = 1 :length(journal_sons_table.journal_sons6)
    subplot(7,6,sound)
    Window = intervalSet((time_nextsound(sound)-200)*1e4,(time_nextsound(sound)+200)*1e4);
    LittleAnalogin = Restrict(analog_tsd,Window);
    Avg = nanmean(Data(LittleAnalogin));
    deviations = tsd(Range(LittleAnalogin), Data(LittleAnalogin - Avg));
    threshold = 3 * std(Data(LittleAnalogin));
    SoundEpoch = thresholdIntervals(deviations,threshold,'Direction','Above');
    SoundEpoch = dropShortIntervals(SoundEpoch,0.2*1e4);
    plot(Range(LittleAnalogin)/1e4, Data(LittleAnalogin))
    hold on;
    if length(Start(SoundEpoch,'s'))>0 & length(Start(SoundEpoch,'s')) <2 & DurationEpoch(SoundEpoch)>1
        time_nextsound_corrected(sound) = Start(SoundEpoch,'s');
        sounds = Restrict(LittleAnalogin, SoundEpoch);
        plot(Range(sounds)/1e4,Data(sounds),'r*');
    else
        %         time_nextsound_corrected(sound) = time_nextsound(sound);
        %         sounds = Restrict(LittleAnalogin, time_nextsound(sound));
        %         plot(Range(sounds)/1e4,Data(sounds),'g*');
        sounds = Restrict(LittleAnalogin, time_nextsound(sound));
        plot(Range(sounds)/1e4,Data(sounds),'g*');
        Ok = input('see any sound? (0/1)');
        if Ok == 1
            a = ginput(1);
            time_nextsound_corrected(sound) = a(1,1);
            clear a
        else
            time_nextsound_corrected(sound) = time_nextsound(sound);
        end
        
    end
end

TTLInfo.time_nextsound_corrected = time_nextsound_corrected';
TTLInfo.time_nextsound = time_nextsound';

% Average_diff = time_nextsound_corrected' - time_nextsound

TTLInfo.Sounds = intervalSet((time_nextsound_corrected*1e4)-2*1e4,(time_nextsound_corrected*1e4)+2*1e4);

% Load digital file
try
    digitalin = LoadBinary('digitalin.dat');
catch
    digitalin = LoadBinary('board-DIGITAL-IN-00.dat')
end
digitalin = digitalin(1:10:end);
digitalin = tsd([1/2000:1/2000:length(digitalin)/2000]*1e4,digitalin);
StartDigIn = Start(thresholdIntervals(digitalin,25,'Direction','Above'));
try
    TTLInfo.StartSession = StartDigIn(1);
catch
    StartDigIn = Start(thresholdIntervals(digitalin,0.25,'Direction','Above'));
    TTLInfo.StartSession = StartDigIn(1);
end

% TTLInfo.Sync = intervalSet(StartDigIn(2:end)*1e4,StartDigIn(2:end)*1e4+0.5*1e4);
TTLInfo.Sync = intervalSet(StartDigIn(2:end),StartDigIn(2:end)+0.5*1e4);
save('behavResources.mat','TTLInfo')


soundtype = {'dB50','dB60','dB70','dB80','Orage','RU','Tono12','Sin20','TonoWN','Sin80','Tono5','RD'};

for i = 1:length(soundtype)
    Indices.(soundtype{i}) = [];
    TTLInfo.(soundtype{i}) = [];
    TTLInfo.(strcat(soundtype{i},'Epoch')) = intervalSet([],[]);
end


f = 1;
si = 1;
se = 1;
e = 1;
o = 1;
ruwn = 1;
rdwn = 1;
twelve = 1;
sintwenty = 1;
twn = 1;
eighty = 1;
five = 1;

for i = 1:length(journal_sons)
    if journal_sons{i, 2} == 50
        Indices.dB50(f) = i;
        f = f+1;
    elseif journal_sons{i, 2} == 60
        Indices.dB60(si) = i;
        si = si+1;
    elseif journal_sons{i, 2} == 70
        Indices.dB70(se) = i;
        se = se+1;
    elseif journal_sons{i, 2} == 80
        Indices.dB80(e) = i;
        e = e+1;
    end
    if contains(journal_sons{i, 1}, 'orage')
        Indices.Orage(o) = i;
        o = o+1;
    elseif contains(journal_sons{i, 1}, 'Ramps_up_5070_WN')
        Indices.RU(ruwn) = i;
        ruwn = ruwn+1;
    elseif contains(journal_sons{i, 1}, 'Tono_70dB_12kHz')
        Indices.Tono12(twelve) = i;
        twelve = twelve+1;
    elseif contains(journal_sons{i, 1}, 'Sin20Hz_WN_70dB')
        Indices.Sin20(sintwenty) = i;
        sintwenty = sintwenty+1;
    elseif contains(journal_sons{i, 1}, 'Tono_70dB_WN')
        Indices.TonoWN(twn) = i;
        twn = twn+1;
    elseif contains(journal_sons{i, 1}, 'Ramps_down_7050_WN')
        Indices.RD(rdwn) = i;
        rdwn = rdwn+1;
    elseif contains(journal_sons{i, 1}, 'Sin80Hz_WN_70dB')
        Indices.Sin80(eighty) = i;
        eighty = eighty+1;
    elseif contains(journal_sons{i, 1}, 'Tono_70dB_5kHz.wav')
        Indices.Tono5(five) = i;
        five = five+1;
    end
end


clear f si se e o ruwn twelve sintwenty twn rdwn eighty five i

save('behavResources.mat','Indices', '-append')

start = Start(TTLInfo.Sounds);
stop = Stop(TTLInfo.Sounds);

try
    
    for i = Indices.dB50
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.dB50Epoch = union(TTLInfo.dB50Epoch, new);
    end
end

try
    
    for i = Indices.dB60
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.dB60Epoch = union(TTLInfo.dB60Epoch, new);
    end
end

try
    
    for i = Indices.dB70
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.dB70Epoch = union(TTLInfo.dB70Epoch, new);
    end
end

try
    
    for i = Indices.dB80
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.dB80Epoch = union(TTLInfo.dB80Epoch, new);
    end
end

try
    
    for i = Indices.Orage
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.OrageEpoch = union(TTLInfo.OrageEpoch, new);
    end
end
try
    
    for i = Indices.RU
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.RUEpoch = union(TTLInfo.RUEpoch, new);
    end
end

try
    
    for i = Indices.Tono12
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.Tono12Epoch = union(TTLInfo.Tono12Epoch, new);
    end
end
try
    
    for i = Indices.Sin20
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.Sin20Epoch = union(TTLInfo.Sin20Epoch, new);
    end
end

try
    
    for i = Indices.TonoWN
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.TonoWNEpoch = union(TTLInfo.TonoWNEpoch, new);
    end
end

try
    
    for i = Indices.Sin80
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.Sin80Epoch = union(TTLInfo.Sin80Epoch, new);
    end
end
try
    
    for i = Indices.Tono5
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.Tono5Epoch = union(TTLInfo.Tono5Epoch, new);
    end
end

try
    
    for i = Indices.RD
        new = intervalSet([start(i)], [stop(i)]);
        TTLInfo.RDEpoch = union(TTLInfo.RDEpoch, new);
    end
end


c = 1;
try
    for i = Indices.dB50
        TTLInfo.dB50(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.dB50 = TTLInfo.dB50(:);
end

c = 1;
try
    for i = Indices.dB60
        TTLInfo.dB60(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.dB60 = TTLInfo.dB60(:);
end

c = 1;
try
    for i = Indices.dB70
        TTLInfo.dB70(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.dB70 = TTLInfo.dB70(:);
end

c = 1;
try
    for i = Indices.dB80
        TTLInfo.dB80(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.dB80 = TTLInfo.dB80(:);
end

c = 1;
try
    for i = Indices.Orage
        TTLInfo.Orage(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.Orage = TTLInfo.Orage(:);
end

c = 1;
try
    for i = Indices.RU
        TTLInfo.RU(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.RU = TTLInfo.RU(:);
end

c = 1;
try
    for i = Indices.Tono12
        TTLInfo.Tono12(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.Tono12 = TTLInfo.Tono12(:);
end

c = 1;
try
    for i = Indices.Sin20
        TTLInfo.Sin20(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.Sin20 = TTLInfo.Sin20(:);
end

c = 1;
try
    for i = Indices.TonoWN
        TTLInfo.TonoWN(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.TonoWN = TTLInfo.TonoWN(:);
end

c = 1;
try
    for i = Indices.Sin80
        TTLInfo.Sin80(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.Sin80 = TTLInfo.Sin80(:);
end

c = 1;
try
    for i = Indices.Tono5
        TTLInfo.Tono5(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.Tono5 = TTLInfo.Tono5(:);
end

c = 1;
try
    for i = Indices.RD
        TTLInfo.RD(c) = TTLInfo.time_nextsound_corrected(i);
        c = c+1;
    end
    TTLInfo.RD= TTLInfo.RD(:);
end


save('behavResources.mat','TTLInfo','-append')




