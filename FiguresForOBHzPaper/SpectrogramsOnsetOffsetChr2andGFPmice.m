clear all
a =0;% march 2017
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170309-EXT-24-laser13/FEAR-Mouse-497-09032017';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170310-EXT-48-laser13/FEAR-Mouse-496-10032017';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170310-EXT-48-laser13';

% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse498/20170309-EXT-24-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse498/20170310-EXT-48-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse499/20170309-EXT-24-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse499/20170310-EXT-48-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170316-EXT-24-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170317-EXT-48-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170316-EXT-24-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170317-EXT-48-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170316-EXT-24-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170317-EXT-48-laser13';

% july 2017
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse537/20170727-EXT24-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170727-EXT24-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170727-EXT24-laser13';

% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse537/20170728-EXT48-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170728-EXT48-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170728-EXT48-laser13';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170728-EXT48-laser13';
%
% Octobre 2017
% a=a+1; Dir.path{a}='';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse611/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse612/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171005-EXT-24';

% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse610/20171006-EXT-48';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse611/20171006-EXT-48';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse612/20171006-EXT-48';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171006-EXT-48';
% a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171006-EXT-48';
timeatTransition = 3;
tps=[0.05:0.05:1];

for m =1:a
    cd(Dir.path{m})
    disp(Dir.path{m})
    
    clear Sptsd
    % load spectra
    try,load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep = tsd(t*1e4,Sp);
    catch
        eval(['load LFPData/LFP',num2str(channel)])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        eval(['save SpectrumDataL/Spectrum',num2str(channel),' Sp t f'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep = tsd(t*1e4,Sp);
    end
    
    try, load('ChannelsToAnalyse/Bulb_deep_right.mat')
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep_right = tsd(t*1e4,Sp);
    catch
        eval(['load LFPData/LFP',num2str(channel)])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        eval(['save SpectrumDataL/Spectrum',num2str(channel),' Sp t f'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep_right = tsd(t*1e4,Sp);
    end
    
    try,load('ChannelsToAnalyse/Bulb_deep_left.mat')
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep_left = tsd(t*1e4,Sp);
    catch
        eval(['load LFPData/LFP',num2str(channel)])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        eval(['save SpectrumDataL/Spectrum',num2str(channel),' Sp t f'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.B_deep_left = tsd(t*1e4,Sp);
    end
    
    try,load('ChannelsToAnalyse/PFCx_deep_right.mat')
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.P_deep_right = tsd(t*1e4,Sp);
    catch
        eval(['load LFPData/LFP',num2str(channel)])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        eval(['save SpectrumDataL/Spectrum',num2str(channel),' Sp t f'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.P_deep_right = tsd(t*1e4,Sp);
    end
    
    try,load('ChannelsToAnalyse/PFCx_deep_left.mat')
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.P_deep_left = tsd(t*1e4,Sp);
    catch
        eval(['load LFPData/LFP',num2str(channel)])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        eval(['save SpectrumDataL/Spectrum',num2str(channel),' Sp t f'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.P_deep_left = tsd(t*1e4,Sp);
    end
    
    % load freezing
    clear FreezeEpoch FreezeAccEpoch
    load('behavResources.mat')
    
    if exist('FreezeAccEpoch')
        FreezeEpoch = FreezeAccEpoch;
    end
    
    % clean freezing
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,timeatTransition*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    % restrict to laser period
    FreezeEpoch = and(FreezeEpoch,intervalSet(600*1e4,1500*1e4));
    
    StructName = fieldnames(Sptsd);
    
    for ep = 1:length(Start(FreezeEpoch))
        ActualEpoch=subset(FreezeEpoch,ep);
        % Onset
        LittleEpoch=intervalSet(Start(ActualEpoch)-(timeatTransition-1)*1e4,Start(ActualEpoch)+timeatTransition*1e4);
        for st = 1 : length(StructName)
            Spec=Data(Restrict(Sptsd.(StructName{st}),LittleEpoch));
            for sp=1:length(f)
                Spectro_AllMice_Onset.(StructName{st}){m}(ep,sp,:)=interp1([1/size(Spec,1):1/size(Spec,1):1],Spec(:,sp),tps); hold on
            end
        end
        
        % Offset
        LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+(timeatTransition-1)*1e4);
        for st = 1 : length(StructName)
            Spec=Data(Restrict(Sptsd.(StructName{st}),LittleEpoch));
            for sp=1:length(f)
                Spectro_AllMice_Offset.(StructName{st}){m}(ep,sp,:)=interp1([1/size(Spec,1):1/size(Spec,1):1],Spec(:,sp),tps); hold on
            end
        end
    end
    
end

figure
for m = 1:length(Spectro_AllMice_Offset.B_deep)
    m
    subplot(311)
    imagesc(log(squeeze(nanmean(Spectro_AllMice_Offset.B_deep{m})))), axis xy
    subplot(312)
    imagesc(log(squeeze(nanmean(Spectro_AllMice_Offset.B_deep_right{m})))), axis xy
    subplot(313)
    imagesc(log(squeeze(nanmean(Spectro_AllMice_Offset.B_deep_left{m})))), axis xy
    pause
    clf
end

GFP = [4,5,6,10];
CHR = [1,2,3,7,8,9,11,12,13];
CHRside = [1,2,2,1,1,1,1,1,1];
FreqRange=[3,6];



AllOnsetGFP = [];
AllOffsetGFP = [];
AllOnsetGFP_FreBand = [];
AllOffsetGFP_FreBand = [];
for m = 1:length(GFP)
    AllOnsetGFP(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Onset.P_deep_right{GFP(m)})))./nanmean((Spectro_AllMice_Onset.P_deep_right{GFP(m)}(:)));
    AllOffsetGFP(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Offset.P_deep_right{GFP(m)})))./nanmean((Spectro_AllMice_Offset.P_deep_right{GFP(m)}(:)));
    
    dattemp = squeeze(nanmean(AllOnsetGFP(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    AllOnsetGFP_FreBand(m,:)=dattemp;
    
    dattemp = squeeze(nanmean(AllOffsetGFP(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    AllOffsetGFP_FreBand(m,:)=dattemp;
end

AllOnsetCHR2 = [];
AllOffsetCHR2 = [];
AllOffsetCHR2_FreBand = [];
AllOnsetCHR2_FreBand = [];

for m = 1:length(CHR)
    if CHRside(m) ==1
        AllOnsetCHR2(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Onset.P_deep_left{CHR(m)})))./nanmean((Spectro_AllMice_Onset.P_deep_left{CHR(m)}(:)));
        AllOffsetCHR2(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Offset.P_deep_left{CHR(m)})))./nanmean((Spectro_AllMice_Offset.P_deep_left{CHR(m)}(:)));
        AllOnsetCHR2_FreBand(m,:)=squeeze(nanmean(AllOnsetCHR2(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
        AllOffsetCHR2_FreBand(m,:)=squeeze(nanmean(AllOffsetCHR2(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
        
    else
        AllOnsetCHR2(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Onset.P_deep_right{CHR(m)})))./nanmean((Spectro_AllMice_Onset.P_deep_right{CHR(m)}(:)));
        AllOffsetCHR2(m,:,:) = (squeeze(nanmean(Spectro_AllMice_Offset.P_deep_right{CHR(m)})))./nanmean((Spectro_AllMice_Offset.P_deep_right{CHR(m)}(:)));
        
    end
    
    dattemp = squeeze(nanmean(AllOnsetCHR2(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    AllOnsetCHR2_FreBand(m,:)=dattemp;
    
    dattemp = squeeze(nanmean(AllOffsetCHR2(m,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'),:)));
    dattemp=dattemp-min(dattemp);dattemp=dattemp/max(dattemp);
    AllOffsetCHR2_FreBand(m,:)=dattemp;
end

figure
subplot(121)
plot(tps,fliplr((AllOffsetGFP_FreBand)'),'r')
hold on
plot(tps,fliplr((AllOnsetGFP_FreBand)'),'k')
title('GFP')
legend('OFF','ON')
subplot(122)
plot(tps,fliplr((AllOffsetCHR2_FreBand)'),'r')
hold on
plot(tps,fliplr((AllOnsetCHR2_FreBand)'),'k')
title('CHR2')

figure
subplot(211)
plot(nanmean(AllOnsetGFP_FreBand),'k')
hold on
plot(fliplr(nanmean(AllOffsetGFP_FreBand)),'r')
subplot(212)
plot(nanmean(AllOnsetCHR2_FreBand),'k')
hold on
plot(fliplr(nanmean(AllOffsetCHR2_FreBand)),'r')


figure
subplot(221)
imagesc([-3:1:3],f,(squeeze(log(nanmean(AllOnsetGFP,1))))), axis xy
title('GFP - onset')
colormap jet
line([0 3],[17 17],'color','c','linewidth',3)
clim([-1.8 1.8])
xlabel('')
subplot(222)
imagesc([-3:1:3],f,(squeeze(log(nanmean(AllOffsetGFP,1))))), axis xy
title('GFP - offset')
colormap jet
clim([-1.8 1.8])
line([-3 0],[17 17],'color','c','linewidth',3)
subplot(223)
imagesc([-3:1:3],f,(squeeze(log(nanmean(AllOnsetCHR2,1))))), axis xy
title('GFP - onset')
colormap jet
line([0 3],[17 17],'color','c','linewidth',3)
clim([-1.8 1.8])
xlabel('')
subplot(224)
imagesc([-3:1:3],f,(squeeze(log(nanmean(AllOffsetCHR2,1))))), axis xy
title('GFP - offset')
colormap jet
clim([-1.8 1.8])
line([-3 0],[17 17],'color','c','linewidth',3)


hold on
plot(fliplr(nanmean(AllOffsetGFP_FreBand)),'r')
subplot(212)
plot(nanmean(AllOnsetCHR2_FreBand),'k')
hold on
plot(fliplr(nanmean(AllOffsetCHR2_FreBand)),'r')
