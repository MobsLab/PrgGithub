% script Plot_RespiLFP_ML.m
% chose between inputs

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scrsz = get(0,'ScreenSize');
ploUniqueBOAndRespi=1;
ploAllLFPChannels=0;
ComputeAllSpectro=0;
ploSpectro=0;
NameEpoch='REMEpoch'; %0 if no Restriction
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% PLOT RESPI + Unique BO LFP %%%%%%%%%%%%%%%%%%%%%%%%%%
if ploUniqueBOAndRespi
    clear InfoLFP LFP channel NormRespiTSD LFP
    
    load('LFPData/InfoLFP.mat')
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    try load('LFPData.mat','NormRespiTSD'); catch,  load('Respiration.mat','NormRespiTSD');end
%     load('SpectrumDataL/UniqueChannelBulb.mat')
%     load(['LFPData/LFP',num2str(channelToAnalyse),'.mat'])
%     FilRespi=FilterLFP(NormRespiTSD,[0.1 20],128);
%     FilBO=FilterLFP(LFP,[0.1 20],128);
    FilRespi=NormRespiTSD;
    FilBO=FilterLFP(LFP,[1 10],1024);
    lfpBO=LFP;
    
    if NameEpoch~=0
        eval(['load(''StateEpoch.mat'',''',NameEpoch,'''); epoch=',NameEpoch,';'])
        FilRespi=Restrict(FilRespi,epoch);
        lfpBO=Restrict(lfpBO,epoch);
        FilBO=Restrict(FilBO,epoch); st=min(Start(epoch,'s'));
        legAd=[' -',NameEpoch];
    else
        legAd=[];st=0;
    end
    
    if length(NameEpoch)==1 || ~isempty(Start(epoch,'s'))
        figure('Color',[1 1 1]),
        plot(Range(FilRespi,'s'),rescale(-Data(FilRespi),1,2),'Color',[0.5 0.5 0.5],'Linewidth',2)
        hold on, plot(Range(FilBO,'s'),rescale(Data(FilBO),1,2),'k')
        hold on, plot(Range(lfpBO,'s'),rescale(Data(lfpBO),0,1),'Linewidth',2)
        hold on, plot(Range(FilBO,'s'),rescale(Data(FilBO),0,1),'k')
        legend({'-Respi' 'Filtered LFP' 'LFP'})
        xlim([st st+10]), ylim([0 2])
        title([pwd, legAd])
    else
        disp('No data')
    end
    %a=xlim; xlim([a(1)+10 a(2)+10]);ylim([-0.02 0.02])
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% PLOT RESPI + Unique BO LFP %%%%%%%%%%%%%%%%%%%%%%%%%%
if ploAllLFPChannels
    
    clear InfoLFP LFP channel
    colori={'g','k','r','y','b','c'};
    load('LFPData/InfoLFP.mat')
    Ust=unique(InfoLFP.structure);
    
    load('LFPData.mat','RespiTSD');

    color={'b','r','k','g','c','m','y',[0.5 0.5 0.5],[0.5 0.1 0.1]};
    try 
        i_temp=InfoLFP.channel(find(strcmp(InfoLFP.structure,'Bulb')));
        eval(['loadTemp=load(''LFPData/LFP',num2str(i_temp(1)),'.mat'');']) 
        lfp=loadTemp.LFP;
        AdjustRespToLFP=mean(abs(Data(lfp)))/mean(abs(Data(RespiTSD)));
    catch
        i_temp=InfoLFP.channel(find(strcmp(InfoLFP.structure,'dHPC')));
        eval(['loadTemp=load(''LFPData/LFP',num2str(i_temp(1)),'.mat'');']) 
        lfp=loadTemp.LFP;
        AdjustRespToLFP=mean(abs(Data(lfp)))/mean(abs(Data(RespiTSD)));
    end
    
    
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2])
    legendL={};a=1;b=1;
    try
        Ustruct=unique(InfoLFP.structure);
        for i=1:length(Ustruct)
            for j=InfoLFP.channel(find(strcmp(InfoLFP.structure,Ustruct(i))))
                clear lfp
                eval(['loadTemp=load(''LFPData/LFP',num2str(j),'.mat'');'])
                lfp=loadTemp.LFP;
                try
                    InfoLFP.hemisphere(1);
                    if strcmp(InfoLFP.hemisphere(InfoLFP.channel==j),'Left')
                        hold on, plot(Range(lfp,'s'),Data(lfp)+a*0.0009,color{i}); a=a+1;
                        legendL=[legendL,{[Ustruct{i},'_L -Ch',num2str(j)]}];xlim([0,max(Range(lfp,'s'))])
                    else
                        hold on, plot(Range(lfp,'s'),Data(lfp)-b*0.0009,'Color',color{i}); b=b+1;
                        legendL=[legendL,{[Ustruct{i},'_R -Ch',num2str(j)]}];xlim([0,max(Range(lfp,'s'))])
                    end
                catch
                    hold on, plot(Range(lfp,'s'),Data(lfp)-b*0.0009,'Color',color{i}); b=b+1;
                    legendL=[legendL,{[Ustruct{i},' -Ch',num2str(j)]}];xlim([0,max(Range(lfp,'s'))])
                end
            end
        end
    catch
        keyboard
    end
    hold on, plot(Range(RespiTSD,'s'),Data(RespiTSD)*AdjustRespToLFP,'Color',color{end}); xlim([0,max(Range(lfp,'s'))])
    legend([legendL,'Respiration (mL/s)'])
    title(pwd);
    
    
    disp('Keyboard to zoom on data and choose channels to analyse');
    res=pwd;
    if ~exist([res,'/ChannelsToAnalyse'],'dir'), mkdir(res,'ChannelsToAnalyse');end
    if ~exist([res,'/ChannelsToAnalyse/PaCx_sup.mat'],'file'), keyboard; channel=input('LFPPaCx sup='); save([res,'/ChannelsToAnalyse/PaCx_sup'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'file'),  keyboard; channel=input('LFPPaCx deep='); save([res,'/ChannelsToAnalyse/PaCx_deep'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'file'),  keyboard; channel=input('LFPPFCx sup='); save([res,'/ChannelsToAnalyse/PFCx_sup'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'file'),  keyboard; channel=input('LFPPFCx deep='); save([res,'/ChannelsToAnalyse/PFCx_deep'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/Bulb_sup.mat'],'file'),  keyboard; channel=input('LFPBulb sup='); save([res,'/ChannelsToAnalyse/Bulb_sup'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'file'),  keyboard; channel=input('LFPBulb deep='); save([res,'/ChannelsToAnalyse/Bulb_deep'],'channel');end
    if ~exist([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'file'),  keyboard; channel=input('LFPdHPC pyr='); save([res,'/ChannelsToAnalyse/dHPC_deep'],'channel');end
    close
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% ComputeAllSpectrogramsML %%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ComputeAllSpectro
    struct={'PFCx' 'PaCx' 'Bulb' 'dHPC' 'PFCx' 'PaCx' 'Bulb' };
    depthstruct={'deep' 'deep' 'deep' 'deep' 'sup' 'sup' 'sup'};
    for i=1:length(struct)
        disp(' ')
        disp(['ComputeAllSpectrogramsML(''PLETHYSMO'',''high'',',struct{i},',',depthstruct{i},')'])
        ComputeAllSpectrogramsML('PLETHYSMO','high',struct{i},depthstruct{i});
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% PLOT SPECTROGRAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ploSpectro
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SpL_BO=Sp; t_BO=t; f_BO=f;
    
    load('ChannelsToAnalyse/PaCx_deep.mat')
    load(['SpectrumDataH/Spectrum',num2str(channel),'.mat'])
    SpH_PA=Sp; t_PA=t; f_PA=f;
    
    figure, 
    subplot(2,1,1), imagesc(t_BO,f_BO,10*log10(SpL_BO)');axis xy;
    title('spectrum low BO');
    subplot(2,1,2), imagesc(t_PA,f_PA,10*log10(SpH_PA)');axis xy;
    title('spectrum high PA');
    
    
    load('LFPData','RespiTSD')
    FilRespi=FilterLFP(RespiTSD,[0.1 20],128);
    
    I=intervalSet(1*1E4,200*1E4);
    tempRespi=Data(Restrict(FilRespi,I));
    
    [temp_tA,temp_SpA]=SpectroEpochML(SpH_PA,t_PA,f_PA,I);
    ResampPA_FilRespi=resample(tempRespi,size(temp_SpA,1),length(tempRespi));
    C_PA = xcorr2(ResampPA_FilRespi,temp_SpA);
    figure, imagesc(temp_tA,f_PA,10*log10(C-min(min(C_PA)))');axis xy;
    
    [temp_tBO,temp_SpBO]=SpectroEpochML(SpL_BO,t_BO,f_BO,I);
    ResampBO_FilRespi=resample(tempRespi,size(temp_SpA,1),length(tempRespi));
    C_BO = xcorr2(ResampBO_FilRespi,temp_SpA);
    figure, imagesc(temp_tA,f_PA,10*log10(C-min(min(C_BO)))');axis xy;
    
end

