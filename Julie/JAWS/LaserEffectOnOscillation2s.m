% LaserEffectOnOscillations

%04.09.2015
%definition des periodes diode ON, avec LFP analog input
man=1;
%Dir.path{man}='/media/DataMOBs29/M255/20150826-SLEEP-JAWS/20150826-SLEEP-jaws/FEAR-Mouse-255-26082015';
%Dir.path{man}='/media/DataMOBs29/M255-256/20150825-SLEEP-JAWS/FEAR-Mouse-256-25082015/FEAR-Mouse-255-256-25082015';
mousename='M256';
if strcmp(mousename,'M255')
    %Dir.path{man}='/media/DataMOBs29/M255-256/20150901-SLEEP-jaws/FEAR-Mouse-255-256-01092015/M255';
    Dir.path{man}='/media/DataMOBs29/M255-256/20150901-SLEEP-jaws/FEAR-Mouse-255-256-01092015/255';
elseif strcmp(mousename,'M256')
    %Dir.path{man}='/media/DataMOBs29/M255-256/20150901-SLEEP-jaws/FEAR-Mouse-255-256-01092015/M256';
    Dir.path{man}='/media/DataMOBs29/M255-256/20150901-SLEEP-jaws/FEAR-Mouse-255-256-01092015/256';
end

 freqband='high';
[params,movingwin,suffix]=SpectrumParametersML(freqband); % low or high
%params.fpass=[0 200];
load Diode
load DiodeOnMouse
load StateEpoch

structlist={'Bulb_sup','Bulb_sup','Bulb_ecoG'};%'PFCx_deep',,'dHPC_rip','PiCx','Amyg'
%structlist={'PiCx','Amyg','PFCx_deep'};%'PFCx_deep',,'dHPC_rip','PiCx','Amyg'
sidelist={'Right'; 'Left'};
figure('Position', [ 200 100  2200  1000])
for s=1:length(sidelist)
    side=sidelist{s};
    
    for i=1:length(structlist)
        
        
        clear d_ON_segt
        load Diode
%         listvar=who;
%         for v=1:length(listvar)
%             
%             if strfind(listvar{v}, 'diode')
%                 ['listvar{' num2str(v) '}=And(listvar{' num2str(v) '},DiodeOnMouse);']
%             end
%         end

%         d_ON_per1=And(d_ON_per1,DiodeOnMouse);
%         d_ON_per2=And(d_ON_per2,DiodeOnMouse);
%         d_ON_per3=And(d_ON_per3,DiodeOnMouse);
%         d_ON_per4=And(d_ON_per4,DiodeOnMouse);
        d_ON_per5=And(d_ON_per5,DiodeOnMouse);
        d_ON_per6=And(d_ON_per6,DiodeOnMouse);
        d_ON_per7=And(d_ON_per7,DiodeOnMouse);
        d_ON_segt=And(d_ON_segt,DiodeOnMouse);
        try
            if strcmp (side, 'Right')
                temp=load(['ChannelsToAnalyse/',structlist{i},'.mat']);
            elseif strcmp (side, 'Left')
                temp=load(['ChannelsToAnalyseLeft/',structlist{i},'.mat']);
            end
            temp2=load(['LFPData/LFP',num2str(temp.channel),'.mat']);
            t=Range(temp2.LFP);
            TotEpoch=intervalSet(t(1),t(end));
            temp2.LFP=Restrict(temp2.LFP,TotEpoch-TotalNoiseEpoch);
           

            try
                load([Dir.path{man},'/SpectrumData' suffix '/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                disp([Dir.path{man},'/SpectrumData' suffix '/Spectrum' num2str(temp.channel),'... loaded'])
            catch
                if ~exist([Dir.path{man},'/SpectrumData' suffix],'dir'), mkdir([Dir.path{man},'/SpectrumData' suffix ]);end
                disp(['Computing SpectrumData' suffix '/Spectrum' num2str(temp.channel),'... '])
                [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);

                eval(['save(''',Dir.path{man},'/SpectrumData' suffix '/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'');'])
            end
                Stsd=tsd(t*1E4,Sp);

            

             d_ON_segt=dropShortIntervals(d_ON_segt,30000);
             d_ON_segt=intervalSet(Start(d_ON_segt)+2*1E4,End(d_ON_segt)-1*1E4);
             d_OFF_segt=dropShortIntervals(d_OFF_segt,30000);
             d_OFF_segt=intervalSet(Start(d_OFF_segt)+2*1E4,End(d_OFF_segt)-1*1E4);
            %%%%%%%%%% SPECTROGRAM
            ncol=8;
            
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+[1:3]); 
            imagesc(t,f, 10*log10(Sp')),axis xy
            line([Start(REMEpoch,'s') End(REMEpoch,'s')],[0.75*params.fpass(2) 0.75*params.fpass(2)],'color','g','linewidth',4)
            line([Start(SWSEpoch,'s') End(SWSEpoch,'s')],[0.75*params.fpass(2) 0.75*params.fpass(2)],'color','k','linewidth',4)
            if strcmp(mousename,'M255')
                line([Start(d_ON_per7,'s') End(d_ON_per7,'s')],[0.6*params.fpass(2) 0.6*params.fpass(2)],'LineStyle',':','color','r','linewidth',4)
            elseif strcmp(mousename,'M256')
                line([Start(d_ON_per6,'s') End(d_ON_per6,'s')],[0.6*params.fpass(2) 0.6*params.fpass(2)],'LineStyle',':','color','r','linewidth',4)
            end
            line([Start(subset(d_OFF_per,1),'s') End(subset(d_OFF_per,1),'s')],[12 12],'color','k')
            line([Start(subset(d_OFF_per,2),'s') End(subset(d_OFF_per,2),'s')],[12 12],'color',[0.5 0.5 0.5]);
            line([Start(subset(d_OFF_per,3),'s') End(subset(d_OFF_per,3),'s')],[12 12],'color',[0.5 0.5 0.8]);
            
            title([structlist{i} ' ' side]);
            xlim([738 9165]);
            
            %%%%%%%%%% SPECTRUM during stim (toutes state epoch confondues)
            
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+4); hold on
            
            xlabel('frequencies(Hz)')
            ylabel('power')

            legplot={};
            colorplot=jet(7);
            for k=6:7
                if eval(['~isempty(Start(d_ON_per' num2str(k) '))'])
                if strcmp(freqband,'high')
                    eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(d_ON_per' num2str(k) ',d_ON_segt))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                    eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(d_ON_per' num2str(k) ',d_OFF_segt))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                elseif strcmp(freqband,'low')
                    eval(['plot(f,mean(Data(Restrict(Stsd,And(d_ON_per' num2str(k) ',d_ON_segt)))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                    eval(['plot(f,mean(Data(Restrict(Stsd,And(d_ON_per' num2str(k) ',d_OFF_segt)))),''--'', ''Color'',''k'',''linewidth'',2)'])
                end
%                 eval(['legON=sum(End(And(d_ON_per',num2str(k),',d_ON_segt),''s'')-Start(And(d_ON_per',num2str(k),',d_ON_segt),''s''));'])
%                 eval(['legOFF=sum(End(And(d_ON_per',num2str(k),',d_OFF_segt),''s'')-Start(And(d_ON_per',num2str(k),',d_OFF_segt),''s''));'])
                eval(['legON=tot_length(And(d_ON_per',num2str(k),',d_ON_segt))*1E-4;'])
                eval(['legOFF=tot_length(And(d_ON_per',num2str(k),',d_OFF_segt))*1E-4;'])
                eval(['legplot=[legplot; [''ON segt' num2str(k) ' (' sprintf('%0.0f',legON)  's)'']; [''OFF segt' num2str(k) ' (' sprintf('%0.0f',legOFF)  's)'']];']);

                end
            end
            
            if  ~isempty(Start(subset(d_OFF_per,1)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,subset(d_OFF_per,1))))),'k')
                elseif strcmp(freqband,'low')plot(f,mean(Data(Restrict(Stsd,subset(d_OFF_per,1)))),'k')
                end
                legplot=[legplot;['OFF per1 (' sprintf('%0.0f',tot_length(subset(d_OFF_per,1))*1E-4) 's)']];
            end
            if  ~isempty(Start(subset(d_OFF_per,2)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,subset(d_OFF_per,2))))),'Color', [0.5 0.5 0.5])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,subset(d_OFF_per,2)))),'Color', [0.5 0.5 0.5])
                end
                legplot=[legplot;['OFF per2 (' sprintf('%0.0f',tot_length(subset(d_OFF_per,2))*1E-4) 's)']];
            end

            if  ~isempty(Start(subset(d_OFF_per,3)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,subset(d_OFF_per,3))))),'Color', [0.5 0.5 0.8])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,subset(d_OFF_per,3)))),'Color', [0.5 0.5 0.8])
                end
                legplot=[legplot;['OFF per3 (' sprintf('%0.0f',tot_length(subset(d_OFF_per,3))*1E-4) 's)']];
            end

            if i==1 && s==1
                legend(legplot); 
            end
            
            %%%%%%%%%% SPECTRUM on diff State Epoch
            
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+5); hold on
            
            WakeEpoch=TotEpoch-SWSEpoch-REMEpoch;
            if strcmp(freqband,'high')
            plot(f,10*log10(mean(Data(Restrict(Stsd,REMEpoch)))),'g','linewidth',2)
            plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'r','linewidth',2)
            plot(f,10*log10(mean(Data(Restrict(Stsd,WakeEpoch)))),'k','linewidth',2)
            elseif strcmp(freqband,'low')
            plot(f,mean(Data(Restrict(Stsd,REMEpoch))),'g','linewidth',2)
            plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'r','linewidth',2)
            plot(f,mean(Data(Restrict(Stsd,WakeEpoch))),'k','linewidth',2)
            end
            if i==1 && s==1
                legend({['REM (' sprintf('%0.0f',tot_length(REMEpoch)*1E-4) 's)'] ;['SWS (' sprintf('%0.0f',tot_length(SWSEpoch)*1E-4) 's)'];['Wake (' sprintf('%0.0f',tot_length(WakeEpoch)*1E-4) 's)']}); 
            end
            %%%%%%%%%% SPECTRUM during  SWS +stim
            legplot2={};
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+6); hold on
            for k=6:7
                if eval(['~isempty(Start(d_ON_per' num2str(k) '))'])
                    %d_ON_segt_SWS=And(d_ON_segt,SWSEpoch);
                    if strcmp(freqband,'high')
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(SWSEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(SWSEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    elseif strcmp(freqband,'low')
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(SWSEpoch,And(d_ON_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(SWSEpoch,And(d_OFF_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    end
                    eval(['legON=tot_length(And(SWSEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legOFF=tot_length(And(SWSEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legplot2=[legplot2; [''ON segt' num2str(k) ' (' sprintf('%0.0f',legON)  's)'']; [''OFF segt' num2str(k) ' (' sprintf('%0.0f',legOFF)  's)'']];']);
                end
            end
            if  ~isempty(Start(And(subset(d_OFF_per,1),SWSEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),SWSEpoch))))),'k')
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),SWSEpoch)))),'k')
                end
                legplot2=[legplot2;['OFF per1 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,1),SWSEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,2),SWSEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),SWSEpoch))))),'Color', [0.5 0.5 0.5])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),SWSEpoch)))),'Color', [0.5 0.5 0.5])
                end
                legplot2=[legplot2;['OFF per2 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,2),SWSEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,3),SWSEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),SWSEpoch))))),'Color', [0.5 0.5 0.8])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),SWSEpoch)))),'Color', [0.5 0.5 0.8])
                end
                legplot2=[legplot2;['OFF per3 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,3),SWSEpoch))*1E-4) 's)']];
            end
            
            if i==1 && s==1
                legend(legplot2); 
                title('SWS')
            end
            
             %%%%%%%%%% SPECTRUM during  REM +stim
            legplot_REM={};
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+7); hold on
            for k=6:7
                if eval(['~isempty(Start(d_ON_per' num2str(k) '))'])
                    %d_ON_segt_REM=And(d_ON_segt,REMEpoch);
                    if strcmp(freqband,'high')
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(REMEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(REMEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    elseif strcmp(freqband,'low')
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(REMEpoch,And(d_ON_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(REMEpoch,And(d_OFF_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    end
                    eval(['legON=tot_length(And(REMEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legOFF=tot_length(And(REMEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legplot_REM=[legplot_REM; [''ON segt' num2str(k) ' (' sprintf('%0.0f',legON)  's)'']; [''OFF segt' num2str(k) ' (' sprintf('%0.0f',legOFF)  's)'']];']);
                end
            end
            if  ~isempty(Start(And(subset(d_OFF_per,1),REMEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),REMEpoch))))),'k')
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),REMEpoch)))),'k')
                end
                legplot_REM=[legplot_REM;['OFF per1 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,1),REMEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,2),REMEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),REMEpoch))))),'Color', [0.5 0.5 0.5])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),REMEpoch)))),'Color', [0.5 0.5 0.5])
                end
                legplot_REM=[legplot_REM;['OFF per2 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,2),REMEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,3),REMEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),REMEpoch))))),'Color', [0.5 0.5 0.8])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),REMEpoch)))),'Color', [0.5 0.5 0.8])
                end
                legplot_REM=[legplot_REM;['OFF per3 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,3),REMEpoch))*1E-4) 's)']];
            end
            
            if i==1 && s==1
                legend(legplot_REM); 
                title('REM')
            end
           
                         %%%%%%%%%% SPECTRUM during  Wake +stim
            legplot_Wake={};
            subplot(5,ncol,(3*(s-1)+i-1)*ncol+8); hold on
            for k=6:7
                if eval(['~isempty(Start(d_ON_per' num2str(k) '))'])
                    %d_ON_segt_Wake=And(d_ON_segt,WakeEpoch);
                    if strcmp(freqband,'high')
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(WakeEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,10*log10(mean(Data(Restrict(Stsd,And(WakeEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    elseif strcmp(freqband,'low')
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(WakeEpoch,And(d_ON_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',colorplot(k,:),''linewidth'',2)'])
                        eval(['plot(f,mean(Data(Restrict(Stsd,And(WakeEpoch,And(d_OFF_segt,d_ON_per' num2str(k) '))))),''--'', ''Color'',''k'',''linewidth'',2)'])
                    end
                    eval(['legON=tot_length(And(WakeEpoch,And(d_ON_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legOFF=tot_length(And(WakeEpoch,And(d_OFF_segt,d_ON_per' num2str(k) ')))*1E-4;'])
                    eval(['legplot_Wake=[legplot_Wake; [''ON segt' num2str(k) ' (' sprintf('%0.0f',legON)  's)'']; [''OFF segt' num2str(k) ' (' sprintf('%0.0f',legOFF)  's)'']];']);
                end
            end
            if  ~isempty(Start(And(subset(d_OFF_per,1),WakeEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),WakeEpoch))))),'k')
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,1),WakeEpoch)))),'k')
                end
                legplot_Wake=[legplot_Wake;['OFF per1 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,1),WakeEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,2),WakeEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),WakeEpoch))))),'Color', [0.5 0.5 0.5])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,2),WakeEpoch)))),'Color', [0.5 0.5 0.5])
                end
                legplot_Wake=[legplot_Wake;['OFF per2 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,2),WakeEpoch))*1E-4) 's)']];
            end
            if  ~isempty(Start(And(subset(d_OFF_per,3),WakeEpoch)))
                if strcmp(freqband,'high')
                    plot(f,10*log10(mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),WakeEpoch))))),'Color', [0.5 0.5 0.8])
                elseif strcmp(freqband,'low')
                    plot(f,mean(Data(Restrict(Stsd,And(subset(d_OFF_per,3),WakeEpoch)))),'Color', [0.5 0.5 0.8])
                end
                legplot_Wake=[legplot_Wake;['OFF per3 (' sprintf('%0.0f',tot_length(And(subset(d_OFF_per,3),WakeEpoch))*1E-4) 's)']];
            end
            
            if i==1 && s==1
                legend(legplot_Wake); 
                title('Wake')
            end
           
            
        end
    end
            
end
subplot(5,ncol,[1:3]); hold on
text(-500,20,mousename, 'FontSize',50)
if ~exist([Dir.path{man},'/LaserEffectFig'],'dir'), mkdir([Dir.path{man},'/LaserEffectFig']);end
    %title([structlist{i} ' ' side]);
    set(gcf,'PaperPosition', [0.6345    6.3452   35  15])
    saveas(gcf, ['LaserEffectFig/' mousename '_' structlist{i}  '_' suffix '.fig']);
    saveas(gcf, ['LaserEffectFig/' mousename '_' structlist{i}  '_' suffix '.png']);
