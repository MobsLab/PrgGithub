% AnalyseGroomingML.m
% find 4Hz episods not related to freezing

%% find data with good PFCx channel and video
Dir=PathForExperimentsML('BASAL');
Dir=RestrictPathForExperiment(Dir,'Group','WT');

a=[];
for man=1:length(Dir.path)
    cd(Dir.path{man})
    clear Movtsd channel t f Sp 
    if exist('behavResources.mat','file') && exist('ChannelsToAnalyse/PFCx_deep.mat','file') 
        load('behavResources.mat','Movtsd');
        load('ChannelsToAnalyse/PFCx_deep.mat','channel');
        try
            Movtsd;
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])
            disp(['SpectrumDataL/Spectrum',num2str(channel),'.mat was loaded'])
            disp([num2str(length(a)+1),'- ',Dir.path{man}]); a=[a,man];
            figure, imagesc(t,f,10*log10(Sp)'), axis xy,
            hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
            title(Dir.path{man});
        end
    end
end
% do not use:
no=[1 14];
maybe=[18:20];
hope=[2:5,21:23,15:16,7];

[params,movingwin,suffix]=SpectrumParametersML('ultralow');

%% Data with respi but bad PFCx LFP

% grooming on video:
% - 220s (3'40 sur video -01-)
% - 850s (7'33 sur video -03-)

    cd /media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse242-newwifi/20150224/RESPI-Mouse-242-24022015
    
    [params,movingwin,suffix]=SpectrumParametersML('low');
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),
    
    % --------- respi ---------------
    clear t f Sp filRespi Movtsd
    disp('... loading filRespi from Respiration.mat')
    load('Respiration.mat')
    LFP_temp=ResampleTSD(filRespi,params.Fs);
    [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
    
    subplot(3,1,1), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([-20 40])
    title('Plethysmo Breathing signal spectrum (+ movement k)')
    
    
    % --------- mouvement ---------------
    load('behavResources.mat','Movtsd')
    disp('... loading Movtsd from behavResources.mat')
    hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
    xlim([0,1916])
    
    % --------- Bulb ---------------
    clear t f Sp ch
    ch=load('ChannelsToAnalyse/Bulb_deep.mat');
    disp(['... loading Bulb_deep : SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'])
    eval(['load(''SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'');'])
    
    subplot(3,1,2), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
    hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
    title('Bulb-deep spectrum')
    xlim([0,1916])
    
    
    % --------- PFCx ---------------
    clear t f Sp ch
    ch=load('ChannelsToAnalyse/PFCx_deep.mat');
    disp(['... loading PFCx_deep : SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'])
    eval(['load(''SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'');'])
    
    subplot(3,1,3), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([15 45]);
    hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
    title('PFCx-deep spectrum')
    xlim([0,1916])
    
    
if 0
    try
        saveFigure(gcf,'Grooming4Hz-Mouse242-20150224','~/Dropbox/MOBsProjetBULB/FiguresGrooming/')
    catch
        saveFigure(gcf,'Grooming4Hz-Mouse242-20150224','~/Dropbox/MOBS-ProjetAstro/FiguresGrooming/')
    end
end





%% Data without respi but good PFCx LFP

    
    cd /media/DataMOBsRAID/ProjetAstro/Mouse242/20150223/BULB-Mouse-242-23022015
    
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),
    
    % --------- Movement ---------------
    clear Movtsd tpsdeb
    load('behavResources.mat','Movtsd','tpsdeb')
    
    % --------- Bulb ---------------
    clear t f Sp ch
    ch=load('ChannelsToAnalyse/Bulb_deep.mat');
    disp(['... loading Bulb_deep : SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'])
    eval(['load(''SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'');'])
    
    subplot(2,1,1), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
    hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
    title(pwd)
    ylabel('Bulb-deep spectrum')
    for i=1:length(tpsdeb), line([tpsdeb{i},tpsdeb{i}],[0 20],'Color','k','Linewidth',2);end
    line(xlim,[4 4],'Color','k')
    
    % --------- PFCx ---------------
    clear t f Sp ch
    ch=load('ChannelsToAnalyse/PFCx_deep.mat');
    disp(['... loading PFCx_deep : SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'])
    eval(['load(''SpectrumDataL/Spectrum',num2str(ch.channel),'.mat'');'])
    
    subplot(2,1,2), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 55]);
    hold on, plot(Range(Movtsd,'s'),rescale(double(Data(Movtsd)),10,15),'k')
    ylabel('PFCx-deep spectrum')
    for i=1:length(tpsdeb), line([tpsdeb{i},tpsdeb{i}],[0 20],'Color','k','Linewidth',2);end
    line(xlim,[4 4],'Color','k')
    xlabel('Time (s)')
    
if 0
    try
        saveFigure(gcf,'Grooming4Hz-Mouse242-20150223','~/Dropbox/MOBsProjetBULB/FiguresGrooming/')
    catch
        saveFigure(gcf,'Grooming4Hz-Mouse242-20150223','~/Dropbox/MOBS-ProjetAstro/FiguresGrooming/')
    end
    
end




%% Adapt sepctrum to low range
a=2;
%Dir.path{1}='/media/DataMOBsRAID/ProjetAstro/Mouse242/20150223/BULB-Mouse-242-23022015';a=1;
if 1
    cd(Dir.path{a})
    [params,movingwin,suffix]=SpectrumParametersML('ultralow');
    I=intervalSet(10071*1E4,11269*1E4);
    Test_win={[5 0.2],[4 0.2]};
    Test_tap={[3 5],[1 2]};
    smo=[2 2];
    
    figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),
    
    % --------- Movement ---------------
    clear Movtsd tpsdeb
    load('behavResources.mat','Movtsd','tpsdeb')
    a(1)=tpsdeb{4}+53*60+27;
    a(2)=tpsdeb{4}+60*60+15;
    
    % --------- Bulb ---------------
    clear LFP ch
    ch=load('ChannelsToAnalyse/Bulb_deep.mat');
    disp(['... loading Bulb_deep : LFPData/LFP',num2str(ch.channel),'.mat'])
    eval(['load(''LFPData/LFP',num2str(ch.channel),'.mat'');'])
    LFP_temp=Restrict(LFP,I);
    for w=1:length(Test_win)
        for p=1:length(Test_tap)
            clear t f Sp
            params.tapers=Test_tap{p};
            movingwin=Test_win{w};
            [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
            subplot(2,length(Test_tap)*length(Test_win),(w-1)*length(Test_tap)+p),
            imagesc(t,f,10*log10(SmoothDec(Sp,smo))'), axis xy, caxis([20 65]);
            hold on, plot(Range(Restrict(Movtsd,I),'s')-Start(I,'s'),rescale(double(Data(Restrict(Movtsd,I))),6,10),'k')
            if w+p==2, ylabel('Bulb-deep spectrum');end
            line(xlim,[4 4],'Color','k')
            line([a(1),a(2)]-Start(I,'s'),[4 4 ],'Color','g','Linewidth',2)
            title(['tapers = [',num2str(params.tapers(1)),' ',num2str(params.tapers(2)),...
                '], movingwin = [',num2str(movingwin(1)),' ',num2str(movingwin(2)),']'])
        end
    end
    
   
    
    % --------- PFCx ---------------
    clear LFP ch
    ch=load('ChannelsToAnalyse/PFCx_deep.mat');
    disp(['... loading PFCx_deep : LFPData/LFP',num2str(ch.channel),'.mat'])
    eval(['load(''LFPData/LFP',num2str(ch.channel),'.mat'');'])
    LFP_temp=Restrict(LFP,I); 
    for w=1:length(Test_win)
        for p=1:length(Test_tap)
            clear t f Sp
            params.tapers=Test_tap{p};
            movingwin=Test_win{w};
            [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
            subplot(2,length(Test_tap)*length(Test_win),(w+1)*length(Test_tap)+p),
            imagesc(t,f,10*log10(SmoothDec(Sp,smo))'), axis xy, caxis([20 65]);
            hold on, plot(Range(Restrict(Movtsd,I),'s')-Start(I,'s'),rescale(double(Data(Restrict(Movtsd,I))),6,10),'k')
            if w+p==2, ylabel('PFCx-deep spectrum');end
            line(xlim,[4 4],'Color','k')
            line([a(1),a(2)]-Start(I,'s'),[4 4 ],'Color','g','Linewidth',2)
        end
        xlabel('Time (s)')
    end
end






