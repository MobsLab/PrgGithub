% LaserControlOfLFP
% 11.01.2017
% aims at evaluating how the 10Hz stimulation impacts 4Hz power
% this codes plots 4Hz powers =f(10Hz power) for intervals of 45sec when
% the laser is off( blue) or on (red)
% OUTPUTS
% - graphe MouseMean : 1 pair of points per mouse
% - graphe allS : all pairs of CS of a mouse are represented, identified by their common symbol

% AFAIRE : faire les mêmes graphes en séparant FreezeEpoCh et NoFreezeEpoch

%% DEFINE DATA SET

Dir=PathForExperimentFEAR('Fear-electrophy-opto');
manipname='jul_oct16';
Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459]); %   juil_oct
% manipname='dec16';
% Dir = RestrictPathForExperiment(Dir,'nMice',[465 466 467 468]); %dec_16

% manipname='jul-oct-dec16';
% Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459 465 466 467 468]); %dec_16

Dir = RestrictPathForExperiment(Dir,'Session','EXT-24');
StepName={'EXT-24'};%'EXT-48'

CSplu_bip_Gp={'253','403','450','451''467','468'};
CSplu_WN_Gp={'254','363','367','458','459','402','465','466'};

structlist={'Bulb_deep_right','PFCx_deep_right','Bulb_deep_left','PFCx_deep_left','dHPC_deep','PiCx_right','PiCx_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
structlistname=structlist;
for i=1:length(structlistname)
    ind_und=strfind(structlistname{i},'_');
    structlistname{i}(ind_und)=' ';
end

%% define Ylim to compare graphes between each other
ylimlist_allCS=[0 8E5; 0 5E4;0 8E5; 0 5E4;nan nan; nan nan; nan nan];
ylimlist_mean=[0 5E5; 0 2.6E4;0 5E5; 0 2.6E4;nan nan; nan nan; nan nan];

xlimlist_mean=[0 5E5; 0 6E4;0 5E5; 0 6E4;nan nan; nan nan; nan nan];
xlimlist_allCS=xlimlist_mean;

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
if  ~exist('man', 'var')
    man=1;
end

%% COMPUTE OR LOAD DATA
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/']);
res=pwd;
ind_mark=strfind(res,'/');

LFPpower=nan(length(StepName),length(structlist), length(Dir.path),16,67); % avant 164
try

    load(['LaserControlOnLFP/LaserControlData_' manipname])
catch

    for man=1:length(Dir.path) 

        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];
        disp(Mousename)

        Dir.path{man}
        cd ([Dir.path{man}])

        %load behavResources MovAccSmotsd FreezeAccEpoch
        
        manfig=figure('Position', [1360          48         560         926]);
        try
            temp=load ('behavResources.mat', 'csm','csp');
            csp=temp.csp;
            csm=temp.csm;
        catch
            temp=load ('behavResources.mat', 'TTL');
            TTL=temp.TTL;
            DiffTimes=diff(TTL(:,1));
            ind=DiffTimes>2;
            times=TTL(:,1);
            event=TTL(:,2);
            CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
            CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)

            %d�finir CS+ et CS- selon les groupes
            m=Mousename(2:4);
           if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
                CSpluCode=4; %bip
                CSminCode=3; %White Noise
           elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
                CSpluCode=3;
                CSminCode=4;
           end
            csp=CStimes(CSevent==CSpluCode);
            csm=CStimes(CSevent==CSminCode);
            save behavResources csp csm CStimes CSevent CSminCode CSpluCode -Append
        end




        if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10')
            LaserInt=intervalSet([csm(1:4);csp(1:2)]*1E4, ([csm(1:4);csp(1:2)]+45)*1E4);
        else
            %LaserInt=intervalSet([csm;csp]*1E4, ([csm;csp]+45)*1E4);
            LaserInt=intervalSet([csm;csp(1:4)]*1E4, ([csm;csp(1:4)]+45)*1E4);
        end

        for i=1:length(structlist)

            if exist([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat'])

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

            else
                disp(['no channel for ' structlist{i} ' in this mouse '])
            end 


            subplot(length(structlist),length(StepName),length(StepName)*(i-1)+1), hold on
            for evnt=1:length(Start(LaserInt))
                if length(f)>67%164
                    load /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/f_0-20;
                    LFPpower(1,i,man,evnt,1:length(f1))= interp1(f,mean(Data(Restrict(Stsd,subset(LaserInt,evnt)))),f1);
                    %f=f1;
                else
                    LFPpower(1,i,man,evnt,1:length(f1))= mean(Data(Restrict(Stsd,subset(LaserInt,evnt))));

                end
                if mod(evnt,2)==1 % impaire, laser off
                    plot(f1,squeeze(LFPpower(1,i,man,evnt,:)),'b')
                elseif mod(evnt,2)==0 % laser on
                    plot(f1,squeeze(LFPpower(1,i,man,evnt,:)),'r')
                end

            end
            xlim([0 f1(end)]);ylabel(structlistname{i});
            if i==1, title([StepName{1} ' - ' Mousename]);end

        end
        cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/
        saveas(manfig,'LaserControlOnLFP/LaserControlDiffStt.fig');
        saveas(manfig,'LaserControlOnLFP/LaserControlDiffStt.png');
        %close;
    end
    

    save(['LaserControlOnLFP/LaserControlData_' manipname], 'LFPpower','f1', 'evnt', 'Dir','StepName','structlist')
end

%% PLOT DATA
MouseMeanfig=figure('Position', [2         589        1918         380]);
AllCSfig=figure('Position', [2         100        1918         387]);

evnt_off=1:2:11;
evnt_on=2:2:12;
% fig
MouseColor={'r','b','g','k'};
MouseMarker={'+','o','*','v','x','s','d','p','h','^','.'};
for i=1:length(structlist)
    
    ind_10=(f1>8.5)&(f1<10.5);
    LFPpower10_off=nanmean(nanmean(squeeze(LFPpower(1,i,:,evnt_off,ind_10)),3),2);%3 : average on frequencies between 8.5 and 10.5; 2 : average on all 8 CS (evnt_off)
    LFPpower10_on=nanmean(nanmean(squeeze(LFPpower(1,i,:,evnt_on,ind_10)),3),2);
    
    LFPpower10_off_allCS=nanmean(squeeze(LFPpower(1,i,:,evnt_off,ind_10)),3);%3 : average on frequencies between 8.5 and 10.5; 2 : average on all 8 CS (evnt_off)
    LFPpower10_on_allCS=nanmean(squeeze(LFPpower(1,i,:,evnt_on,ind_10)),3);
    
    ind_4=(f1>3)&(f1<5);
    LFPpower4_off=nanmean(nanmean(squeeze(LFPpower(1,i,:,evnt_off,ind_4)),3),2);
    LFPpower4_on=nanmean(nanmean(squeeze(LFPpower(1,i,:,evnt_on,ind_4)),3),2);
    
    LFPpower4_off_allCS=nanmean(squeeze(LFPpower(1,i,:,evnt_off,ind_4)),3);
    LFPpower4_on_allCS=nanmean(squeeze(LFPpower(1,i,:,evnt_on,ind_4)),3);
    
    figure(AllCSfig)
    SP_all{i}=subplot(1,length(structlist),i); hold on
    for k=1:length(LFPpower10_off)
        plot(LFPpower10_off_allCS(k,:),LFPpower4_off_allCS(k,:),MouseMarker{k},'Color','b');
        plot(LFPpower10_on_allCS(k,:),LFPpower4_on_allCS(k,:),MouseMarker{k},'Color','r');
    end
    title(structlistname{i})
    xlabel('10 Hz'); ylabel('4 Hz')
    if ~isnan(ylimlist_allCS(i,1))
        ylim(ylimlist_allCS(i,:))
    end
    
%     for k=1:length(LFPpower10_off)
%         plot(LFPpower10_off_allCS(k,:),LFPpower4_off_allCS(k,:),'*','Color',MouseColor{k});
%         plot(LFPpower10_on_allCS(k,:),LFPpower4_on_allCS(k,:),'o','Color',MouseColor{k});
%     end
%     plot(LFPpower10_off_allCS,LFPpower4_off_allCS,'*b');
%     plot(LFPpower10_on_allCS,LFPpower4_on_allCS,'*r');
    
    figure(MouseMeanfig)
    SP_mean{i}=subplot(1,length(structlist),i); hold on
    plot(LFPpower10_off,LFPpower4_off,'*b');
    plot(LFPpower10_on,LFPpower4_on,'*r');
    for k=1:length(LFPpower10_off)
        plot([LFPpower10_off(k) LFPpower10_on(k) ],[LFPpower4_off(k)  LFPpower4_on(k) ],'-','Color',[0.7 0.7 0.7])   
    end
    title(structlistname{i})
    xlabel('10 Hz'); ylabel('4 Hz')
    if ~isnan(ylimlist_mean(i,1))
        ylim(ylimlist_mean(i,:))
    end
end
figure(MouseMeanfig), subplot(SP_mean{1}), text(-0.5,1.05,manipname,'units','normalized')
figure(AllCSfig), subplot(SP_all{1}), text(-0.5,1.05,manipname,'units','normalized')


for i=1:length(structlist)
    subplot(1,length(structlist),i); hold on
    if ~isnan(xlimlist_mean(i,1))
        xlim(xlimlist_mean(i,:))
    end
end

saveas(MouseMeanfig,['LaserControlOnLFP/LaserControl_MouseMean_' manipname '.fig'])
saveFigure(MouseMeanfig,['LaserControlOnLFP/LaserControl_MouseMean_' manipname ],res)
%saveas(MouseMeanfig,['LaserControlOnLFP/LaserControl_MouseMean_' manipname '.png'])
saveas(AllCSfig,['LaserControlOnLFP/LaserControl_AllCS_' manipname '.fig'])
%saveas(AllCSfig,['LaserControlOnLFP/LaserControl_AllCS_' manipname '.png'])
saveFigure(AllCSfig,['LaserControlOnLFP/LaserControl_AllCS_' manipname ],res)
% subplot(length(structlist),length(structlist)-1,(length(structlist)-1)*(i-1)+1), hold on

