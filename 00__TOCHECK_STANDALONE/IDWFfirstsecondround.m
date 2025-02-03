%% To check that second best WF gives similar results

%% Go through all folders and get first and second best WF details


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
        load('MeanWaveform.mat')
        SaveParams=Params;
        clear Params Params2
        for ww=1:length(W)
            for elec=1:4
                try
                    Peak{ww}(elec)=min(W{ww}(elec,:));
                end
            end
            [~,BestElec{ww}]=min(Peak{ww});
            Params{ww}(1)=SaveParams{ww}(1); % Get the FR
            WaveToUse=W{ww}(BestElec{ww},:);
            WaveToUseResample = resample(WaveToUse,300,1);
            [~,valmin]=min(WaveToUseResample);
            try
                valmax=find(WaveToUseResample(valmin:end)>0,1,'first')+valmin;
            catch
                valmax=length(WaveToUseResample)
            end
            Params{ww}(2)=(valmax-valmin)*5e-5/300;
            [~,valmin2]=min(WaveToUseResample);
            WaveToUseResample=WaveToUseResample(valmin2:end);
            valzero=find(WaveToUseResample>0,1,'first');
            WaveToCalc=WaveToUseResample(valzero:end);
            Params{ww}(3)=sum(abs(WaveToCalc));
            
            WFLeft=[1:size(W{ww},1)];
            WFLeft(WFLeft==BestElec{ww})=[];
            [~,BestElec2{ww}]=min(Peak{ww}(WFLeft));
            BestElec2{ww}=WFLeft(BestElec2{ww});
            Params2{ww}(1)=SaveParams{ww}(1); % Get the FR
            WaveToUse2=W{ww}(BestElec2{ww},:);
            WaveToUseResample2 = resample(WaveToUse2,300,1);
            [~,valmin]=min(WaveToUseResample2);
            try
                valmax=find(WaveToUseResampl2e(valmin:end)>0,1,'first')+valmin;
            catch
                valmax=length(WaveToUseResample2);
            end
            Params2{ww}(2)=(valmax-valmin)*5e-5/300;
            [~,valmin2]=min(WaveToUseResample2);
            WaveToUseResample2=WaveToUseResample2(valmin2:end);
            valzero=find(WaveToUseResample2>0,1,'first');
            WaveToCalc=WaveToUseResample2(valzero:end);
            Params2{ww}(3)=sum(abs(WaveToCalc));
            
            if abs(min(WaveToUse))>abs(max(WaveToUse))
                AllData=[AllData;[Params{ww},Params2{ww},k,kk,ww]];
            end
        end
        
        
        save('MeanWaveform.mat','BestElec','Peak','Params','W')
        clear W S DATA D
        catch
           disp(['problem with' num2str(k) '-' num2str(kk)]) 
        end
    end
end

close all
for k=1:6
AllData2(:,k)=AllData(:,k)./(max(AllData(:,k))-min(AllData(:,k)));
end

A1=kmeans((AllData2(:,1:3)),3);
figure,plot3(AllData(A1==2,3),AllData(A1==2,2),AllData(A1==2,1),'r*')
hold on,plot3(AllData(A1==1,3),AllData(A1==1,2),AllData(A1==1,1),'b*')
hold on,plot3(AllData(A1==3,3),AllData(A1==3,2),AllData(A1==3,1),'g*')
svm
NumofOnes=sum(A1==1)/length(A1);
if NumofOnes>0.5
    A1(A1==1)=1;
    A1(A1==2)=-1;
else
    A1(A1==1)=-1;
    A1(A1==2)=1;
end
figure,plot3(AllData(A1==-1,3),AllData(A1==-1,2),AllData(A1==-1,1),'r*')
hold on,plot3(AllData(A1==1,3),AllData(A1==1,2),AllData(A1==1,1),'b*')

A2=kmeans((AllData2(:,4:6)),2);
NumofOnes=sum(A2==1)/length(A2);
if NumofOnes>0.5
    A2(A2==1)=1;
    A2(A2==2)=-1;
else
    A2(A2==1)=-1;
    A2(A2==2)=1;
end
figure,plot3(AllData(A2==-1,6),AllData(A2==-1,5),AllData(A2==-1,4),'r*')
hold on,plot3(AllData(A2==1,6),AllData(A2==1,5),AllData(A2==1,4),'b*')

sum(A1.*A2==1)./length(A1)
sum(A1==1 & A2==1)./sum(A1==1)
sum(A1==-1 & A2==-1)./sum(A1==-1)
