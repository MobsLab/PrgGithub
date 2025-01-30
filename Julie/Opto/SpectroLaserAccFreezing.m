% SpectroLaserAccFreezing

%21.11.2016 : remove NoiseEpochRemoval car cela genere un decalage entre les infos son-laser et le comportement
% 01.07.2016 puis 17.08.2016
% called by RunSpectroLaser.m

% plot spectrograms of different structures, and on the top
% - movement (webcam tracking)
% - CS+, CS- and laser stimulation
% - freezing period defined by movement from tracking

% caution : written for CS+ =white noise

% save a figure spectrolaser.png
% see exampe :   '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';

res=pwd;
ind_mark=strfind(res,'/');
%structlist={'LaserInput','Bulb_deep_left','PFCx_deep_left','PFCx_deep_right','Bulb_deep_right','dHPC_deep','PiCx_right'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
% structlist={'Bulb_ecoG_right','Bulb_deep_right','Bulb_ventral_right','PiCx_right','Bulb_ecoG_left','Bulb_deep_left','Bulb_ventral_left','PiCx_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
%structlist={'LaserInput'};
structlist={'Bulb_deep_left','PFCx_deep_left','PFCx_deep_right','Bulb_deep_right','dHPC_deep','PiCx_right'};%


[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
if  ~exist('man', 'var')
    man=1;
end
Dir.path{man}=pwd;

%figure('Position',[105          89        1853         200],'PaperPosition', [0.6345175                  6.345175                  30                 4])
figure('Position',[105          89        1853         885],'PaperPosition', [0.6345175                  6.345175                  30                 24])

% temp=load('LFPData/LFP32.mat');
% LaserLFP=temp.LFP;
% % for visual check
% figure,hold on, plot(Range(LaserLFP)*1E-4, Data(LaserLFP)*1E-4)
% %plot(Range(LaserLFP)*1E-4, Data(LaserLFP)*1E-4)
% figure, hist(Data(LaserLFP),1000)
% 
% StimLaserOFF=thresholdIntervals(LaserLFP,-300,'Direction','Above');
% StimLaserOFF=dropShortIntervals(StimLaserOFF,0.5*1E4);
% soff= Start(StimLaserOFF);
% eoff= End(StimLaserOFF);
% TotEpoch=intervalSet(0, eoff(end));
% StimLaserON=TotEpoch-StimLaserOFF;
% save behavResources StimLaserON StimLaserOFF -Append
% 

%% Build  StimLaserON  and StimLaserOFF
try load behavResources StimLaserON StimLaserOFF 
    StimLaserON; StimLaserOFF;
catch
    try
    temp=load('LFPData/LFP32.mat');
    LaserLFP=temp.LFP;
    % for debug : 
    figure,hold on, plot(Range(LaserLFP)*1E-4, Data(LaserLFP))
    RangeLFPlaser=Range(LaserLFP);
    figure, hist(Data(LaserLFP),[-600 :100 :600])
    [n,xout]=hist(Data(LaserLFP),[-600 :100 :600]); % large bin to have all values of each state(On/Off) in only one bin
    [nsorted,IX]=sort(n,'descend');

    thresh=(xout(IX(1))+xout(IX(2)))/2;
    if xout(IX(1)) >xout(IX(2))
        StimLaserON=thresholdIntervals(LaserLFP,thresh,'Direction','Below');
    else
        StimLaserON=thresholdIntervals(LaserLFP,thresh,'Direction','Above');
    end
        StimLaserON=mergeCloseIntervals(StimLaserON,0.5*1E4);
    % 
    % StimLaserOFF=dropShortIntervals(StimLaserOFF,0.5*1E4);
    % soff= Start(StimLaserOFF);
    % eoff= End(StimLaserOFF);
    % StimLaserOFF=intersect(StimLaserOFF,intervalSet(58*1E4, eoff(end))); % remove what is detected during 1st minute (no laser)
    TotEpoch=intervalSet(0, RangeLFPlaser(end));

    StimLaserOFF=TotEpoch-StimLaserON;
    hold on, plot(Start(StimLaserON)*1E-4,14,'*b')
    hold on, plot(End(StimLaserON)*1E-4,14,'*r')
    save behavResources StimLaserON StimLaserOFF -Append
    catch
        keyboard
    end
end




if 1
%% recupere les données behavior - CS+ et CS-
try
    load behavResources TTL Pos
    TTL;
    Pos;
catch
% if ~isempty(strfind(Dir.path{man},'DataMobs31')) |~isempty(strfind(Dir.path{man},'DATAMobs55'))
    behav_folder=[res '-wideband'];
    list_behav=dir([res '-wideband']);
    for i=1:length(list_behav)
        if (length(list_behav(i).name)>3 && strcmp(list_behav(i).name(end-3:end),'.mat') && strcmp(list_behav(i).name(1:4),'FEAR'))
            temp=load([behav_folder,'/',list_behav(i).name]);
            TTL=temp.TTL;
            PosMat=temp.PosMat;
        end
    end
    
    save behavResources TTL PosMat -Append
% else
%     load behavResources TTL PosMat
end
CSminus=TTL(:,2)==4;
CSplus=TTL(:,2)==3;
    
%%% recupere les données behavior freezing
load behavResources MovAccSmotsd FreezeAccEpoch
if 0
    th_immob_Acc=3E7;% see EstablishAThresholdForFreezingFromAcceleration.m
    th_2merge_FreezAcc=0.5;
    thtps_immob_Acc=2;
    FreezeAccEpoch=thresholdIntervals(MovAccSmotsd,th_immob_Acc,'Direction','Below');
    FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1E4);
    FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);
end

%% load or compute spectrum
for i=1:length(structlist)
    try

        if findstr(structlist{i},'dHPC')
            try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_deep.mat']); if ~isempty(tempt.channel);temp=tempt;end;end   
            try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_rip.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
        else
            temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
        end

        % load or compute spectrum
        try
            load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
            disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
        catch
            if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
            eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
            disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
            [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
            eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
        end

        % plot spectrum, and CS+/ CS-/laser information
        Stsd=tsd(t*1E4,Sp);
        tps=Range(Stsd); %tps est en 10-4sec
        TotEpoch=intervalSet(tps(1),tps(end));

        % noise removal : 
        try
            temp2=load([Dir.path{man},'/StateEpoch.mat'],'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch'); 
            NoiseEpoch=temp2.NoiseEpoch; GndNoiseEpoch=temp2.GndNoiseEpoch; WeirdNoiseEpoch=temp2.WeirdNoiseEpoch;
            TotEpoch=TotEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
        catch
            disp('NoiseEpoch / GndNoiseEpoch / WeirdNoiseEpoch not removed...')
        end
        % Stsd=Restrict(Stsd,TotEpoch); removed 21.11.2016   

        Sp=Data(Stsd);
        t=Range(Stsd)*1E-4;
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

        if isempty(strfind(Dir.path{man},'lasertest'))
            plot([TTL(CSminus,1) TTL(CSminus,1)+1],19.5*ones(size(CSminus,2),2),'Color','k','LineWidth',3)
            plot([TTL(CSplus,1) TTL(CSplus,1)+1],19.5*ones(size(CSplus,2),2),'Color','r','LineWidth',3)
        end

        % on the last one, plot movement
        if strcmp(structlist(i),'PiCx_right') || strcmp(structlist(i),'Bulb_ventral_left')
             YL=ylim; plot(Range(MovAccSmotsd)*1E-4,rescale(Data(MovAccSmotsd),YL(1),YL(2)),'Color',[0.5 0.5 0.5 ])
        end
        plot([Start(FreezeAccEpoch) End(FreezeAccEpoch)]*1E-4,[12 12],'-k','LineWidth',2)
        if i==1
            title (res(ind_mark(end-1):end))
        end
    catch
        disp([structlist{i}  'spectrum not computed'])
%         keyboard
    end
    clear Sp
end
% set(gcf,'PaperPosition', [0.6345175   6.345175           34 21])
  

cd('/media/DataMOBsRAIDN/ProjetAversion/OptoFear/SpectroLaserAccFz/')

ind_mouse=strfind(Dir.path{man},'Mouse-');
if ~isempty(ind_mouse), m=Dir.path{man}(ind_mouse+6:ind_mouse+8); else, ind_mouse=strfind(Dir.path{man},'Mouse'); m=Dir.path{man}(ind_mouse+5:ind_mouse+7); end
ind_ses=strfind(Dir.path{man},'EXT');     
sesname= Dir.path{man}(ind_ses:ind_ses+5);
if strcmp('Bulb_ecoG_right',structlist{1})
    saveas(gcf,['SpLaserAccFz_bulb_' m '_' sesname '.fig'])
    saveas(gcf,['SpLaserAccFz_bulb_' m '_' sesname '.png'])
elseif strcmp('LaserInput',structlist{1})
    saveas(gcf,['SpLaserAccFz_bulb_Laser_noNoiseEpRemov_' mousename '_' sesname '.fig'])
    saveas(gcf,['SpLaserAccFz_bulb_Laser_noNoiseEpRemov_caxis__' mousename '_' sesname '.png'])
else
    saveas(gcf,['SpLaserAccFz_' m '_' sesname '.fig'])
    saveas(gcf,['SpLaserAccFz_' m '_' sesname '.png'])
end

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
