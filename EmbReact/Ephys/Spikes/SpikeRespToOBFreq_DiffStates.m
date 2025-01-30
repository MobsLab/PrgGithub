clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB
load('SpikingONHPCandOB.mat')
neur = 1;
AllFreezeResp = [];
AllSleepResp = [];
AllFreezeResp_sound = [];
AllExploResp = [];
AllEPMResp = [];

AllFreezeDist = [];
AllSleepDist = [];
AllFreezeDist_sound = [];
AllExploDist = [];
AllEPMDist = [];
FreqLims=[0:0.25:12];

clear R R_Sd R_Sl R_EPM R_Ex P P_Sd P_Sl P_EPM P_Ex
FreqExt = [2.5,5.5];
for mm=1:7
    AllFreezeDist = [AllFreezeDist;nanmean(Occup_HB{mm}{4}{2}(:,:),1)./nansum(Occup_HB{mm}{4}{2}(:))];
    AllSleepDist = [AllSleepDist;(nanmean(Occup_HB{mm}{7}{4}(:,:),1)+nanmean(Occup_HB{mm}{7}{5}(:,:),1))./(nansum(Occup_HB{mm}{7}{4}(:))+nansum(Occup_HB{mm}{7}{5}(:)))];
    AllFreezeDist_sound = [AllFreezeDist_sound;(nanmean(Occup_HB{mm}{5}{2}(:,:),1)+nanmean(Occup_HB{mm}{6}{2}(:,:),1))./(nansum(Occup_HB{mm}{5}{2}(:))+nansum(Occup_HB{mm}{6}{2}(:)))];
    AllExploDist = [AllExploDist;nanmean(Occup_HB{mm}{3}{1}(:,:),1)./nansum(Occup_HB{mm}{3}{1}(:))];
    AllEPMDist = [AllEPMDist;nanmean(Occup_HB{mm}{2}{1}(:,:),1)./nansum(Occup_HB{mm}{2}{1}(:))];

    for sp=1:size(MeanSpk_HB{mm}{1}{1},1)
        
        % Umaze Freezing
        temp_dat = nanmean(squeeze(MeanSpk_HB{mm}{4}{2}(sp,:,:)),1);
        temp_dat(temp_dat==0) = NaN;
        temp_dat(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        temp_dat = naninterp(temp_dat);
        AllFreezeResp = [AllFreezeResp;temp_dat];
        x = FreqLims(1:end-1);
        x(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        x(isnan(temp_dat)) = [];
        temp_dat(isnan(temp_dat)) = [];
        [R(neur),P(neur)] = corr(x',temp_dat');

        
        % Sleep
        temp_dat = nanmean(squeeze(MeanSpk_HB{mm}{7}{4}(sp,:,:)),1)+nanmean(squeeze(MeanSpk_HB{mm}{7}{5}(sp,:,:)),1);
        temp_dat(temp_dat==0) = NaN;
        temp_dat(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        temp_dat = naninterp(temp_dat);
        AllSleepResp = [AllSleepResp;temp_dat];
        x = FreqLims(1:end-1);
        x(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        x(isnan(temp_dat)) = [];
        temp_dat(isnan(temp_dat)) = [];
        [R_Sl(neur),P_Sl(neur)] = corr(x',temp_dat');
        NREM_FR(neur) = nanmean(nanmean(squeeze(MeanSpk_HB{mm}{7}{4}(sp,:,:)),2));
        REM_FR(neur) = nanmean(nanmean(squeeze(MeanSpk_HB{mm}{7}{5}(sp,:,:)),2));

        % Umaze Sound
        temp_dat = nanmean(squeeze(MeanSpk_HB{mm}{5}{2}(sp,:,:)),1)+nanmean(squeeze(MeanSpk_HB{mm}{6}{2}(sp,:,:)),1);
        temp_dat(temp_dat==0) = NaN;
        temp_dat(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        temp_dat = naninterp(temp_dat);
        AllFreezeResp_sound = [AllFreezeResp_sound;temp_dat];
        x = FreqLims(1:end-1);
        x(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        x(isnan(temp_dat)) = [];
        temp_dat(isnan(temp_dat)) = [];
        [R_Sd(neur),P_Sd(neur)] = corr(x',temp_dat');
        
          
        % Explo
        temp_dat = nanmean(squeeze(MeanSpk_HB{mm}{3}{1}(sp,:,:)),1);
        temp_dat(temp_dat==0) = NaN;
        temp_dat(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        try,temp_dat = naninterp(temp_dat);end
        AllExploResp = [AllExploResp;temp_dat];
        x = FreqLims(1:end-1);
        x(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        x(isnan(temp_dat)) = [];
        temp_dat(isnan(temp_dat)) = [];
        try,[R_Ex(neur),P_Ex(neur)] = corr(x',temp_dat');, catch,R_Ex(neur)=NaN;P_Ex(neur)=NaN; end
        
         % EPM
        temp_dat = nanmean(squeeze(MeanSpk_HB{mm}{2}{1}(sp,:,:)),1);
        temp_dat(temp_dat==0) = NaN;
        temp_dat(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        try,temp_dat = naninterp(temp_dat);end
        AllEPMResp = [AllEPMResp;temp_dat];
        x = FreqLims(1:end-1);
        x(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];
        x(isnan(temp_dat)) = [];
        temp_dat(isnan(temp_dat)) = [];
        try,[R_EPM(neur),P_EPM(neur)] = corr(x',temp_dat');, catch,R_EPM(neur)=NaN;P_EPM(neur)=NaN; end
        
        
        neur = neur+1;
        
    end
end
FreqLimsRest = FreqLims(1:end-1);
FreqLimsRest(FreqLims(1:end-1)<FreqExt(1) | FreqLims(1:end-1)>FreqExt(2)) = [];

R_ToUse = R;
P_ToUse = P;

figure
subplot(251)
Mat = sortrows([R_ToUse',nanzscore(AllFreezeResp')']);
imagesc(FreqLimsRest,1:neur-1,Mat(:,2:end)), clim([-2 2])
title('UMaze Fz')
xlabel('OB Freq (Hz)')
ylabel('Num Neur')
subplot(252)
Mat = sortrows([R_ToUse',nanzscore(AllFreezeResp_sound')']);
imagesc(FreqLimsRest,1:neur-1,Mat(:,2:end)), clim([-2 2])
title('SoundFz')
xlabel('OB Freq (Hz)')
subplot(253)
Mat = sortrows([R_ToUse',nanzscore(AllSleepResp')']);
imagesc(FreqLimsRest,1:neur-1,Mat(:,2:end)), clim([-2 2])
title('Sleep')
xlabel('OB Freq (Hz)')
subplot(254)
Mat = sortrows([R_ToUse',nanzscore(AllExploResp')']);
imagesc(FreqLimsRest,1:neur-1,Mat(:,2:end)), clim([-2 2])
title('Explo')
xlabel('OB Freq (Hz)')
subplot(255)
Mat = sortrows([R_ToUse',nanzscore(AllEPMResp')']);
imagesc(FreqLimsRest,1:neur-1,Mat(:,2:end)), clim([-2 2])
title('EPM')
xlabel('OB Freq (Hz)')

subplot(256)
Mat = sortrows([R_ToUse',nanzscore(AllFreezeResp')']);
Mat_Fz = Mat;
Mat(P_ToUse>0.05,:) = [];
imagesc(FreqLimsRest,1:size(Mat,1),Mat(:,2:end)), clim([-2 2])
xlabel('OB Freq (Hz)')
ylabel('Num Neur Sig Corr')
subplot(257)
Mat = sortrows([R_ToUse',nanzscore(AllFreezeResp_sound')']);
Mat_Sd = Mat;
Mat(P_ToUse>0.05,:) = [];
imagesc(FreqLimsRest,1:size(Mat,1),Mat(:,2:end)), clim([-2 2])
xlabel('OB Freq (Hz)')
subplot(258)
Mat = sortrows([R_ToUse',nanzscore(AllSleepResp')']);
Mat_Sl = Mat;
Mat(P_ToUse>0.05,:) = [];
imagesc(FreqLimsRest,1:size(Mat,1),Mat(:,2:end)), clim([-2 2])
xlabel('OB Freq (Hz)')
subplot(259)
Mat = sortrows([R_ToUse',nanzscore(AllExploResp')']);
Mat_Ex = Mat;
Mat(P_ToUse>0.05,:) = [];
imagesc(FreqLimsRest,1:size(Mat,1),Mat(:,2:end)), clim([-2 2])
xlabel('OB Freq (Hz)')
subplot(2,5,10)
Mat = sortrows([R_ToUse',nanzscore(AllEPMResp')']);
Mat_EPM = Mat;
Mat(P_ToUse>0.05,:) = [];
imagesc(FreqLimsRest,1:size(Mat,1),Mat(:,2:end)), clim([-2 2])
xlabel('OB Freq (Hz)')

figure
subplot(341)
plot(R,R_Sd,'*')
hold on
plot(R(P<0.05),R_Sd(P<0.05),'r*')
[r,p] = corr(R(P<0.05)',R_Sd(P<0.05)')
title(['SoundFz : Corr : R =',num2str(round(r,3)),' P=',num2str(round(p,3))])
xlabel('CorrCoeff UMaze'), ylabel('CorrCoeff SoundFz')
[CorrMat,SigMat] = corr(Mat_Fz(:,2:end),Mat_Sd(:,2:end),'rows','complete');
subplot(345)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat,0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')
subplot(349)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat.*double(SigMat<0.05),0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')

subplot(342)
plot(R,R_Sl,'*')
hold on
plot(R(P<0.05),R_Sl(P<0.05),'r*')
[r,p] = corr(R(P<0.05)',R_Sl(P<0.05)')
title(['Sleep Corr : R =',num2str(round(r,3)),' P=',num2str(round(p,3))])
[CorrMat,SigMat] = corr(Mat_Fz(:,2:end),Mat_Sl(:,2:end),'rows','complete');
xlabel('CorrCoeff UMaze'), ylabel('CorrCoeff Sleep')
subplot(346)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat,0)), axis xy,clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')
subplot(3,4,10)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat.*double(SigMat<0.05),0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')


subplot(343)
plot(R,R_Ex,'*')
hold on
plot(R(P<0.05),R_Ex(P<0.05),'r*')
[r,p] = corr(R(P<0.05)',R_Ex(P<0.05)','rows','complete');
title(['Explo Corr : R =',num2str(round(r,3)),' P=',num2str(round(p,3))])
[CorrMat,SigMat] = corr(Mat_Fz(:,2:end),Mat_Ex(:,2:end),'rows','complete');
xlabel('CorrCoeff UMaze'), ylabel('CorrCoeff Expl')
subplot(347)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat,0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')
subplot(3,4,11)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat.*double(SigMat<0.05),0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')

subplot(344)
plot(R,R_EPM,'*')
hold on
plot(R(P<0.05),R_EPM(P<0.05),'r*')
[r,p] = corr(R(P<0.05)',R_EPM(P<0.05)','rows','complete');
title(['EPM Corr : R =',num2str(round(r,3)),' P=',num2str(round(p,3))])
[CorrMat,SigMat] = corr(Mat_Fz(:,2:end),Mat_EPM(:,2:end),'rows','complete');
xlabel('CorrCoeff UMaze'), ylabel('CorrCoeff EPM')
subplot(348)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat,0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')
subplot(3,4,12)
imagesc(FreqLimsRest,FreqLimsRest,SmoothDec(CorrMat.*double(SigMat<0.05),0)), axis xy, clim([-0.15 0.15])
xlabel('OB Freq (Hz)'),ylabel('OB Freq (Hz)')


figure
plot(FreqLims(1:end-1),nanmean(AllFreezeDist),'linewidth',2), hold on
plot(FreqLims(1:end-1),nanmean(AllFreezeDist_sound),'linewidth',2), hold on
plot(FreqLims(1:end-1),nanmean(AllSleepDist),'linewidth',2), hold on
plot(FreqLims(1:end-1),nanmean(AllExploDist),'linewidth',2), hold on
plot(FreqLims(1:end-1),nanmean(AllEPMDist),'linewidth',2), hold on
line([2.5 2.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
legend('Fz-Umz','Fz-Sd','Sleep','Exp','EPM')



figure
subplot(151)
Mat = sortrows([R',nanzscore(AllFreezeResp')']);
Mat_Fz = Mat;
Mat(P>0.05,:) = [];
imagesc(FreqLimsRest,FreqLimsRest,corr(Mat(:,2:end))), clim([-0.5 0.5])
xlabel('OB Freq (Hz)')
ylabel('OB Freq (Hz)')
title('UMaze Fz')

subplot(152)
Mat = sortrows([R_Sd',nanzscore(AllFreezeResp_sound')']);
Mat_Sd = Mat;
Mat(P_Sd>0.05,:) = [];
imagesc(FreqLimsRest,FreqLimsRest,corr(Mat(:,2:end))), clim([-0.5 0.5])
xlabel('OB Freq (Hz)')
ylabel('OB Freq (Hz)')
title('SoundFz')

subplot(153)
Mat = sortrows([R_Sl',nanzscore(AllSleepResp')']);
Mat_Sl = Mat;
Mat(P_Sl>0.05,:) = [];
imagesc(FreqLimsRest,FreqLimsRest,corr(Mat(:,2:end))), clim([-0.5 0.5])
xlabel('OB Freq (Hz)')
ylabel('OB Freq (Hz)')
title('Sleep')

subplot(154)
Mat = sortrows([R_Ex',nanzscore(AllExploResp')']);
Mat_Ex = Mat;
Mat(P_Ex>0.05,:) = [];
imagesc(FreqLimsRest,FreqLimsRest,corr(Mat(:,2:end),'rows','complete')), clim([-0.5 0.5])
xlabel('OB Freq (Hz)')
ylabel('OB Freq (Hz)')
title('Explo')

subplot(155)
Mat = sortrows([R_EPM',nanzscore(AllEPMResp')']);
Mat_EPM = Mat;
Mat(P_EPM>0.05,:) = [];
imagesc(FreqLimsRest,FreqLimsRest,corr(Mat(:,2:end),'rows','complete')), clim([-0.5 0.5])
xlabel('OB Freq (Hz)')
ylabel('OB Freq (Hz)')
title('EPM')

%%
figure
subplot(151)
Mat = sortrows([R',nanzscore(AllFreezeResp')']);
Mat_Fz = Mat;
Mat(P>0.05,:) = [];
imagesc(1:size(Mat,1),1:size(Mat,1),corr(Mat(:,2:end)')), clim([-1 1]), axis xy
xlabel('NumNeur SigCorr')
ylabel('NumNeur SigCorr')
title('UMaze Fz')

subplot(152)
Mat = sortrows([R_Sd',nanzscore(AllFreezeResp_sound')']);
Mat_Sd = Mat;
Mat(P_Sd>0.05,:) = [];
imagesc(1:size(Mat,1),1:size(Mat,1),corr(Mat(:,2:end)')), clim([-1 1]), axis xy
xlabel('NumNeur SigCorr')
ylabel('NumNeur SigCorr')
title('SoundFz')

subplot(153)
Mat = sortrows([R_Sl',nanzscore(AllSleepResp')']);
Mat_Sl = Mat;
Mat(P_Sl>0.05,:) = [];
imagesc(1:size(Mat,1),1:size(Mat,1),corr(Mat(:,2:end)')), clim([-1 1]), axis xy
xlabel('NumNeur SigCorr')
ylabel('NumNeur SigCorr')
title('Sleep')

subplot(154)
Mat = sortrows([R_Ex',nanzscore(AllExploResp')']);
Mat_Ex = Mat;
Mat(P_Ex>0.05,:) = [];
Mat = Mat(:,2:end);
Mat(find(sum(isnan(Mat)')>0),:)=[];
imagesc(1:size(Mat,1),1:size(Mat,1),corr(Mat','rows','complete')), clim([-1 1]), axis xy
xlabel('NumNeur SigCorr')
ylabel('NumNeur SigCorr')
title('Explo')

subplot(155)
Mat = sortrows([R_EPM',nanzscore(AllEPMResp')']);
Mat_EPM = Mat;
Mat(P_EPM>0.05,:) = [];
Mat = Mat(:,2:end);
Mat(find(sum(isnan(Mat)')>0),:)=[];
imagesc(1:size(Mat,1),1:size(Mat,1),corr(Mat','rows','complete')),clim([-1 1]), axis xy
xlabel('NumNeur SigCorr')
ylabel('NumNeur SigCorr')
title('EPM')
colormap(redblue)

