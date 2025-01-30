%% First lets create a nice big bank of waveforms from the PFCx
clear all
Dir{1}=PathForExperimentsDeltaSleep('BASAL');
Dir{2}=PathForExperimentsDeltaSleep('RdmTone');
Dir{3}=PathForExperimentsDeltaSleep('DeltaT140');
Dir{4}=PathForExperimentsDeltaSleep('DeltaT200');
Dir{5}=PathForExperimentsDeltaSleep('DeltaT320');
Dir{6}=PathForExperimentsDeltaSleep('DeltaT480');
Dir{7}=PathForExperimentsDeltaSleep('DeltaT3delays');

% Get xml files to load spikes
Dir{1}.XmlFile{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Breath-Mouse-243-244-22022015.xml';
Dir{1}.XmlFile{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Breath-Mouse-243-244-22022015.xml';
Dir{1}.XmlFile{3}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Breath-Mouse-243-244-29032015.xml';
Dir{1}.XmlFile{4}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Breath-Mouse-243-244-29032015.xml';
Dir{1}.XmlFile{5}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Breath-Mouse-243-244-31032015.xml';
Dir{1}.XmlFile{6}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Breath-Mouse-243-244-31032015.xml';
Dir{1}.XmlFile{7}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Breath-Mouse-243-244-01042015.xml';
Dir{1}.XmlFile{8}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Breath-Mouse-243-244-01042015.xml';
Dir{1}.XmlFile{9}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Breath-Mouse-243-244-09042015.xml';
Dir{1}.XmlFile{10}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Breath-Mouse-243-244-09042015.xml';

Dir{2}.XmlFile{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Breath-Mouse-243-244-16042015.xml';
Dir{2}.XmlFile{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Breath-Mouse-243-244-17042015.xml';
Dir{2}.XmlFile{3}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Breath-Mouse-243-244-23022015.xml';
Dir{2}.XmlFile{4}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Breath-Mouse-243-244-23022015.xml';

Dir{3}.XmlFile{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015/Breath-Mouse-243-21042015.xml';
Dir{3}.XmlFile{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015/Breath-Mouse-244-22042015.xml';

Dir{4}.XmlFile{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Breath-Mouse-243-244-17042015.xml';
Dir{4}.XmlFile{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Breath-Mouse-243-244-16042015.xml';

Dir{5}.XmlFile{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015/Breath-Mouse-243-23042015.xml';
Dir{5}.XmlFile{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015/Breath-Mouse-244-24042015.xml';

AllData=[];
for k=[1,3,4,5]
    disp(num2str(k))
    for kk=1:size(Dir{k}.path,2)
        disp(num2str(kk))
        try
            cd(Dir{k}.path{kk})
            load('ChannelsToAnalyse/Bulb_deep.mat')
            load(['LFPData/LFP' num2str(channel) '.mat'])
            Tmax=max(Range(LFP,'s'));
            clear LFP
            load('SpikeData.mat')
            
%             SetCurrentSession(Dir{k}.XmlFile{kk})
%             global DATA;
%             
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,Dir{k}.path{kk});
%             GoodNeurons=reshape([TT{numNeurons}],2,length(numNeurons));
%             spk=1;
%             for tetr=unique(GoodNeurons(1,:))
%                 filename = [DATA.session.path '/' DATA.session.basename '.spk.' int2str(tetr)];
%                 nChannels = length(DATA.spikeGroups.groups{tetr});
%                 nSamplesPerWaveform = DATA.spikeGroups.nSamples(tetr);
%                 if Tmax>3*3600
%                     data = LoadSomeSpikeWaveforms(filename,nChannels,nSamplesPerWaveform,3*3600);
%                     D=DATA.spikes(DATA.spikes(:,1)<=3*3600,:);
%                 else
%                     data = LoadSpikeWaveforms(filename,nChannels,nSamplesPerWaveform);
%                 end
%                 D=D(D(:,2)==tetr,:);
%                 NeurToUse=GoodNeurons(2,find(GoodNeurons(1,:)==tetr));
%                 for neur=1:length(NeurToUse)
%                     keep=find(D(:,3)==NeurToUse(neur));
%                     tempW = data(keep,:,:);
%                     for elec=1:4
%                         try,W{spk}(elec,1:32)=mean(squeeze(tempW(:,elec,:)));end
%                     end
%                     spk=spk+1;
%                 end
%                 clear data
%             end
%             
            load('MeanWaveform.mat','BestElec','Peak','Params','W')

            
            for ww=1:length(W)
                for elec=1:4
                    try
                        Peak{ww}(elec)=min(W{ww}(elec,:));
                    end
                end
                [~,BestElec{ww}]=min(Peak{ww});
                Params{ww}(1)=length(Data(S{numNeurons(ww)}))/Tmax; % Get the FR
                WaveToUse=W{ww}(BestElec{ww},:);
                WaveToUseResample = resample(WaveToUse,300,1);
                
                % Get half width using null derivative
                [~,valmin]=min(WaveToUseResample);
                DD=diff(WaveToUseResample);
                diffpeak=find(DD(valmin:end)==max(DD(valmin:end)))+valmin;
                DD=DD(diffpeak:end);
                valmax=find(DD<max(abs(diff(WaveToUseResample)))*0.01,1,'first')+diffpeak;
                if WaveToUseResample(valmax)<0
                    try
                        valmax=find(WaveToUseResample(valmax:end)>0,1,'first')+valmax ;
                    catch
                        valmax=length(WaveToUseResample);
                    end
                end
                Params{ww}(2)=(valmax-valmin)*5e-5/300;
%                 plot(WaveToUseResample);
%                 hold on
%                 plot(valmax,WaveToUseResample(valmax),'*')
%                 pause
%                 hold off
                % Get area under the curve
                [~,valmin2]=min(WaveToUseResample);
                WaveToUseResample=WaveToUseResample(valmin2:end);
                valzero=find(WaveToUseResample>0,1,'first');
                WaveToCalc=WaveToUseResample(valzero:end);
                Params{ww}(3)=sum(abs(WaveToCalc));
                if abs(min(WaveToUse))>abs(max(WaveToUse))
                    AllData=[AllData;[Params{ww},k,kk,ww,WaveToUse]];
                end
            end
            
            save('MeanWaveform.mat','BestElec','Peak','Params','W')
        catch
            disp(['problem with' num2str(k) '-' num2str(kk)])
        end
        clear W S DATA D Params Peak BestElec
    end
end

AllData2=[];
for k=[1,3:5]
    
    k
    for kk=1:size(Dir{k}.path,2)
        try
        kk
        cd(Dir{k}.path{kk})
        load('MeanWaveform.mat','BestElec','Peak','Params','W')
        
        for ww=1:length(W)
            WaveToUse=W{ww}(BestElec{ww},:);
            if abs(min(WaveToUse))>abs(max(WaveToUse))
                AllData2=[AllData2;[Params{ww},k,kk,ww,WaveToUse]];
            end
        end
        end
    end
end

AllData2(:,1)=AllData2(:,1)./(max(AllData2(:,1))-min(AllData2(:,1)));
AllData2(:,2)=AllData2(:,2)./(max(AllData2(:,2))-min(AllData2(:,2)));
AllData2(:,3)=AllData2(:,3)./(max(AllData2(:,3))-min(AllData2(:,3)));
A=kmeans((AllData2(:,1:3)),2)
figure,plot3(AllData2(A==2,3),AllData2(A==2,2),AllData2(A==2,1),'r*')
hold on,plot3(AllData2(A==1,3),AllData2(A==1,2),AllData2(A==1,1),'b*')
figure
hold on
plot((AllData2(A==1,end-32:end)'),'b')
plot((AllData2(A==2,end-32:end)'),'r')