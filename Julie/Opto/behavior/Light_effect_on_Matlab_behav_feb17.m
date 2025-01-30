% Light_effect_on_Matlab_behav_feb17.m
% from PSTH_behav_FreezAcctsd_XXX.m
% 07.03.2017

% aims at showing the behavioral effect of light
% uses Matlab tracking data (but tracking artefacts due to cables on HAB
% envC (step=1)

% OUTPUTS

rawPlo=1;
sav=0;
step=3;
% 
if step==1; % HAB env C laser 13
Dir.path={'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-465-28022017-01-HAB-envC-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-466-28022017-01-HAB-envC-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-467-28022017-01-HAB-envC-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-468-28022017-01-HAB-envC-laser13';
};

elseif step==2;% HAB env B laser 7
    Dir.path={'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-465-01032017-01-HAB-envB-laser7';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-466-01032017-01-HAB-envB-laser7';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-467-01032017-01-HAB-envB-laser7';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-468-01032017-01-HAB-envB-laser7';
};

elseif step==3;% EXT-24 env B laser 13
Dir.path={'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-465-02032017-01-EXT-24-envB-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-466-02032017-01-EXT-24-envB-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-467-02032017-01-EXT-24-envB-laser13';
'/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-468-02032017-01-EXT-24-envB-laser13'};

elseif step==4; % EXT-48 env C laser 7
Dir.path={
    '/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-465-03032017-01-EXT-48-envC-laser7';
    '/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-466-03032017-01-EXT-48-envC-laser7';
    '/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-467-03032017-01-EXT-48-envC-laser7';
    '/media/DataMOBs57/Fear-Feb2017/behavior/FEAR-Mouse-468-03032017-01-EXT-48-envC-laser7';};
elseif step==5;
Dir.path={
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-07032017-01-HABlaser';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-07032017-01-HABlaser';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-498-07032017-01-HABlaser';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-499-07032017-01-HABlaser';};
elseif step==6;
Dir.path={
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-09032017-01-EXT-24-envB-laser13';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-09032017-01-EXT-24-envB-laser13';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-498-09032017-01-EXT-24-envB-laser13';
    '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-499-09032017-01-EXT-24-envB-laser13';};
end


%% INITIALIZE
% group CS+=WN
CSplu_WN_GpNb=[465 466 496 498];
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';
% group CS+=bip
CSplu_bip_GpNb=[467 468 497 499];
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

freezeTh=1.5;
rawfig=figure('Position',[1922         301        1664         673]);
barfig=figure('Position',[ 345         554        1557         354]);
barfig_Mov=figure('Position',[ 345         147        1557         354]);

PercF=nan(8,length(Dir.path));
PercF_bef=nan(8,length(Dir.path));
MovQty_During=nan(8,length(Dir.path));
MovQty_bef=nan(8,length(Dir.path));
MovMat=nan(16,length(Dir.path),ceil(105/0.3780));% 105=30sec bef+45 during+30 after / 0.3780=periode enre 2 points de Movtsd

cd /media/DataMOBs57/Fear-Feb2017/behavior
res=pwd;

for man=1:4
    ind_mouse=strfind(Dir.path{man},'Mouse');
    m=str2num(Dir.path{man}(ind_mouse+6:ind_mouse+8));
    cd(Dir.path{man})
    load Behavior Movtsd TTL FreezeEpoch th_immob
    if strcmp(Dir.path{man}, '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-07032017-01-HABlaser')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/300);
    end

    % r�cup�rer les temps des sons       
    DiffTimes=diff(TTL(:,1));
    ind=DiffTimes>2;
    times=TTL(:,1);
    event=TTL(:,2);
    CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
    CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)
    % %definir CS+ et CS- selon les groupes
    if ~isempty(strfind(Dir.path{man},'EXT'))
        if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
            CSpluCode=4; %bip -Append
            CSminCode=3; %White Noise
        elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
            CSpluCode=3;
            CSminCode=4;
        end
    elseif ~isempty(strfind(Dir.path{man},'HAB'))
        CSpluCode=3;
        CSminCode=4;
    end

    CSplu=CStimes(CSevent==CSpluCode);
    CSmin=CStimes(CSevent==CSminCode);

    CSplInt=intervalSet(CSplu*1e4,(CSplu+29)*1e4); % intervals for CS+
    CSmiInt=intervalSet(CSmin*1e4,(CSmin+29)*1e4);

    csp=CStimes(CSevent==CSpluCode);
    csm=CStimes(CSevent==CSminCode);

    save Behavior csm csp -Append
    % get laser stim interval
    if ~isempty(strfind(Dir.path{man},'EXT'))||step>4
        sss=TTL(TTL(:,2)==6,1);
        sI=intervalSet(sss(1:end-1)*1E4,sss(2:end)*1E4);
        sI=dropLongIntervals(sI,1*1E4);
        LaserON_beh=mergeCloseIntervals(sI,0.5*1E4);
    elseif ~isempty(strfind(Dir.path{man},'HAB'))
        sss=TTL(TTL(:,2)==6,1);
        eee=TTL(TTL(:,2)==7,1);
        LaserON_beh=intervalSet(sss*1E4,eee*1E4);
    end

    FreezeEpoch=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4); 


    if rawPlo
        figure(rawfig)
        subplot(4,3,(man-1)*3+[1:3])
         plot(Range(Movtsd,'s'),Data(Movtsd),'k')
            hold on
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Movtsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,k))),'c')
            end

            if step==3 ||step==4
                line([csp csp+30]',0.5*ones(size(csp),2)','Color','b','LineWidth',2)
                line([csm csm+30]',0.5*ones(size(csm),2)','Color','g','LineWidth',2)
            end
            line([Start(LaserON_beh)*1E-4 End(LaserON_beh)*1E-4],[15 15],'Color','c','LineWidth',4)
            title([ num2str(m) ' ' Dir.path{man}(end-17:end)])
            ylim([0 30])

    %         % Movement during CS- and CS+
    %         subplot(2,3,4)
    %         bar([mean(Data(Restrict(Movtsd,CSplInt))),mean(Data(Restrict(Movtsd,CSmiInt)))])
    %         set(gca,'Xticklabel',{'CS+','CS-'})
    %         title('Average movement during sounds')

        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if step<=4
        a=1;
        % Percentage Freezing
        for k=1:2:3
            PercF(a,man)=tot_length(and(FreezeEpoch,subset(CSmiInt,[k:(k+1)])))/tot_length(subset(CSmiInt,[k:(k+1)]));
            PercF_bef(a,man)=tot_length(and(FreezeEpoch,subset(shift(CSmiInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSmiInt,-30*1E4),[k:(k+1)]));
            a=a+1;
        end
        k=1;
        PercF(a,man)=tot_length(and(FreezeEpoch,subset(CSplInt,[k:(k+1)])))/tot_length(subset(CSplInt,[k:(k+1)]));
        PercF_bef(a,man)=tot_length(and(FreezeEpoch,subset(shift(CSplInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSplInt,-30*1E4),[k:(k+1)]));
        a=a+1;
        for k=3:2:11 
            try
                    PercF(a,man)=tot_length(and(FreezeEpoch,and(subset(CSplInt,[k:(k+1)]),LaserON_beh)))/tot_length(and(subset(CSplInt,[k:(k+1)]),LaserON_beh));
                    PercF_bef(a,man)=tot_length(and(FreezeEpoch,subset(shift(CSplInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSplInt,-30*1E4),[k:(k+1)]));
            catch
                keyboard
            end
            a=a+1;
        end
        % MovMat : Movement
        % = raw data 30sec before / 30 during sound /30 after
        for j=1:length(Start(CSmiInt))
            interval_oF_Int=intervalSet(Start(subset(CSmiInt,j))-30*1E4, End(subset(CSmiInt,j))+30*1E4);
            MovMat(j,man,1:length(Data(Restrict(Movtsd,interval_oF_Int))))=Data(Restrict(Movtsd,interval_oF_Int));
        end
        for j=1:length(Start(CSplInt))
            interval_oF_Int=intervalSet(Start(subset(CSplInt,j))-30*1E4, End(subset(CSplInt,j))+30*1E4);
            MovMat(j+4,man,1:length(Data(Restrict(Movtsd,interval_oF_Int))))=Data(Restrict(Movtsd,interval_oF_Int));
        end
        if 0
            figure, bar([nanmean(squeeze(MovMat(:,1,[1:round(30/0.3780)])),2)  nanmean(squeeze(MovMat(:,1,[round(30/0.3780)+1:round(75/0.3780)])),2)  nanmean(squeeze(MovMat(:,1,[round(75/0.3780)+1:round(105/0.3780)])),2)])
            legend ({'30 sec before'; '45s during';'30sec after'})

            figure;
            colori=jet(length(union(CSmiInt,CSplInt)));
            for j=1:length(union(CSmiInt,CSplInt))
                plot([1:length(squeeze(MovMat(j,1,:)))]*0.3780,squeeze(MovMat(j,1,:)),'Color',colori(j,:)),hold on
            end
            figure, 
            shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(1:4,1,:))),nanstd(squeeze(MovMat(1:4,1,:))),'b',1),hold on        
            shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(5:6,1,:))),nanstd(squeeze(MovMat(5:6,1,:))),'r',1) 
            shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(7:8,1,:))),nanstd(squeeze(MovMat(7:8,1,:))),'c',1)
            line([30 75],[40 40],'Color','c','LineWidth',2)
            line([30 60],[35 35],'Color','k','LineWidth',2)
        end
    else
        for k=1:length(Start(LaserON_beh))
        PercF(k,man)=tot_length(and(FreezeEpoch,subset(LaserON_beh,k)))/tot_length(subset(LaserON_beh,k));
        PercF_bef(k,man)=tot_length(and(FreezeEpoch,shift(subset(LaserON_beh,k),-30*1E4)))/tot_length(subset(LaserON_beh,k));

        MovQty_During(k,man)= nanmean(Data(Restrict(Movtsd,subset(LaserON_beh,k))));
        interval_oF_Int=intervalSet(Start(subset(LaserON_beh,k))-30*1E4, Start(subset(LaserON_beh,k)));
        MovQty_bef(k,man)= nanmean(Data(Restrict(Movtsd,interval_oF_Int)));
        end

    end
end
cd(res)
res=pwd;
if sav
saveas(rawfig,[Dir.path{man}(70:end) '_raw.fig'])
saveFigure(rawfig,[Dir.path{man}(70:end) '_raw'],res)
end

figure(barfig);
if step==1
    rang=[2:6];
elseif step==5
    rang=[1:8];
else
    rang=[4:8];
end

subplot(131)
PlotErrorBarN(PercF_bef',0);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if step<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
title(Dir.path{man}(ind_mouse+10:end))
ylabel('freezing before sound')
ylim([0 1 ])

subplot(132)
PlotErrorBarN(PercF',0);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if step<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
title(Dir.path{man}(ind_mouse+10:end))
ylabel('freezing during sound')
ylim([0 1 ])

subplot(133)
h=bar([nanmean(PercF_bef,2) nanmean(PercF,2) ]);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if step<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
legend({'before','during'})
ylim([0 1 ])

if step==5 || step==6
    figure(barfig_Mov)
    subplot(131)
    PlotErrorBarN(MovQty_bef',0);
    ylabel('movement before sound')
    hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
    subplot(132)
    PlotErrorBarN(MovQty_During',0);
    ylabel('movement during sound')
    hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
    subplot(133)
    h=bar([nanmean(MovQty_bef,2) nanmean(MovQty_During,2)  ]);
    hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
    legend({'before','during'})
end
if sav
saveas(barfig,[Dir.path{man}(70:end) '_bar.fig'])
saveFigure(barfig,[Dir.path{man}(70:end) '_bar'],res)
end