%% First lets create a nice big bank of waveforms from the PFCx
clear all
Dir{1}=PathForExperimentsDeltaSleep('BASAL');
Dir{2}=PathForExperimentsDeltaSleep('RdmTone');
Dir{3}=PathForExperimentsDeltaSleep('DeltaT140');
Dir{4}=PathForExperimentsDeltaSleep('DeltaT200');
Dir{5}=PathForExperimentsDeltaSleep('DeltaT320');
Dir{6}=PathForExperimentsDeltaSleep('DeltaT480');
Dir{7}=PathForExperimentsDeltaSleep('DeltaT3delays');

close all

AllData=[];
for k=[1]
    disp(num2str(k))
    for kk=4:size(Dir{k}.path,2)
        disp(num2str(kk))
        cd(Dir{k}.path{kk})
        load('SpikeConnexions.mat')
        load('SpikeData.mat')
        [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,Dir{k}.path{kk});
        for sp=1:size(SpikeConn,1)
            sp
            if sum(SpikeConn(sp,:)==1)>0 | sum(SpikeConn(sp,:)==-1)>0
                AllConn=find(SpikeConn(sp,:));
                for cn=1:length(AllConn)
                    subplot(length(AllConn),1,cn)
                    [H0,B] = CrossCorr(Range(S{numNeurons(sp)}),Range(S{numNeurons(AllConn(cn))}),0.2,400);bar(B,H0)
                    title(num2str(SpikeConn(sp,AllConn(cn))))
                end
                if sum(SpikeConn(sp,:)==1)>0 & sum(SpikeConn(sp,:)==-1)==0
                    ans=input('OK Excit : 1 = yes, 0 is no');
                    SpikeConn(sp,AllConn)=ans;
                end
                if sum(SpikeConn(sp,:)==1)==0 & sum(SpikeConn(sp,:)==-1)>0
                    ans=input('OK Inhib : 1 = yes, 0 is no');
                    SpikeConn(sp,AllConn)=-ans;
                end
                
                if sum(SpikeConn(sp,:)==1)>0 & sum(SpikeConn(sp,:)==-1)>0
                    ans=input('Inhib or Excit : 1 = Excit, 0 is nthg, -1 = Inhib');
                    if ans==-1
                        AllConnE=find(SpikeConn(sp,:)==1);
                        SpikeConn(sp,AllConnE)=0;
                    elseif ans==1
                        AllConnI=find(SpikeConn(sp,:)==-1);
                        SpikeConn(sp,AllConnI)=0;
                    else
                        SpikeConn(sp,AllConn)=0;
                    end
                end
                
            end
            clf
        end
        keyboard
         save('SpikeConnexions2.mat','SpikeConn')
        clear SpikeConn
    end
    
    
end

%% First lets create a nice big bank of waveforms from the PFCx
clear all
Dir{1}=PathForExperimentsDeltaSleep('BASAL');
Dir{2}=PathForExperimentsDeltaSleep('RdmTone');
Dir{3}=PathForExperimentsDeltaSleep('DeltaT140');
Dir{4}=PathForExperimentsDeltaSleep('DeltaT200');
Dir{5}=PathForExperimentsDeltaSleep('DeltaT320');
Dir{6}=PathForExperimentsDeltaSleep('DeltaT480');
Dir{7}=PathForExperimentsDeltaSleep('DeltaT3delays');

close all
clear ResE ResI
FilenamDropBox='/media/DISK_1/';
n=1;
AllData=[];
for k=[1,3,4,5]
    disp(num2str(k))
    for kk=1:size(Dir{k}.path,2)
        try
            disp(num2str(kk))
            cd(Dir{k}.path{kk})
            load('SpikeData.mat')
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,Dir{k}.path{kk});
            WfId=IdentifyWaveforms(cd,FilenamDropBox,0,[1:length(numNeurons)]);
            load('SpikeConnexions2.mat')
            load('MeanWaveform.mat')
            WFData=reshape([Params{[1:length(numNeurons)]}],3,size(numNeurons,2))';
            SpikeId=sign(sum(SpikeConn'));
            AllData=[AllData,[WfId,SpikeId',WFData]'];
            WfId(abs(WfId)==0.5)=0;
            SpikeId(WfId==0)=0;
            ResE(n,:)=[sum([WfId==1].*[SpikeId==1]'),sum(SpikeId==1)];
            ResI(n,:)=[sum([WfId==-1].*[SpikeId==-1]'),sum(SpikeId==-1)];
            n=n+1;
        end
    end
end



figure
plot3(AllData(4,AllData(1,:)==1),AllData(5,AllData(1,:)==1),AllData(3,AllData(1,:)==1),'b.')
hold on
plot3(AllData(4,AllData(1,:)==-1),AllData(5,AllData(1,:)==-1),AllData(3,AllData(1,:)==-1),'r.')
 plot3(AllData(4,AllData(1,:)==-0.5),AllData(5,AllData(1,:)==-0.5),AllData(3,AllData(1,:)==-0.5),'k.')
 plot3(AllData(4,AllData(1,:)==0.5),AllData(5,AllData(1,:)==0.5),AllData(3,AllData(1,:)==0.5),'k.')
plot3(AllData(4,AllData(2,:)==-1 & abs(AllData(1,:))==1),AllData(5,AllData(2,:)==-1 & abs(AllData(1,:))==1),AllData(3,AllData(2,:)==-1 & abs(AllData(1,:))==1),'ro','MarkerSize',10)
plot3(AllData(4,AllData(2,:)==1 & abs(AllData(1,:))==1),AllData(5,AllData(2,:)==1 & abs(AllData(1,:))==1),AllData(3,AllData(2,:)==1 & abs(AllData(1,:))==1),'bo','MarkerSize',10)
ylim([0 4*1e5])

