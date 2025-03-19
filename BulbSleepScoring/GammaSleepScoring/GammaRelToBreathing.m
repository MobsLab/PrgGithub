clear all
%% EMG mice
% EMG
m=1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130729/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/01042015/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/22052015/';
lim=30;


for mm=1:m
    mm
    cd(Filename{mm})
    load('B_High_Spectrum.mat','ch')
    load(['LFPData/LFP',num2str(ch),'.mat'])
    load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch')

clear m1S tps1S mS
SWSEpoch=dropShortIntervals(SWSEpoch,lim*1e4);
Dur=(Stop(SWSEpoch)-Start(SWSEpoch))/1e4;
for ss=1:length(Dur)-1
    ss
    %[m1SE{ss,1},s1,tps1SE{ss,1},mSE{ss,1},NumEvS{ss,1},LengthBreathS{ss,1}]=PhasePowerModulationExclusive(Restrict(LFP,(subset(SWSEpoch,ss))),[[1,2]',[2:2:6;2+2:2:6+2]],Restrict(LFP,(subset(SWSEpoch,ss))));
    [m1S{ss,1},s1,tps1S{ss,1},mS{ss,1}]=PhasePowerModulation(Restrict(LFP,(subset(SWSEpoch,ss))),[1 3],Restrict(LFP,(subset(SWSEpoch,ss))));
    [m1S{ss,2},s1,tps1S{ss,2},mS{ss,2}]=PhasePowerModulation(Restrict(LFP,(subset(SWSEpoch,ss))),[4 7],Restrict(LFP,(subset(SWSEpoch,ss))));
    [m1S{ss,3},s1,tps1S{ss,3},mS{ss,3}]=PhasePowerModulation(Restrict(LFP,(subset(SWSEpoch,ss))),[8 12],Restrict(LFP,(subset(SWSEpoch,ss))));
end
DurS=Dur/sum(Dur);

clear m1W tps1W mW
Wake=dropShortIntervals(Wake,lim*1e4);
Dur=(Stop(Wake)-Start(Wake))/1e4;
for ss=1:length(Dur)-1
    ss
   % [m1WE{ss,1},s1,tps1WE{ss,1},mWE{ss,1},NumEvW{ss,1},LengthBreathW{ss,1}]=PhasePowerModulationExclusive(Restrict(LFP,(subset(Wake,ss))),[[1,2]',[2:2:6;2+2:2:6+2]],Restrict(LFP,(subset(Wake,ss))));
    [m1W{ss,1},s1,tps1W{ss,1},mW{ss,1}]=PhasePowerModulation(Restrict(LFP,(subset(Wake,ss))),[1 3],Restrict(LFP,(subset(Wake,ss))));
    [m1W{ss,2},s1,tps1W{ss,2},mW{ss,2}]=PhasePowerModulation(Restrict(LFP,(subset(Wake,ss))),[4 7],Restrict(LFP,(subset(Wake,ss))));
    [m1W{ss,3},s1,tps1W{ss,3},mW{ss,3}]=PhasePowerModulation(Restrict(LFP,(subset(Wake,ss))),[8 12],Restrict(LFP,(subset(Wake,ss))));
        
end
DurW=Dur/sum(Dur);

clear m1R tps1R mR
REMEpoch=dropShortIntervals(REMEpoch,lim*1e4);
Dur=(Stop(REMEpoch)-Start(REMEpoch))/1e4;
for ss=1:length(Dur)-1
    ss
    %[m1RE{ss,1},s1,tps1RE{ss,1},mRE{ss,1},NumEvR{ss,1},LengthBreathR{ss,1}]=PhasePowerModulationExclusive(Restrict(LFP,(subset(REMEpoch,ss))),[[1,2]',[2:2:6;2+2:2:6+2]],Restrict(LFP,(subset(REMEpoch,ss))));
    [m1R{ss,1},s1,tps1R{ss,1},mR{ss,1}]=PhasePowerModulation(Restrict(LFP,(subset(REMEpoch,ss))),[1 3],Restrict(LFP,(subset(REMEpoch,ss))));
    [m1R{ss,2},s1,tps1R{ss,2},mR{ss,2}]=PhasePowerModulation(Restrict(LFP,(subset(REMEpoch,ss))),[4 7],Restrict(LFP,(subset(REMEpoch,ss))));
    [m1R{ss,3},s1,tps1R{ss,3},mR{ss,3}]=PhasePowerModulation(Restrict(LFP,(subset(REMEpoch,ss))),[8 12],Restrict(LFP,(subset(REMEpoch,ss))));

end
DurR=Dur/sum(Dur);

save('PhaseModulaton.mat','DurR','DurS','DurW','m1W','tps1W','mW','m1S','tps1S','mS','m1R','tps1R','mR')
clear DurR DurS DurW m1W tps1W mW m1S tps1S mS m1R tps1R mR m1WE tps1WE mWE m1SE tps1SE mSE m1RE tps1RE mRE LengthBreathS LengthBreathW LengthBreathR NumEvS NumEvW NumEvR
end

figure
for k=1:5
    temp=zeros(51,101);
    totEv=0;
    for s=1:ss
        if sum(sum(isnan(m1SE{s,1}{k})))==0
        temp=temp+m1SE{s,1}{k}.*NumEvS{s,1}(k);
            totEv=totEv+NumEvS{s,1}(k);
        end
    end
    temp=temp/totEv;
    subplot(1,5,k)
    imagesc(tps1SE{1,1}{1},20:120,temp),axis xy
    hold on
   plot(tps1SE{1,1}{1},rescale((mSE{s,1}{k}),40,120-40),'w','linewidth',2)

end

Remem{1,1}=zeros(60,201);Remem{2,1}=zeros(60,201);Remem{3,1}=zeros(60,201);
%Remem{1,2}=zeros(201,1);Remem{2,1}=zeros(201,1);Remem{3,1}=zeros(201,1);

for mm=1:m
    cd(Filename{mm})
    try
        load('PhaseModulaton.mat')
%         fig=figure;
%         set(gcf,'Units','normalized','Position',[0.1300    0.7093    0.10    0.8157]);
        for k=1
%             subplot(3,1,1+(k-1)*3)
            temp=zeros(60,201);
            temp2=zeros(201,1);
            for ss=1:length(DurS)-1
                temp=temp+m1S{ss,k}.*DurS(ss);
                temp2=temp2+mS{ss,k}.*DurS(ss);
            end
%             for i=1:201
%                 temp(:,i)=temp(:,i).*[1:2:120]';
%             end
            Remem{1,1}=Remem{1,1}+temp;
%             imagesc(tps1S{ss,k},1:120, (Remem{1}')'), axis xy
%             hold on, plot(tps1S{ss,k},rescale((temp2),40,120-40),'w','linewidth',2)
            
%             subplot(3,1,2+(k-1)*3)
            temp=zeros(60,201);
            temp2=zeros(201,1);
            for ss=1:length(DurW)-1
                temp=temp+m1W{ss,k}.*DurW(ss);
                temp2=temp2+mW{ss,k}.*DurW(ss);
            end
%             for i=1:201
%                 temp(:,i)=temp(:,i).*[1:2:120]';
%             end
            Remem{2,1}=Remem{2,1}+temp;
%             imagesc(tps1W{ss,k},1:120, (temp)), axis xy
%             hold on, plot(tps1W{ss,k},rescale((temp2),40,120-40),'w','linewidth',2)
            
            subplot(3,1,3+(k-1)*3)
            temp=zeros(60,201);
            temp2=zeros(201,1);
            for ss=1:length(DurR)-1
                temp=temp+m1R{ss,k}.*DurR(ss);
                temp2=temp2+mR{ss,k}.*DurR(ss);
            end
%             for i=1:201
%                 temp(:,i)=temp(:,i).*[1:2:120]';
%             end
            Remem{3,1}=Remem{3,1}+temp;
%             imagesc(tps1R{ss,k},1:120, (temp)), axis xy
%             hold on, plot(tps1R{ss,k},rescale((temp2),40,120-40),'w','linewidth',2)
%             saveFigure(fig,['SpecFigs',num2str(mm),'.png'],'/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/Spectra/')
%             saveFigure(n,title,Dossier)
%             close all
        end
        
                    catch
                mm
    end
end
