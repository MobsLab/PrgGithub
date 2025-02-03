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

Window=[1.5,4];

close all

AllData=[];
for k=[3,4,5]
    disp(num2str(k))
    for kk=1:size(Dir{k}.path,2)
        disp(num2str(kk))
        
        cd(Dir{k}.path{kk})
        load('SpikeData.mat')
        
        [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,Dir{k}.path{kk});
        
        for sp1=1:length(numNeurons)-1
            sp1
            for sp2=sp1+1:length(numNeurons)
                
                [H0,B] = CrossCorr(Range(S{numNeurons(sp1)}),Range(S{numNeurons(sp2)}),1,100);
                Lim(1)=mean(H0([1:40,70:end]))+6*std(H0([1:40,70:end])); %be more demanding for excitation
                Lim(2)=mean(H0([1:40,70:end]))-4*std(H0([1:40,70:end]));
                bIx = find(B>=Window(1) & B<=Window(2));
                h1 = H0(bIx);
                bIx = find(B>=-Window(2) & B<=-Window(1));
                h2 = H0(bIx);
                h=[h1,h2];
         
                if sum(sum(h>Lim(1))>0 | sum(h<Lim(2))>0)>0

                    [H0,Hm,HeI,HeS,Hstd,B,HMaxMin] = XcJitter_SB(Range(S{numNeurons(sp1)}),Range(S{numNeurons(sp2)}),0.5,80,0.99,100);
                    [SynC,ConStr] = XcConnection_SB(H0,Hm,HeI,HeS,Hstd,B,HMaxMin,Window);
                    if (SynC(1))==-1 | abs(SynC(2))==-1
%                         disp('sig')
%                         figure
%                         bar(B,H0)
%                         hold on
%                         plot(B,HeI,'g','linewidth',2)
%                         plot(B,HeS,'g','linewidth',2)
%                         plot(B,HMaxMin(1,1),'r','linewidth',2)
%                         plot(B,HMaxMin(2,1),'r','linewidth',2)
%                         plot(B,HMaxMin(1,2),'b','linewidth',2)
%                         plot(B,HMaxMin(2,2),'b','linewidth',2)
% 
%                         keyboard  
%                         clf
                    end
                    SpikeConn(sp1,sp2)=SynC(1);
                    SpikeConn(sp2,sp1)=SynC(2);
                    
                else
                    SpikeConn(sp1,sp2)=0;
                    SpikeConn(sp2,sp1)=0;
                end
            end
        end
        save('SpikeConnexions.mat','SpikeConn','numNeurons')
        clear SpikeConn
        
    end
end
