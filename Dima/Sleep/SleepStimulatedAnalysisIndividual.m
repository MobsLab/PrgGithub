% EMG
load('ChannelsToAnalyse/PFCx_sup.mat');
load(['SpectrumDataH/Spectrum' num2str(channel) '.mat']);
Sp_high = Sp; t_high = t; f_high = f;
clearvars -except t_high f_high Sp_high
Sptsd_high = tsd(t_high*1e4,Sp_high);
% Hipppocampus
load('ChannelsToAnalyse/dHPC_deep.mat');
load(['SpectrumDataL/Spectrum' num2str(channel) '.mat']);
Sp_low = Sp; t_low = t; f_low = f;
Sptsd_low = tsd(t_low*1e4,Sp_low);
clearvars -except t_high f_high Sp_high t_low f_low Sp_low Sptsd_high Sptsd_low

% Load support
load('behavResources.mat', 'TTLInfo', 'PosMat');
Intensities = [0:0.5:2];

% Find indices of stims for each intensity
G = find(~isnan(PosMat(:,4)));
G = [G,[1:length(G)]'];
for i=1:length(Intensities)
    a=1;
    idxCam{i} = find(PosMat(:,4)==Intensities(i));
    for j = 1:length(G)
        if PosMat(G(j,1),4) == Intensities(i)
            idxTTL{i}(a) = G(j,2);
            a=a+1;
        end
    end
end


StimTime = Start(TTLInfo.StimEpoch);
StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-3e2,End(TTLInfo.StimEpoch)+14e2);

% EMG
for i=300:325
    figure('units','normalized', 'outerposition', [0 1 0.6 0.45])
    title([num2str(PosMat(G(i),4)) ' V'])
    IS = intervalSet(StimTime(i)-3e4,StimTime(i)+3*1e4);
    dat = Data(Restrict(Sptsd_high, (IS-subset(StimEpoch,i))));
    subplot(121)
    imagesc(Range(Restrict(Sptsd_high,(IS-subset(StimEpoch,i))),'s'),f_high(33:73),10*log10(dat(:,33:73)'));
    axis xy
    caxis([0 40]);
    
    subplot(122)
    plot(Range(Restrict(Sptsd_high,(IS-subset(StimEpoch,i))),'s'), mean(dat(:,33:73),2));
    line(xlim,[80 80],'color','r');
    ylim([0 200])
    title(num2str(PosMat(G(i),4)))
    
end

%%
ind_610 = find(f_low>6&f_low<10);
Sp_610 = Sp_low(:,ind_610);
Stsd_610=tsd(t_low*1E4,Sp_610);

ind_36 = find(f_low>3&f_low<6);
Sp_36 = Sp_low(:,ind_36);
Stsd_36=tsd(t_low*1E4,Sp_36);