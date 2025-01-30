clear all, close all

% Load names of all mice to use
AllSlScoringMice
SaveFolderName='/media/DataMOBSSlSc/SleepScoringMice/DesychrnoisationAtTransitions/';
smootime=1;
for mm=1:m
    figure
    mm
    tic
    try
       
        cd(filename2{mm})
        %     load('MapsTransitionProba.mat')
        clear TotalNoiseEpoch NoiseEpoch GndNoiseEpoch
        load('StateEpochSB.mat','SWSEpoch','Wake','smooth_Theta','smooth_ghi','gamma_thresh','TotalNoiseEpoch','NoiseEpoch','GndNoiseEpoch')
        
        if exist('H_Low_Spectrum.mat')>0
            load([ filename2{mm} 'H_Low_Spectrum.mat'])
            SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
        else
            clear SptsdH
        end
        load('H_Low_Spectrum.mat')
        TotEpoch=intervalSet(0,max(Spectro{2}*1e4));
        try, TotEpoch=TotEpoch-TotalNoiseEpoch; end
        try, TotEpoch=TotEpoch-or(NoiseEpoch,GndNoiseEpoch); end
        
        mnH=mean(Spectro{1}(:,20:end)');
        HPowtsd=tsd(Spectro{2}*1e4,runmean(mnH',ceil(smootime/median(diff(Spectro{2})))));
        HPowtsd=Restrict(HPowtsd,TotEpoch);
        HPowtsd_dat=Data(HPowtsd);
        smooth_Theta=Restrict(smooth_Theta,Range(HPowtsd));
        a=log(Data(smooth_Theta));a=a/(max(a)-min(a));a=a-min(a);
        smooth_Theta_dat=floor(a*100);

        smooth_ghi=Restrict(smooth_ghi,Range(HPowtsd));
        a=log(Data(smooth_ghi));a=a/(max(a)-min(a));a=a-min(a);
        smooth_ghi_dat=floor(a*100);
        
        for k=1:100
            k
            for kk=1:100
                Val(k,kk)=mean(HPowtsd_dat(find(smooth_Theta_dat==k & smooth_ghi_dat==kk)));
            end
        end
        Val(isnan(Val))=0;
        fig=figure;
        imagesc(SmoothDec(Val,[1,1])), axis xy, colormap jet
        saveas(fig,[SaveFolderName,'MapDesynchroMouse',num2str(mm),'.png'])
        saveas(fig,[SaveFolderName,'MapDesynchroMouse',num2str(mm),'.fig'])
close all
    end
end
