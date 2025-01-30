% SplitSpikeFiles - Split sorted files into experimental subphases.
%
% Creates SpikeData, MeanWaverforms files
% Also creates .clu, .fet, .spk, .res, _original1.klg files to look at the clusters
% locally
%
%       See
%   
%       ConcatenateAllSpikes, CalcBasicNeuronInfo
% 
% Copyright (C) 2018 by Dmitri Bryzgalov
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT

%% Parameters and housekeeping
% Folders with data
try
    Dir
catch
    Dir.path{1} = '/media/mobsrick/DataMOBS87/Mouse-798/12112018';
end

for a = 1:length(Dir)
    
    % Go to the folder
    disp(' ')
    disp('****************************************************************')
    cd([Dir.path{a} '/AllSpikes']);
    disp(pwd)
    
    % Load some data
    load('SpikeData.mat');
    load('MeanWaveform.mat');
    load('ExpeInfo.mat');
    AllS = S; % Copy of all spikes
    nchan = 36; % Number of channels in your dat file
    flnme = ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase]; % Filename - All spikes

    % Get spikes and featers
    SetCurrentSession([flnme '_original1.xml']);
    global DATA
    s=GetSpikes('output','full');
    sampleRate=20000;

    for i = 1:length(tetrodeChannels)
        M{i}=dlmread([flnme '_original1.fet.' num2str(i)]); % Feature files
    end

    %% Find the order of subphases (see <ConcatenateAllSpikes>)
    OrderCell = importdata('list_orig_files.txt', ' ');
    NSes = length(OrderCell);
    order = cell(1,NSes);
    for i = 1:NSes
        order{i} = OrderCell{i}(4:end);
    end

    %% Find the limits of the files
    fid=fopen([flnme  '.cat.evt']);
    LongString=fscanf(fid,'%s');
    flim = ones(NSes, 2);
    flim(1,1)=0;
    for k=1:NSes
        template1=['beginningof' flnme '-',sprintf('%2.2d',k) '-wideband'];
        template2=['endof' flnme '-',sprintf('%2.2d',k) '-wideband'];
        if k == 1
            flim(k,2) = str2num(LongString([strfind(LongString, template1)+length(template1):strfind(LongString,template2)-1]));
        else
            flim(k,1) = flim(k-1,2);
            flim(k,2) = str2num(LongString([strfind(LongString, template1)+length(template1):strfind(LongString,template2)-1]));
        end
    end
    %% Split the files for all subphases
        
    
    % Save SpikeData and MeanWaveform
    for i = 1:NSes
        if strfind(order{i}, 'TestPre') == 1
            o = order{i};
            cd([Dir.path{a} '/' order{i}(1:end-1) '/' order{i}]);
        elseif strfind(order{i}, 'Cond') == 1
            o = order{i};
            cd([Dir.path{a} '/' order{i}(1:end-1) '/' order{i}]);
        elseif strfind(order{i}, 'TestPost') == 1
            o = order{i};
            cd([Dir.path{a} '/' order{i}(1:end-1) '/' order{i}]);
        else
            cd([Dir.path{a} '/' order{i}]);
        end
        res=pwd;
        load('ExpeInfo.mat');
        flnme_phase = ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase];
        for j = 1:length(AllS)
            S{j} = Restrict(AllS{j}, intervalSet(flim(i,1)*10, flim(i,2)*10));
            R = Range(S{j})- (flim(i,1)*10); % Make it start from zero
            D = Data(S{j}) - (flim(i,1)*10);
            S{j} = tsd(R,D);
        end
        save('SpikeData.mat','S','TT', 'cellnames','tetrodeChannels','-v7.3');
        save('MeanWaveform.mat','W', '-v7.3');
        clear S
        copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.xml'], res);   % Copy _original1.xml file
        movefile([flnme '_original1.xml'], [flnme_phase '_original1.xml']);
    
        % Create .res and .spk files (from Sophie's <LoafingandSplittingSpikes>)
        for k=1:length(tetrodeChannels)
            %Just get one tetrode
            NewS=s(s(:,2)==k,:);
            NewSTps=NewS(NewS(:,1)>flim(i,1)/1e3&NewS(:,1)<flim(i,2)/1e3,:);
            NewSTps(:,1)=round(NewSTps(:,1)-flim(i,1)/1e3,5)*sampleRate;
            UnitNums{k}=[unique(s(s(:,2)==k,3))];
            fileIDT = fopen('tps.txt','w');
            fileIDC = fopen('clunum.txt','w');
            fprintf(fileIDC,'%.0f',length(UnitNums{k}));
            fprintf(fileIDC,'\n');
            for time=1:length(NewSTps)
                if time>1
                    fprintf(fileIDT,'\n');
                end
                fprintf(fileIDT,'%.0f',NewSTps(time,1));
                if time>1
                    fprintf(fileIDC,'\n');
                end
                fprintf(fileIDC,'%.0f',NewSTps(time,3));
            end
            fprintf(fileIDT,'\n');
            fprintf(fileIDC,'\n');
            fclose(fileIDT);fclose(fileIDC);
            movefile('tps.txt',[flnme_phase,'.res.' num2str(k)])
            movefile('clunum.txt',[flnme_phase,'.clu.' num2str(k)])
        end
    
        % make new .fet (from Sophie's <LoafingandSplittingSpikes>)
        for k=1:length(tetrodeChannels)
            %Just get one tetrode
            NewS=s(s(:,2)==k,:); % Spikes
            NewSpikes=find(NewS(:,1)>flim(i,1)/1e3&NewS(:,1)<flim(i,2)/1e3);
            NewM=M{k}(NewSpikes+1,:); % Features
            NewM(:,end)=NewM(:,end)-flim(i,1)*sampleRate/1000;
            fileIDT = fopen('fet.txt','w');
            fprintf(fileIDT,'%.0f',M{k}(1,1));
            fprintf(fileIDT,'\n');
            fprintf(fileIDT, [repmat('%d ',1,M{k}(1,1)-1) '%d' '\n'],NewM');
            fclose(fileIDT);
            movefile('fet.txt',[flnme_phase,'.fet.' num2str(k)])
            NewName=[flnme_phase '.spk.' num2str(k)];
            SpikeTimesToUse=NewS(NewSpikes,1);
            CreateSpkFile([Dir.path{a} '/AllSpikes/' flnme '_original1.fil'],SpikeTimesToUse,nchan,tetrodeChannels{k},NewName);
            movefile([Dir.path{a} '/AllSpikes/' NewName], res);
        end
    
        % Copy and rename _original1.klg files
        for k=1:length(tetrodeChannels)
            res = pwd;
            copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.klg.' num2str(k)], res);
            movefile([flnme '_original1.klg.' num2str(k)], [flnme_phase '.klg.' num2str(k)]);
        end
        
    end
     
    %% Create merged files for 'TestPre', 'Cond' and 'TestPost'
    
    %% TestPre
    % Find indices of the subphases
    idx = zeros(1,length(order));
    for g = 1:length(order)
        if ~isempty(strfind(order{g}, 'TestPre'))
            idx(g) = g;
        end
    end
    idx = nonzeros(idx);
    
    cd([Dir.path{a} '/TestPre']);
    res=pwd;
    load('ExpeInfo.mat');
    flnme_phase = ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase];
    for j = 1:length(AllS)
            S{j} = Restrict(AllS{j}, intervalSet(flim(idx(1),1)*10, flim(idx(end),2)*10));
            R = Range(S{j})- (flim(idx(1),1)*10); % Make it start from zero
            D = Data(S{j}) - (flim(idx(1),1)*10);
            S{j} = tsd(R,D);
    end
    save('SpikeData.mat','S','TT', 'cellnames','tetrodeChannels','-v7.3');
    save('MeanWaveform.mat','W', '-v7.3');
    clear S
%     copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.xml'], res);   % Copy _original1.xml file
%     movefile([flnme '_original1.xml'], [flnme_phase '_original1.xml']);
    
    for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:);
        NewSTps=NewS(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3,:);
        NewSTps(:,1)=round(NewSTps(:,1)-flim(idx(1),1)/1e3,5)*sampleRate;
        UnitNums{k}=[unique(s(s(:,2)==k,3))];
        fileIDT = fopen('tps.txt','w');
        fileIDC = fopen('clunum.txt','w');
        fprintf(fileIDC,'%.0f',length(UnitNums{k}));
        fprintf(fileIDC,'\n');
        for time=1:length(NewSTps)
            if time>1
                fprintf(fileIDT,'\n');
            end
            fprintf(fileIDT,'%.0f',NewSTps(time,1));
            if time>1
                fprintf(fileIDC,'\n');
            end
            fprintf(fileIDC,'%.0f',NewSTps(time,3));
        end
        fprintf(fileIDT,'\n');
        fprintf(fileIDC,'\n');
        fclose(fileIDT);fclose(fileIDC);
        movefile('tps.txt',[flnme_phase,'.res.' num2str(k)])
        movefile('clunum.txt',[flnme_phase,'.clu.' num2str(k)])
    end
    
	for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:); % Spikes
        NewSpikes=find(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3);
        NewM=M{k}(NewSpikes+1,:); % Features
        NewM(:,end)=NewM(:,end)-flim(idx(1),1)*sampleRate/1000;
        fileIDT = fopen('fet.txt','w');
        fprintf(fileIDT,'%.0f',M{k}(1,1));
        fprintf(fileIDT,'\n');
        fprintf(fileIDT, [repmat('%d ',1,M{k}(1,1)-1) '%d' '\n'],NewM');
        fclose(fileIDT);
        movefile('fet.txt',[flnme_phase,'.fet.' num2str(k)])
        NewName=[flnme_phase '.spk.' num2str(k)];
        SpikeTimesToUse=NewS(NewSpikes,1);
        CreateSpkFile([Dir.path{a} '/AllSpikes/' flnme '_original1.fil'],SpikeTimesToUse,nchan,tetrodeChannels{k},NewName);
        movefile([Dir.path{a} '/AllSpikes/' NewName], res);
    end
    
        % Copy and rename _original1.klg files
        for k=1:length(tetrodeChannels)
            res = pwd;
            copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.klg.' num2str(k)], res);
            movefile([flnme '_original1.klg.' num2str(k)], [flnme_phase '.klg.' num2str(k)]);
        end

    %% Cond
    % Find indices of the subphases
    idx = zeros(1,length(order));
    for g = 1:length(order)
        if ~isempty(strfind(order{g}, 'Cond'))
            idx(g) = g;
        end
    end
    idx = nonzeros(idx);
    
    cd([Dir.path{a} '/Cond']);
    res=pwd;
    load('ExpeInfo.mat');
    flnme_phase = ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase];
    for j = 1:length(AllS)
            S{j} = Restrict(AllS{j}, intervalSet(flim(idx(1),1)*10, flim(idx(end),2)*10));
            R = Range(S{j})- (flim(idx(1),1)*10); % Make it start from zero
            D = Data(S{j}) - (flim(idx(1),1)*10);
            S{j} = tsd(R,D);
    end
    save('SpikeData.mat','S','TT', 'cellnames','tetrodeChannels','-v7.3');
    save('MeanWaveform.mat','W', '-v7.3');
    clear S
%     copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.xml'], res);   % Copy _original1.xml file
%     movefile([flnme '_original1.xml'], [flnme_phase '_original1.xml']);
    
    for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:);
        NewSTps=NewS(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3,:);
        NewSTps(:,1)=round(NewSTps(:,1)-flim(idx(1),1)/1e3,5)*sampleRate;
        UnitNums{k}=[unique(s(s(:,2)==k,3))];
        fileIDT = fopen('tps.txt','w');
        fileIDC = fopen('clunum.txt','w');
        fprintf(fileIDC,'%.0f',length(UnitNums{k}));
        fprintf(fileIDC,'\n');
        for time=1:length(NewSTps)
            if time>1
                fprintf(fileIDT,'\n');
            end
            fprintf(fileIDT,'%.0f',NewSTps(time,1));
            if time>1
                fprintf(fileIDC,'\n');
            end
            fprintf(fileIDC,'%.0f',NewSTps(time,3));
        end
        fprintf(fileIDT,'\n');
        fprintf(fileIDC,'\n');
        fclose(fileIDT);fclose(fileIDC);
        movefile('tps.txt',[flnme_phase,'.res.' num2str(k)])
        movefile('clunum.txt',[flnme_phase,'.clu.' num2str(k)])
    end
    
	for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:); % Spikes
        NewSpikes=find(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3);
        NewM=M{k}(NewSpikes+1,:); % Features
        NewM(:,end)=NewM(:,end)-flim(idx(1),1)*sampleRate/1000;
        fileIDT = fopen('fet.txt','w');
        fprintf(fileIDT,'%.0f',M{k}(1,1));
        fprintf(fileIDT,'\n');
        fprintf(fileIDT, [repmat('%d ',1,M{k}(1,1)-1) '%d' '\n'],NewM');
        fclose(fileIDT);
        movefile('fet.txt',[flnme_phase,'.fet.' num2str(k)])
        NewName=[flnme_phase '.spk.' num2str(k)];
        SpikeTimesToUse=NewS(NewSpikes,1);
        CreateSpkFile([Dir.path{a} '/AllSpikes/' flnme '_original1.fil'],SpikeTimesToUse,nchan,tetrodeChannels{k},NewName);
        movefile([Dir.path{a} '/AllSpikes/' NewName], res);
    end
    
        % Copy and rename _original1.klg files
        for k=1:length(tetrodeChannels)
            res = pwd;
            copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.klg.' num2str(k)], res);
            movefile([flnme '_original1.klg.' num2str(k)], [flnme_phase '.klg.' num2str(k)]);
        end
        
    %% TestPost
    % Find indices of the subphases
    idx = zeros(1,length(order));
    for g = 1:length(order)
        if ~isempty(strfind(order{g}, 'TestPost'))
            idx(g) = g;
        end
    end
    idx = nonzeros(idx);
    
    cd([Dir.path{a} '/TestPost']);
    res=pwd;
    load('ExpeInfo.mat');
    flnme_phase = ['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase];
    for j = 1:length(AllS)
            S{j} = Restrict(AllS{j}, intervalSet(flim(idx(1),1)*10, flim(idx(end),2)*10));
            R = Range(S{j})- (flim(idx(1),1)*10); % Make it start from zero
            D = Data(S{j}) - (flim(idx(1),1)*10);
            S{j} = tsd(R,D);
    end
    save('SpikeData.mat','S','TT', 'cellnames','tetrodeChannels','-v7.3');
    save('MeanWaveform.mat','W', '-v7.3');
    clear S
%     copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.xml'], res);   % Copy _original1.xml file
%     movefile([flnme '_original1.xml'], [flnme_phase '_original1.xml']);
    
    for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:);
        NewSTps=NewS(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3,:);
        NewSTps(:,1)=round(NewSTps(:,1)-flim(idx(1),1)/1e3,5)*sampleRate;
        UnitNums{k}=[unique(s(s(:,2)==k,3))];
        fileIDT = fopen('tps.txt','w');
        fileIDC = fopen('clunum.txt','w');
        fprintf(fileIDC,'%.0f',length(UnitNums{k}));
        fprintf(fileIDC,'\n');
        for time=1:length(NewSTps)
            if time>1
                fprintf(fileIDT,'\n');
            end
            fprintf(fileIDT,'%.0f',NewSTps(time,1));
            if time>1
                fprintf(fileIDC,'\n');
            end
            fprintf(fileIDC,'%.0f',NewSTps(time,3));
        end
        fprintf(fileIDT,'\n');
        fprintf(fileIDC,'\n');
        fclose(fileIDT);fclose(fileIDC);
        movefile('tps.txt',[flnme_phase,'.res.' num2str(k)])
        movefile('clunum.txt',[flnme_phase,'.clu.' num2str(k)])
    end
    
	for k=1:length(tetrodeChannels)
        %Just get one tetrode
        NewS=s(s(:,2)==k,:); % Spikes
        NewSpikes=find(NewS(:,1)>flim(idx(1),1)/1e3&NewS(:,1)<flim(idx(end),2)/1e3);
        NewM=M{k}(NewSpikes+1,:); % Features
        NewM(:,end)=NewM(:,end)-flim(idx(1),1)*sampleRate/1000;
        fileIDT = fopen('fet.txt','w');
        fprintf(fileIDT,'%.0f',M{k}(1,1));
        fprintf(fileIDT,'\n');
        fprintf(fileIDT, [repmat('%d ',1,M{k}(1,1)-1) '%d' '\n'],NewM');
        fclose(fileIDT);
        movefile('fet.txt',[flnme_phase,'.fet.' num2str(k)])
        NewName=[flnme_phase '.spk.' num2str(k)];
        SpikeTimesToUse=NewS(NewSpikes,1);
        CreateSpkFile([Dir.path{a} '/AllSpikes/' flnme '_original1.fil'],SpikeTimesToUse,nchan,tetrodeChannels{k},NewName);
        movefile([Dir.path{a} '/AllSpikes/' NewName], res);
    end
    
        % Copy and rename _original1.klg files
        for k=1:length(tetrodeChannels)
            res = pwd;
            copyfile([Dir.path{a} '/AllSpikes/' flnme '_original1.klg.' num2str(k)], res);
            movefile([flnme '_original1.klg.' num2str(k)], [flnme_phase '.klg.' num2str(k)]);
        end
        
end