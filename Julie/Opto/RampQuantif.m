% RampQuantif
% 22.09.2016
% 
% cd /media/DataMobs31/OPTO_CHR2_DATA/Mouse-390/20160919-stim_opto-rampe/FEAR-Mouse-390-19092016
cd /media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-SLEEP-laser/FEAR-Mouse-367-04072016
res=pwd;

%% Get frequencies of stimulation really imposed from LFP32.mat
if 1
    figure,hold on
    load behavResources
    load ('SpectrumDataL/Spectrum32.mat')
    Stsd=tsd(t*1E4,Sp);
    colori=jet(length(Start(StimLaserON)));
    FreqIndices=[];
    FreqRangeTable={};
    MedianFreqT=[];
    for k=1:length(Start(StimLaserON))

        SpLaser=Restrict(Stsd,subset(StimLaserON,k));
        MeanSpLaser{k}=mean(Data(SpLaser));
        plot(f,k*10000+MeanSpLaser{k},'Color',colori(k,:), 'LineWidth',2)

        MeanSpLaser{k}(f<1)=nan;
        ind=(MeanSpLaser{k}>0.5*(nanmax(MeanSpLaser{k})));
        if sum(ind)>0
        hold on, plot(f(ind), k*10000+1,'*k')
        end
        sum(ind>30)
        if sum(ind>30) % le max n'est pas dans la gamme [0:20] par ex pour les freq 30,50,70 Hz...
            freq=nan;
        else
            freq=median(f(ind));
            plot(freq, k*10000+100,'*r')
        end

        MedianFreqT=[MedianFreqT;round(10*freq)/10];
        FreqRangeTable=[FreqRangeTable;f(ind)];
        FreqIndices=[FreqIndices;ind];
    end
    save LaserStimInfo MedianFreqT FreqRangeTable FreqIndices
end

%% Plot Efficiency for each frequency each structure
structlist={'Bulb_right','PFCx_deep_right','Bulb_left','PFCx_deep_left','dHPC_deep','PiCx_right','PiCx_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
%structlist={'Bulb_sup_right','Bulb_right','Bulb_ventral_right','Bulb_sup_left','Bulb_left','Bulb_ventral_left','LaserInput'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
%structlist={'Bulb_sup_right'};%,
figure;

load behavResources StimLaserON
load LaserStimInfo
%colori=jet(length(Start(StimLaserON)));
colorcode.name={'Bulb','PFCx','HPC','PiCx'};
colorcode.color={'b','r','c','g'};
coloriT={};

man=1;
Dir.path{man}='/media/DataMobs31/OPTO_CHR2_DATA/Mouse-390/20160919-stim_opto-rampe/FEAR-Mouse-390-19092016';
try 
    load power_freq_ramp.mat
catch
    PowerInStimFqT=nan(length(structlist),length(Start(StimLaserON)));
    for i=1:length(structlist)

        % color for the structure
        for cc=1:length(colorcode.color)
            if findstr(colorcode.name{cc},structlist{i})
                colori=colorcode.color{cc};
            end
        end

        temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
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
        Stsd=tsd(t*1E4,Sp);



        for k=1:length(Start(StimLaserON))

            SpLaserON=Restrict(Stsd,subset(StimLaserON,k));
            MeanSpLaserON{i,k}=mean(Data(SpLaserON));
            %plot(f,k*10000+MeanSpLaserON{k},'Color',colori(k,:), 'LineWidth',2)
            plot(f,k*10000+MeanSpLaserON{k},'Color',colori, 'LineWidth',2)
            % calcul de la puissance dans la bande de frequence imposée
            PowerInStimFqT(i,k)=mean(MeanSpLaserON{i,k}(find(FreqIndices(k,:))));


    %         ind=(MeanSpLaserON{k}>0.5*(nanmax(MeanSpLaserON{i,k})));
    %         if sum(ind)>0
    %         hold on, plot(f(ind), k*10000+1,'*k')
    %         end
    %         sum(ind>30)
    %         if sum(ind>30) % le max n'est pas dans la gamme [0:20]
    %             freq=nan;
    %         else
    %             freq=median(f(ind))
    %             plot(freq, k*10000+100,'*r')
    %         end
    % 
    %         MedianFreqT=[MedianFreqT;round(10*freq)/10];

        end

        coloriT=[coloriT; colori];
    end
end
save power_freq_ramp PowerInStimFqT structlist MedianFreqT coloriT MeanSpLaserON FreqRangeTable FreqIndices 


% Figure
% h_power_freq=figure('Position', [1954   89   1314   844]); hold on
% 
% 
% for i=1:length(structlist)
%     plot(MedianFreqT(1:20),PowerInStimFqT(i,[1:20]),'LineWidth',2,'Color', coloriT{i})
%     plot(MedianFreqT(21:40),PowerInStimFqT(i,[21:40]),'LineWidth',2,'Color', coloriT{i})
%     plot(MedianFreqT,PowerInStimFqT(i,:),'*','LineWidth',2,'Color', coloriT{i})
%     
% end


h_power_freq=figure('Position', [1954   89   1314   844]); hold on
[MedianFreqTSorted,IX]=sort(MedianFreqT);

for i=1:length(structlist)
    plot(MedianFreqTSorted,PowerInStimFqT(i,IX),'LineWidth',1,'Color', coloriT{i})

    
end
legend(structlist);
for i=1:length(structlist)

    plot(MedianFreqTSorted,PowerInStimFqT(i,IX),'*','LineWidth',2,'Color', coloriT{i})
    
end
xlabel('stimulation frequencies'), ylabel('power')
title(res)
saveas(h_power_freq,'Power_frequency_ramp.fig')
saveas(h_power_freq,'Power_frequency_ramp.png')

%% To check that I correctly get laser stim 
if 0
    load behavResources StimLaserON
    figure, hold on
    plot([Start(StimLaserON) End(StimLaserON)],500*ones(length(Start(StimLaserON)),2),'Color','r','LineWidth',3)
    hold on, plot(Data(LFP))
    for k=1:length(Start(StimLaserON))
        plot([s(k)*1E-4 e(k)*1E-4],[50 50],'Color','b','LineWidth',3)
    end
    % these lines do not seem to work...
    % line([s*1E-4 e*1E-4],[500*ones(length(Start(StimLaserON)),1) 600*ones(length(Start(StimLaserON)),1)])
    % plot([s*1E-4 ],[500*ones(length(Start(StimLaserON)),1)],'*r','LineWidth',3)
    % hold on, plot([e*1E-4 ],[500*ones(length(Start(StimLaserON)),1)],'*g','LineWidth',3)
end

if 0
        StimLaserON=subset(StimLaserON,[2:length(Start(StimLaserON))]); % first interval is 
end
