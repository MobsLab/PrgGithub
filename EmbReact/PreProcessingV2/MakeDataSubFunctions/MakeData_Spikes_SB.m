disp(' '); disp('SpikeData')
try
    %keyboard
    global DATA
    tetrodeChannels=DATA.spikeGroups.groups;
    
    s=GetSpikes('output','full');
    a=1;
    clear S
    for i=1:max(s(:,2))
        UnitNums=[unique(s(s(:,2)==i,3))]
        if RemoveMUA
        UnitNums(UnitNums<2)=[];
        else
            UnitNums(UnitNums<1)=[];
        end
        
        for j=1:length(UnitNums)
            try
                if length(find(s(:,2)==i&s(:,3)==UnitNums(j)))>1
                    S{a}=tsd(s(find(s(:,2)==i&s(:,3)==UnitNums(j)),1)*1E4,s(find(s(:,2)==i&s(:,3)==UnitNums(j)),1)*1E4);
                    TT{a}=[i,UnitNums(j)];
                    cellnames{a}=['TT',num2str(i),'c',num2str(UnitNums(j))];
                    tempW{a} = GetSpikeWaveforms([i UnitNums(j)]);
                    disp(['Cluster : ',cellnames{a},' > done'])
%                     
                    for elec=1:size(tempW{a},2)
                        W{a}(elec,:)=mean(squeeze( tempW{a}(:,elec,:)));
                    end
                    a=a+1;
                end
            end
        end
        disp(['Tetrodes #',num2str(i),' > done'])
    end
    
    try
        S=tsdArray(S);
    end
    
    save SpikeData -v7.3 S s TT cellnames tetrodeChannels
    
    % Now we extract the relevant parameters
    load('LFPData/InfoLFP.mat')
    load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
    Tmax=max(Range(LFP,'s'));
    clear LFP
    for ww=1:length(W)
        % Get the FR
        Params{ww}(1)=length(Data(S{ww}))/Tmax;
        % First identify the largetst WF to use
        for elec=1:size(W{ww},1)
            try
                Peak{ww}(elec)=min(W{ww}(elec,:));
            end
        end
        [~,BestElec{ww}]=min(Peak{ww});
        WaveToUse=W{ww}(BestElec{ww},:);
        % Resample to make estimations smoother
        WaveToUseResample = resample(WaveToUse,300,1);
        % Get half width using null derivative
        [~,valmin]=min(WaveToUseResample);
        
        DD=diff(WaveToUseResample);
        diffpeak=find(DD(valmin:end)==max(DD(valmin:end)))+valmin;
        DD=DD(diffpeak:end);
        valmax=find(DD<max(abs(diff(WaveToUseResample)))*0.01,1,'first')+diffpeak;
        if isempty(valmax)
            valmax=find(DD<max(abs(diff(WaveToUseResample)))*0.05,1,'first')+diffpeak;
        end
        
        if WaveToUseResample(valmax)<0
              if not(isempty(find(WaveToUseResample(valmax:end)>0,1,'first')+valmax))
                valmax=find(WaveToUseResample(valmax:end)>0,1,'first')+valmax ;
            end
        end
        
        Params{ww}(2)=(valmax-valmin)*5e-5/300;
        % Get area under the curve
        [~,valmin2]=min(WaveToUseResample);
        WaveToUseResample=WaveToUseResample(valmin2:end);
        valzero=find(WaveToUseResample>0,1,'first');
        WaveToCalc=WaveToUseResample(valzero:end);
        Params{ww}(3)=sum(abs(WaveToCalc));
    end
    
    
    save('MeanWaveform.mat','BestElec','Peak','Params','W','RemoveMUA')
    
    disp('Done')
catch
    disp('problem for spikes')
end
    clear BestElec Peak Params W tempW S s TT cellnames tetrodeChannels InfoLFP
