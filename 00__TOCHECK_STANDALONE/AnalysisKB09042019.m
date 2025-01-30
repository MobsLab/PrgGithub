function [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019(limREM)

% Dir = PathForExperimentsEmbReact('BaselineSleep')
%a=0; i=0;
%a=a+1;disp(num2str(length(Dir.path{a})))
% si >1
%i=0; i=i+1,disp(num2str(length(Dir.path{a}))); cd(Dir.path{a}{i}), [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019; 
% si=1
% cd(Dir.path{a}), [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019; 
% et ...
%
%
% Dir=PathForExperimentsBasalSleepRhythms;
% a=a+1; cd(Dir.path{a}), disp(' '), disp('-----------------'),disp(Dir.path{a}), disp(' '), [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019; H(a,:)=h;
%
% a=a+1; 
% cd(Dir.path{a}), 
% disp(' ')
% disp('-----------------')
% disp(Dir.path{a})
% disp(' ')
% [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019; 
% H(a,:)=h;



% close all
% clear
% a=1;
% Dir = PathForExperimentsEmbReact('BaselineSleep')
% for mousenum  = 1:length(Dir.path)
% for daynum = 1:length(Dir.path{mousenum})
% cd(Dir.path{mousenum}{daynum})
% try
% [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019;
% mt(a)=m;
% Mt{a}=M;
% At{a}=A1;
% H(a,:)=h;
% a=a+1;
% pause(0)
% end
% end
% end
% 
% 
% Dir2=PathForExperimentsBasalSleepRhythms;
% for daynum  = 1:length(Dir2.path)
% cd(Dir2.path{daynum})
% try
% [m,h,b,M,S,t,A1,S1,tps]=AnalysisKB09042019;
% mt(a)=m;
% Mt{a}=M;
% At{a}=A1;
% H(a,:)=h;
% a=a+1;
% pause(0)
% end
% end
% for i=1:size(H,1)
% H2(i,:)=runmean(H(i,:),2)./max(runmean(H(i,:),2));
% end
% figure, subplot(3,1,1), hist(mt,15), xlim([0 1000]), title([num2str(mean(mt)/60),' min'])
% subplot(3,1,2), plot(b,runmean(H2',2),'linewidth',2)
% subplot(3,1,3), plot(b,runmean(H',2),'linewidth',2)













try
    limREM;
catch
    limREM=60;
end

% 
% load('SleepSubstages.mat')
% N1=Epoch{1};
% N2=Epoch{2};
% N3=Epoch{3};
% REM=Epoch{4};
% Wake=Epoch{5};
% swaPF=Epoch{8};
% swaOB=Epoch{9};
% 
% colorUp=[207 35 35]/255;
% colorDown=[32 215 28]/255;
% colorBox=[205 225 255]/255; %[197 246 255]/255;
%  
% 
% [SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REM,15);
% SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REM);
% 
% YL=ylim;    
% boxbottom = YL(1);
% boxhight = YL(2);
% 
% st=Start(SleepCycle,'s');
% en=End(SleepCycle,'s');
% for i=1:length(Start(SleepCycle))
% rectangle('Position', [st(i) boxbottom en(i)-st(i) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);line([st(i) st(i)],YL,'color',[0.7 0.7 0.7 ])
% end 
% SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REM,0);
%             
% 
% 
% 
% 
% 
% 
% 

try
load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};
swaPF=Epoch{8};
swaOB=Epoch{9};
SWSEpoch=or(or(N1,N2),N3);
catch
load SleepScoring_OBGamma Epoch REMEpoch SWSEpoch Wake
REM=REMEpoch;
end


colorUp=[207 35 35]/255;
colorDown=[32 215 28]/255;
colorBox=[205 225 255]/255; %[197 246 2

SleepStages=PlotSleepStage(Wake,SWSEpoch,REM); close
[REM,WakeC,idbad]=CleanREMEpoch(SleepStages,REM,Wake);
REMm=mergeCloseIntervals(REM,limREM*1E4);
Wake=Wake-REMm; SWSEpoch=SWSEpoch-REMm;
EnRem=End(REMm);
SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));
firstSleepCycle=intervalSet(0, EnRem(1));
SleepCycle=or(firstSleepCycle,SleepCycle);

%[SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REMm,15);

clear dur
clear stok
for i=1:length(Start(SleepCycle))
    clear dur
    stok(i)=Start(subset(SleepCycle,i));
    dur=End(and(Wake,subset(SleepCycle,i)),'s')-Start(and(Wake,subset(SleepCycle,i)),'s');
    if length(dur)>0

   %%     
        for j=1:length(dur)
            if dur(j)>10
                try
                    if dur(j)>dur(j-1)
                    stok(i)=End(subset(and(Wake,subset(SleepCycle,i)),j));%stok(i), disp('check 1')
                    end
                catch
                    stok(i)=End(subset(and(Wake,subset(SleepCycle,i)),j));%stok(i), disp('check 2')
                end
            end
        end
        
        
    else
         stok(i)=Start(subset(SleepCycle,i)); %stok(i), disp('check 4')
    end
end

SleepCycleOK=intervalSet(stok, End(SleepCycle));



SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REMm);
YL=ylim;    
boxbottom = YL(1);
boxhight = YL(2);
st=Start(SleepCycleOK,'s');
en=End(SleepCycleOK,'s');
for i=1:length(Start(SleepCycleOK))
rectangle('Position', [st(i) boxbottom en(i)-st(i) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);line([st(i) st(i)],YL,'color',[0.7 0.7 0.7 ])
end 
SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REMm,0); title(pwd)

try
delta_waves = GetDeltaWaves;
rg=Range(SleepStagesC,'s');
[h,b]=hist(Start(delta_waves,'s'),[rg(1):60:rg(end)]);
[h2,b2]=hist(Start(and(delta_waves,SWSEpoch),'s'),[rg(1):60:rg(end)]);
hold on, plot(b,rescale(h,-1,0.5),'color',[0 0 0.5],'linewidth',1)
hold on, plot(b2,rescale(h2,-1,0.5),'color',[0 0.5 0],'linewidth',2)
end



[h,b]=hist(DurationEpoch(SleepCycleOK)/1E4,[0:20:1000]);title(pwd)
m=mean(DurationEpoch(SleepCycleOK)/1E4);

try
load('B_Low_Spectrum.mat')
Stsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
catch
res=pwd;
tempch=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
ch=tempch.channel;
eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(ch),'.mat'');']);
Stsd=tsd(t*1E4,10*log10(Sp));
end

try
%figure, imagesc(Spectro{2}*1E4,Spectro{3},10*log10(Spectro{1}')), axis xy
[M,S,t]=AverageSpectrogram(Stsd,f,ts(Start(SleepCycleOK)),200,1000);close
[A1,S1,tps]=AverageNormalizedDurationTsd(Stsd,SleepCycleOK,50,1);close
end

figure, 
subplot(1,3,1), bar(b,runmean(h,2),1), title(num2str(m))
try
    subplot(1,3,2), imagesc(M),axis xy,title(pwd)
    subplot(1,3,3), imagesc(A1),axis xy
end

