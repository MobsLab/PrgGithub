%22.09.2016 for Mouse 390, rampe during calm wake
%01.07.2016 puis 17.08.2016
sav=0;
% for 390
csFlag=1; 
freezFlag=1; 
cd /media/DataMobs31/OPTO_CHR2_DATA/Mouse-390/20160919-stim_opto-rampe/FEAR-Mouse-390-19092016
% cd /media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-SLEEP-laser/FEAR-Mouse-367-04072016

res=pwd;
ind_mark=strfind(res,'/');
%structlist={'Bulb_left','PFCx_left','PFCx_right','dHPC_deep','PiCx'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
structlist={'Bulb_right','PFCx_deep_right','Bulb_left','PFCx_deep_left','dHPC_deep','PiCx_right','PiCx_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
%structlist={'Bulb_sup_right','Bulb_right','Bulb_ventral_right','Bulb_sup_left','Bulb_left','Bulb_ventral_left','LaserInput'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
if  ~exist('man', 'var')
    man=1;
end
Dir.path{man}=pwd;

%for i=1:length(structlist), allfig(i)=figure('Color',[1 1 1],'Position', [100 10 1600 900]);end
figure('Position',[105          89        1853         885]);

temp=load('LFPData/LFP32.mat');
LaserLFP=temp.LFP;
%for visual check
hold on, plot(Range(LaserLFP)*1E-4, Data(LaserLFP)*1E-4)
plot(Range(LaserLFP)*1E-4, Data(LaserLFP)*1E-4)

%StimLaserOFF=thresholdIntervals(LaserLFP,-500,'Direction','Above');
StimLaserOFF=thresholdIntervals(LaserLFP,-0.1,'Direction','Above');
soff= Start(StimLaserOFF);
eoff= End(StimLaserOFF);
for k=1:length(Start(StimLaserOFF))
 plot([eoff(k)*1E-4 eoff(k)*1E-4], [0.1 0.1],'LineWidth', 20,'Color','g')
end
StimLaserOFF2=dropShortIntervals(StimLaserOFF,2*1E4);% for 0.5Hz, off ISI are=1sec. 1.5 threshold should be ok
soff2= Start(StimLaserOFF2);
eoff2= End(StimLaserOFF2);
for k=1:length(Start(StimLaserOFF2))
 plot([eoff2(k)*1E-4 eoff2(k)*1E-4], [0.1 0.1],'LineWidth', 20,'Color','r')
end

TotEpoch=intervalSet(0, eoff(end));
StimLaserON=TotEpoch-StimLaserOFF;
if sav
save behavResources StimLaserON StimLaserOFF -Append
end
%%% recupere les données behavior - CS+ et CS-
if csFlag
    if ~isempty(strfind(Dir.path{man},'DataMobs31'))
        behav_folder=[res '-wideband'];
        list_behav=dir([res '-wideband']);
        for i=1:length(list_behav)
            if (length(list_behav(i).name)>3 && strcmp(list_behav(i).name(end-3:end),'.mat') && strcmp(list_behav(i).name(1:4),'FEAR'))
                temp=load([behav_folder,'/',list_behav(i).name]);
                TTL=temp.TTL;
                PosMat=temp.PosMat;
            end
        end

        if sav
            save behavResources TTL PosMat -Append
        end
    else
        if sav
        load behavResources TTL PosMat
        end
    end
    CSminus=TTL(:,2)==4;
    CSplus=TTL(:,2)==3;
end
    
%%% recupere les données behavior freezing
if freezFlag
    load behavResources Movtsd FreezeEpoch
    th_immob=1.5;
    thtps_immob=2;
     FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
end
% ompute and plot spectrogram
for i=1:length(structlist)

    temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
    try
        load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
        disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
    catch
        if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
        eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
        disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
        [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
        if sav
            eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
        end
    end
    Stsd=tsd(t*1E4,Sp);
    subplot(length(structlist),6,1+(i-1)*6:6*i)
    imagesc(t,f,10*log10(Sp')),axis xy
    ylabel(structlist{i})
    hold on, plot([Start(StimLaserON)*1E-4 End(StimLaserON)*1E-4],[16 16],'-k','LineWidth',2)
    hold on, plot([Start(StimLaserON)*1E-4 End(StimLaserON)*1E-4],[16 16],'-w','LineWidth',2,'LineStyle',':')
    
    if ~isempty(strfind(res,'FEAR-Mouse-366-17062016'))
        plot([0 2400],[0.05 0.05],'-','Color',[0.5 0.5 0.5],'LineWidth',2)
        plot([0 1800],[0 0],'-','Color',[0.5 0.5 0.5],'LineWidth',2)
        plot([3800 4220],[0.5 0.5],'-','Color',[0.5 0.5 0.5],'LineWidth',2)
        xlim([2400 7052])
    end
    
    if csFlag
        plot([TTL(CSminus,1) TTL(CSminus,1)+1],19.5*ones(size(CSminus,2),2),'Color','k','LineWidth',3)
        plot([TTL(CSplus,1) TTL(CSplus,1)+1],19.5*ones(size(CSplus,2),2),'Color','r','LineWidth',3)
    end
    
    if freezFlag
        if strcmp(structlist(i),'PiCx') || strcmp(structlist(i),'Bulb_deep')
            plot(Range(Movtsd)*1E-4,Data(Movtsd)*0.5,'Color',[0.5 0.5 0.5 ])
        end
        plot([Start(FreezeEpoch) End(FreezeEpoch)]*1E-4,[12 12],'-k','LineWidth',2)
    end
    
    if i==1
        title (res(ind_mark(end-1):end))
    end
end

if sav
    % set(gcf,'PaperPosition', [0.6345175                  6.345175           34 21])
    set(gcf,'PaperPosition', [0.6345175                  6.345175                  30                 20])
    saveas(gcf,'spectrolaser_bulb_laser.fig')
    saveas(gcf,'spectrolaser_bulb_laser.png')
end








% hold on
% 
%  
% StimLaserON=dropShortIntervals(StimLaserON,1*1E4);
%  line([Start(StimLaserON) End(StimLaserON)],[15 15],'Color','k','LineWidth',1)
% line([Start(StimLaserON) End(StimLaserON)],[10 10],'Color','k','LineWidth',1)
% ss=Start(StimLaserON) ;
% line([Start(StimLaserON) End(StimLaserON)],[1 1],'Color','k','LineWidth',1)
% ylim([-2 2])
% plot(s,'*k')
% figure
% imagesc(t,f,10*log10(Sp')),
%  axis xy
% hold on
% plot(s,10,'*k')
% plot(s(:),10,'*k')
% plot(s(:),10*ones(size(s),'*k')
% ??? plot(s(:),10*ones(size(s),'*k')
%                                    |
% Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
%  
% plot(s(:),10*ones(size(s)),'*k')
% plot(s(:)*1E-4,10*ones(size(s)),'*k')
% figure
% imagesc(t,f,10*log10(Sp')),
% axis xy
% hold on
%  figure, plot(Range(LFP)*1E-4, Data(LFP)*1E-4)
% StimLaserON=thresholdIntervals(LFP,-0.05,'Direction','Above');
% StimLaserOFF=thresholdIntervals(LFP,-0.05,'Direction','Above');
%  StimLaserOFF=dropShortIntervals(StimLaserOFF,1*1E4);
% hold on,  line([Start(StimLaserOFF) End(StimLaserOFF)],[1 1],'Color','k','LineWidth',1)
%  soff=Start(StimLaserOFF);
% hold on,  line([Start(StimLaserOFF)*1E-4 End(StimLaserOFF)*1E-4],[1 1],'Color','k','LineWidth',1)
% hold on,  line([Start(StimLaserOFF)*1E-4 End(StimLaserOFF)*1E-4],[0.1 0.1],'Color','k','LineWidth',1)
% TotEpoch=IntervalSet(0,Range(LFP(end)));
% ??? Error using ==> intervalSet.intervalSet at 125
% s and e must be of the same length
%  
% TotEpoch=intervalSet(0, End(StimLaserOFF)(end));
% ??? Error: ()-indexing must appear last in an index expression.
%  
% eoff= End(StimLaserOFF);
% TotEpoch=intervalSet(0, eoff(end));
% StimLaserON=TotEpoch-StimLaserOFF;
% line([Start(StimLaserON) End(StimLaserON)],[0.2 0.2,'Color','rk','LineWidth',1)
% ??? line([Start(StimLaserON) End(StimLaserON)],[0.2 0.2,'Color','rk','LineWidth',1)
%                                                                                   |
% Error: Unbalanced or unexpected parenthesis or bracket.
%  
% line([Start(StimLaserON) End(StimLaserON)],[0.2 0.2,'Color','r','LineWidth',1)
% ??? line([Start(StimLaserON) End(StimLaserON)],[0.2 0.2,'Color','r','LineWidth',1)
%                                                                                  |
% Error: Unbalanced or unexpected parenthesis or bracket.
%  
% line([Start(StimLaserON) End(StimLaserON)],[0.2 0.2],'Color','r','LineWidth',1)
