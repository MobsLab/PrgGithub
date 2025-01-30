%AnalyseNREMsubstages_SD24h.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% CaracteristicsSubstagesML.m


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
%t_step=30*60; % in second
t_step=60*60; % in second (default 1h)
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5];

saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation24h';
savFigure=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nameSessions{1}='DayBSL';
nameSessions{2}='nightBSL';
nameSessions{3}='DayPostSD';
nameSessions{4}='nightPostSD';
nameSessions{5}='DaySD+24h';
nameSessions{6}='nightSD+24h';

% ------------ 294 ------------
Dir{1,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906';
Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906-night';% very short, rest is noise
Dir{1,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908';
Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908-night';
Dir{1,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909';
Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909-night';

% ------------ 330 ------------
Dir{2,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906-night';
Dir{2,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908';
Dir{2,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908-night';
Dir{2,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909';
Dir{2,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909-night';

% ------------ 394 ------------
Dir{3,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night';
Dir{3,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908';
Dir{3,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908-night';
Dir{3,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909';
Dir{3,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909-night';

% ------------ 395 ------------
Dir{4,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906-night';
Dir{4,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908';
Dir{4,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908-night';
Dir{4,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909';
Dir{4,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909-night';

% ------------ 400 ------------
Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night';
Dir{5,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915';
Dir{5,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915-night';
Dir{5,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916';
Dir{5,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916-night';

% ------------ 403 ------------
Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night';
Dir{6,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915';
Dir{6,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915-night';
Dir{6,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916';
Dir{6,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916-night';

% ------------ 450 ------------
Dir{7,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';
Dir{7,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
Dir{7,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915-night';
Dir{7,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916-night';

% ------------ 451 ------------
Dir{8,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';
Dir{8,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
Dir{8,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915-night';
Dir{8,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916-night';


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear durEp;
    load([analyFolder,'/AnalyNREMsubstagesSD24h.mat']);
    durEp;
    disp('AnalyNREMsubstagesSD24h.mat already exists... loaded.')
catch
    DoAnalysis=1;
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< COMPUTE SD EFFECT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if DoAnalysis
    
    % <<<<<<<<<<<<<<<<<<<<< Get Behavioral experiments <<<<<<<<<<<<<<<<<<<<
    Epochs={}; nameMouse={};
    h_deb=nan(size(Dir,1),length(nameSessions)/2);
    
    for a=1:size(Dir,1)
        for i=1:length(nameSessions)
            disp(' '); disp('------------------------------------------')
            disp(Dir{a,i}); cd(Dir{a,i});
            nameMouse{a}=Dir{a,i}(max(strfind(Dir{a,i},'Mouse'))+[0:7]);
            
            % -------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(Dir{a,i});close
            %WAKE=or(WAKE,noise); % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
            Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
            
            Stages={'WAKE','REM','N1','N2','N3','NREM','Total'};
            
            % get time of the day
            NewtsdZT=GetZT_ML(Dir{a,i});
            rgZT=Range(NewtsdZT);
            
            % concatenate day and night epochs
            if floor(i/2)==i/2
                i_start=mod(min(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                delay=i_start-i_stop+i_L;
                Ep={};
                for n=1:length(Stages)
                    eval(['epoch=',Stages{n},'; temp=temp',Stages{n},';'])
                    newEpoch=intervalSet(Start(epoch)+delay,Stop(epoch)+delay);
                    Ep{n}=or(temp,newEpoch);
                end
                Epochs{a,i/2}=Ep;
            else
                i_stop=mod(max(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                i_L=max(Range(NewtsdZT));
                for n=1:length(Stages)
                    eval(['temp',Stages{n},'=',Stages{n},';'])
                end
                h_deb(a,(i+1)/2)=mod(min(Data(NewtsdZT)/1E4)/3600,24);
            end
        end
    end
    % saving
    save([analyFolder,'/AnalyNREMsubstagesSD.mat'],'Dir','t_step','Stages','Epochs','h_deb','nameMouse')
    
    
    
    % <<<<<<<<<<<<<<<<<<<<< Get stages on ZT timesteps <<<<<<<<<<<<<<<<<<<<
    durEp=[];
    for a=1:size(Dir,1)
        for i=1:length(nameSessions)/2
            delay_rec=(h_deb(a,i)-9)*3600; % starts at 9am
            Ep=Epochs{a,i};
            PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1});
            title([nameMouse{a},' ',nameSessions{2*i-1},' and ',nameSessions{2*i}])
            
            n_nan=floor(delay_rec/t_step);
            sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
            sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            
            num_step=ceil((max(Stop(Ep{7},'s'))-sto(end))/ t_step);
            sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
            sto=[sto,sto(end)+[1:num_step]*t_step];
            
            tempDur=nan(length(Stages),3+24/(t_step/3600));
            tempDur(:,1:2)=ones(length(Stages),1)*[a,i];
            tempDur(:,3)=1:length(Stages);
            
            L=min(length(sta),24/(t_step/3600));
            for e=1:L % 24h max
                I=intervalSet(sta(e)*1E4,sto(e)*1E4);
                for n=1:length(Stages)
                    s_Ep=and(Ep{n},I);
                    tempDur(n,3+e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
                    if n==7 && tempDur(n,3+e)==0 % total rec (without noise)
                        tempDur(:,3+e)=nan(length(Stages),1);
                    end % noise ! include only recording epochs larger than 20min
                end
            end
            durEp=[durEp;tempDur];%keyboard
        end
    end
    % saving
    save([analyFolder,'/AnalyNREMsubstagesSD.mat'],'-append','durEp')
    
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< DISPLAY RESULTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

L=2; % 3 to include expe at +24h

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.8 0.7]),
for n=1:6
    subplot(2,3,n), hold on,
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==7);%total time
        M=100*durEp(ind1,4:end)./durEp(ind2,4:end);
        if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:); else, colo=[0.5 0.5 0.5]; end
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(M,1),stdError(M),'Linewidth',2,'Color',colo);
    end
    xlim([0 25])
    xlabel('ZT Time (h)'); ylabel('%total rec'); title(Stages{n},'Color',colori(n,:))
end
legend({'BSL','postSD','+24h'})

% save Figure
if savFigure, saveFigure(gcf,sprintf('BilanEvolSD24h-%d',1),saveFolder);end


% --------------
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.8 0.7]),
subplot(2,3,1),hold on,
for i=1:L
    ind1=find(durEp(:,2)==i & durEp(:,3)==7);%total time
    ind2=find(durEp(:,2)==i & durEp(:,3)==6);%NREM
    ind3=find(durEp(:,2)==i & durEp(:,3)==2);%REM
    M=100*(durEp(ind2,4:end)+durEp(ind3,4:end))./durEp(ind1,4:end);
    if i==1, colo=[0 0 0]; elseif i==2, colo=[0 0 1]; else, colo=[0.5 0.5 0.5]; end
    errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(M,1),stdError(M),'Linewidth',2,'Color',colo);
end
xlim([0 25])
xlabel('ZT Time (h)'); ylabel('%total rec'); title('SLEEP','Color',[0 0 1])
legend({'BSL','postSD','+24h'})

for n=2:6
    subplot(2,3,n), hold on,
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==6);%NREM
        ind3=find(durEp(:,2)==i & durEp(:,3)==2);%REM
        M=100*durEp(ind1,4:end)./(durEp(ind2,4:end)+durEp(ind3,4:end));
        if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:); else, colo=[0.5 0.5 0.5]; end
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(M,1),stdError(M),'Linewidth',2,'Color',colo);
    end
    xlim([0 25])
    xlabel('ZT Time (h)'); ylabel('% sleep'); title(Stages{n},'Color',colori(n,:))
end

% save Figure
if savFigure, saveFigure(gcf,sprintf('BilanEvolSD24h-%d',2),saveFolder);end


