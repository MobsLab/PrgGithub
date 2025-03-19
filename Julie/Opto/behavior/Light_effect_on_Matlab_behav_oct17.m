% Light_effect_on_Matlab_behav_july17.m
% 10.03.2017
% crude code to see effect quickly (uses matlab tracking which is sensitive
% to video trcking artifacts)

% Light_effect_on_Matlab_behav_feb17.m
% from PSTH_behav_FreezAcctsd_XXX.m
% 07.03.2017

% aims at showing the behavioral effect of light
% uses Matlab tracking data (but tracking artefacts due to cables on HAB
% envC (jour=1)
%% OPTION
rawPlo=1;
sav=0;
jour=6;
manip_name='Fear_July-Oct2017';%manip_name='Fear-Oct2017';%manip_name='Fear_July2017';

%% INTPUTS
gfpmice=[1 2 3];
chr2mice=[4 5 6 7 8 9];
% 
% 
% gfpmice=[1 5 6];
% chr2mice=[2 3 4 7 8 9];
% % 
% gfpmice=[1 ];
% chr2mice=[2:4];
% gfpmice=[1 2 ];
% chr2mice=[3:5];
% 
if jour==5;
Dir.path={
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-25072017-01-HABlaser13_envA/';
    
    '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-610-03102017-01-HABenvtest';
    '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-611-03102017-01-HABenvtest';
    
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-25072017-01-HABlaser13_envA/';
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-25072017-01-HABlaser13_envA/';
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-25072017-01-HABlaser13_envA/';
%     
    '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-612-03102017-01-HABenvtest';
    '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-613-03102017-01-HABenvtest';
    '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-614-03102017-01-HABenvtest';
    };
stepN=1;

elseif jour==6;
Dir.path={
    
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-27072017-01-EXT-24/';
    
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-610-05102017-01-EXT-24';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-611-05102017-01-EXT-24';
    
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-27072017-01-EXT-24/';
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-27072017-01-EXT-24/';
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-27072017-01-EXT-24/';

    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-612-05102017-01-EXT-24';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-613-05102017-01-EXT-24';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-614-05102017-01-EXT-24';
    
    };
    stepN=2;
elseif jour==7;
Dir.path={
    
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-28072017-01-EXT-48/';
        
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-610-06102017-01-EXT-48_laser13';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-611-06102017-01-EXT-48_laser13';
    
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-28072017-01-EXT-48/';
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-28072017-01-EXT-48/';
%     '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-28072017-01-EXT-48/';

    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-612-06102017-01-EXT-48_laser13';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-613-06102017-01-EXT-48_laser13';
    '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-614-06102017-01-EXT-48_laser13';

%     
    };
    stepN=3;
elseif jour==8;
Dir.path={ 
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-26072017-01-COND/';
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-26072017-01-COND/';
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-26072017-01-COND/';
    '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-26072017-01-COND/';
  };
    stepN=4; 
    
elseif jour==9;        % define stepN

end


%% INITIALIZE
CSplu_WN_GpNb=[465 466 496 498 502 504 506 537 540 542 543 610 611 612 613 614];
for k=1:length(CSplu_WN_GpNb),   CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k)); end
CSplu_WN_Gp=CSplu_WN_Gp';

CSplu_bip_GpNb=[467 468 497 499 503 505];
for k=1:length(CSplu_bip_GpNb), CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));end
CSplu_bip_Gp=CSplu_bip_Gp';

StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};

freezeTh=1.5;
rawfig=figure('Position',[ 1922           2        1225         972]);
% barfig=figure('Position',[ 345         554        1557         354]);
% barfig_Mov=figure('Position',[ 345         147        1557         354]);

PercF=nan(8,length(Dir.path));
PercF_bef=nan(8,length(Dir.path));
MovQty_During=nan(8,length(Dir.path));
MovQty_bef=nan(8,length(Dir.path));
MovMat=nan(16,length(Dir.path),ceil(105/0.3780));% 105=30sec bef+45 during+30 after / 0.3780=periode enre 2 points de Movtsd

cd(['/media/DataMOBs57/' manip_name '/behavior/'])
res=pwd;

% CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
%  period='fullperiod';
period='fullperiod'; optionfullper='close2sound';
% period='fullperiod'; optionfullper='fullblocks';
% period='soundonly'; optionfullper='';

for man=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{man},'Mouse');
    m=str2num(Dir.path{man}(ind_mouse+6:ind_mouse+8));
    cd(Dir.path{man})
    load Behavior Movtsd TTL FreezeEpoch th_immob
    if strcmp(Dir.path{man}, '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-07032017-01-HABlaser')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/300);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-10032017-01-EXT-48-envC_laser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/200);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-504-14032017-01-HABlaser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/388);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-506-14032017-01-HABlaser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/454);
    end
    % recuperer les temps des sons 
    try 
        load Behavior csm csp CSplInt CSmiInt 
        csm; csp; CSplInt;CSmiInt;
    catch
        load Behavior TTL
        DiffTimes=diff(TTL(:,1));
        ind=DiffTimes>2;
        times=TTL(:,1);
        event=TTL(:,2);
        CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
        CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)
        % %definir CS+ et CS- selon les groupes
        if ~isempty(strfind(Dir.path{man},'EXT'))||~isempty(strfind(Dir.path{man},'COND'))
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

        save Behavior csm csp CSplInt CSmiInt -Append
    end

    % get laser stim interval
    if isempty(strfind(Dir.path{man},'COND'))
        sss=TTL(TTL(:,2)==6,1);
        sI=intervalSet(sss(1:end-1)*1E4,sss(2:end)*1E4);
        sI=dropLongIntervals(sI,1*1E4);
        LaserON_beh=mergeCloseIntervals(sI,0.5*1E4);
    end

    FreezeEpoch=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4); 
    
   % define interval of interest
%     try
%         NosoundNoLaserPer;
%         NosoundWithLaserPer;
%         NosoundPer;
%         CsminPer;
%         CspluPer0;CspluPer1;CspluPer2;CspluPer3;
%     catch
        NosoundNoLaserPer=intervalSet(0,60*1e4);
        NosoundWithLaserPer=intervalSet(60*1e4,120*1e4);
        NosoundPer=intervalSet(0,120*1e4);
        if ~isempty(strfind(Dir.path{man},'EXT'))
            if strcmp(optionfullper,'fullblocks');
                CsminPer=intervalSet(Start(subset(CSmiInt,1)),Start(subset(CSplInt,1))); % the block of four CS-
                CspluPer0=intervalSet(Start(subset(CSplInt,1)),Start(subset(CSplInt,3))); % CS+ no laser
                CspluPer1=intervalSet(Start(subset(CSplInt,3)),Start(subset(CSplInt,5))); % 1st block of four CS+
                CspluPer2=intervalSet(Start(subset(CSplInt,5)),Start(subset(CSplInt,9))); % 2nd block of four CS+
                CspluPer3=intervalSet(Start(subset(CSplInt,9)),1400*1e4); 
            elseif strcmp(optionfullper,'close2sound');
                CsminPer=intervalSet(Start(subset(CSmiInt,1)),Start(subset(CSplInt,1))); % the block of four CS-
                CspluPer0=intervalSet(Start(subset(CSplInt,1)),End(subset(CSplInt,2))+30*1E4); % CS+ no laser
                CspluPer1=intervalSet(Start(subset(CSplInt,3)),End(subset(CSplInt,4))+30*1E4); % 1st block of four CS+
                CspluPer2=intervalSet(Start(subset(CSplInt,5)),End(subset(CSplInt,8))+30*1E4); % 2nd block of four CS+
                CspluPer3=intervalSet(Start(subset(CSplInt,9)),End(subset(CSplInt,12))+30*1E4);                
                
                
            end
        else
            
            CsminPer=intervalSet(122*1e4,408*1e4); % the block of four CS-
            CspluPer0=intervalSet(408*1e4,600*1e4); % 
            CspluPer1=intervalSet(600*1e4,789*1e4); % 1st block of four CS+  % intervalSet(408*1e4,789*1e4);
            CspluPer2=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
            CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
        end
        
%     end

    if rawPlo
        figure(rawfig)
        subplot(length(Dir.path),5,(man-1)*5+[1:3])
         plot(Range(Movtsd,'s'),Data(Movtsd),'k')
            hold on
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Movtsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,k))),'c')
            end

            if jour>2
                line([csp csp+30]',13*ones(size(csp),2)','Color','b','LineWidth',2)
                line([csm csm+30]',13*ones(size(csm),2)','Color','g','LineWidth',2)
            end
            if isempty(strfind(Dir.path{man},'COND'))
                line([Start(LaserON_beh)*1E-4 End(LaserON_beh)*1E-4],[15 15],'Color','c','LineWidth',4)
            end
            title([  'max ' num2str(max(Data(Movtsd)))])                                                     
            ylabel(num2str(m))
            if man==1, text(0,1.2,StepName{stepN},'units','normalized'); end
            ylim([0 30]),xlim([0 1420])
            aa=21;
%             line([Start(NosoundNoLaserPer)*1E-4 End(NosoundNoLaserPer)*1E-4],[aa aa]);aa=aa+1;
%             line([Start(NosoundWithLaserPer)*1E-4 End(NosoundWithLaserPer)*1E-4],[aa aa]);aa=aa+1;
            line([Start(NosoundPer)*1E-4 End(NosoundPer)*1E-4],[aa aa]);aa=aa+1;
            line([Start(CsminPer)*1E-4 End(CsminPer)*1E-4],[aa aa]); aa=aa+1;
            line([Start(CspluPer0)*1E-4 End(CspluPer0)*1E-4],[aa aa]); aa=aa+1;
            line([Start(CspluPer1)*1E-4 End(CspluPer1)*1E-4],[aa aa]); aa=aa+1;
            line([Start(CspluPer2)*1E-4 End(CspluPer2)*1E-4],[aa aa]); aa=aa+1;
            line([Start(CspluPer3)*1E-4 End(CspluPer3)*1E-4],[aa aa]); aa=aa+1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bilanMovtsd{man}=Movtsd;
    Ep=FreezeEpoch;
    if strcmp(period,'fullperiod')
        %percentage of freeing during the different periods (four CS- and each block of four CS+)
        try
            bilan{stepN}(man,:)=[length(Data(Restrict(Movtsd,and(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                length(Data(Restrict(Movtsd,and(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer0))))/length(Data(Restrict(Movtsd,CspluPer0))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))];
        catch
            bilan{stepN}(mousenb,:)=NaN(1,4);
            disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
        end
    elseif strcmp(period,'soundonly')
        %percentage of freeing during the different the sounds only (be carefull groupinf different for HAB/COND and EXT)
        % spearation 2 paires de CS- => pas tres utile
    %     sounds1=intervalSet(Start(subset(CSmiInt,[1:2])),Start(subset(CSmiInt,[1:2]))+45*1e4) ;
    %     sounds2=intervalSet(Start(subset(CSmiInt,[3:4])),Start(subset(CSmiInt,[3:4]))+45*1e4) ;%=subset(CSmiInt,[3:4]);
        if ~isempty(strfind(Dir.path{man},'EXT'))
            sounds1=intervalSet(Start(subset(CSmiInt,[1:4])),Start(subset(CSmiInt,[1:4]))+45*1e4) ;
            sounds3=intervalSet(Start(subset(CSplInt,[1:2])),Start(subset(CSplInt,[1:2]))+45*1e4) ;%=subset(CSplInt,[1:2]);
            sounds4=intervalSet(Start(subset(CSplInt,[3:4])),Start(subset(CSplInt,[3:4]))+45*1e4) ;%=subset(CSplInt,[3:4]);       
            sounds5=intervalSet(Start(subset(CSplInt,[5:8])),Start(subset(CSplInt,[5:8]))+45*1e4) ;%=subset(CSplInt,[5:8]);
            sounds6=intervalSet(Start(subset(CSplInt,[9:12])),Start(subset(CSplInt,[9:12]))+45*1e4) ;%=subset(CSplInt,[9:12]);
        else 
            sounds1=intervalSet(Start(subset(CSmiInt,[1:2])),Start(subset(CSmiInt,[1:2]))+45*1e4) ;
            sounds3=intervalSet(Start(subset(CSplInt,[1:2])),Start(subset(CSplInt,[1:2]))+45*1e4) ;
            sounds4=intervalSet(Start(subset(CSmiInt,[3:4])),Start(subset(CSmiInt,[3:4]))+45*1e4) ;
            sounds5=intervalSet(Start(subset(CSplInt,[3:4])),Start(subset(CSplInt,[3:4]))+45*1e4) ;
            sounds6=intervalSet(0,0) ;%=subset(CSplInt,[9:12]);
        end
        try
            bilan{stepN}(man,:)=[length(Data(Restrict(Movtsd,and(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds1))))/length(Data(Restrict(Movtsd,sounds1))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds3))))/length(Data(Restrict(Movtsd,sounds3))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds4))))/length(Data(Restrict(Movtsd,sounds4))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds5))))/length(Data(Restrict(Movtsd,sounds5))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds6))))/length(Data(Restrict(Movtsd,sounds6)))];
        catch
            bilan{stepN}(mousenb,:)=NaN(1,4);
            disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
        end
    end
                    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%     if jour<=4
%         a=1;
%         % Percentage Freezing
%         for k=1:2:3
%             PercF(a,man)=tot_length(And(FreezeEpoch,subset(CSmiInt,[k:(k+1)])))/tot_length(subset(CSmiInt,[k:(k+1)]));
%             PercF_bef(a,man)=tot_length(And(FreezeEpoch,subset(shift(CSmiInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSmiInt,-30*1E4),[k:(k+1)]));
%             a=a+1;
%         end
%         k=1;
%         PercF(a,man)=tot_length(And(FreezeEpoch,subset(CSplInt,[k:(k+1)])))/tot_length(subset(CSplInt,[k:(k+1)]));
%         PercF_bef(a,man)=tot_length(And(FreezeEpoch,subset(shift(CSplInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSplInt,-30*1E4),[k:(k+1)]));
%         a=a+1;
%         for k=3:2:11 
%             try
%                     PercF(a,man)=tot_length(And(FreezeEpoch,And(subset(CSplInt,[k:(k+1)]),LaserON_beh)))/tot_length(And(subset(CSplInt,[k:(k+1)]),LaserON_beh));
%                     PercF_bef(a,man)=tot_length(And(FreezeEpoch,subset(shift(CSplInt,-30*1E4),[k:(k+1)])))/tot_length(subset(shift(CSplInt,-30*1E4),[k:(k+1)]));
%             catch
%                 keyboard
%             end
%             a=a+1;
%         end
%         % MovMat : Movement
%         % = raw data 30sec before / 30 during sound /30 after
%         for j=1:length(Start(CSmiInt))
%             interval_oF_Int=intervalSet(Start(subset(CSmiInt,j))-30*1E4, End(subset(CSmiInt,j))+30*1E4);
%             MovMat(j,man,1:length(Data(Restrict(Movtsd,interval_oF_Int))))=Data(Restrict(Movtsd,interval_oF_Int));
%         end
%         for j=1:length(Start(CSplInt))
%             interval_oF_Int=intervalSet(Start(subset(CSplInt,j))-30*1E4, End(subset(CSplInt,j))+30*1E4);
%             MovMat(j+4,man,1:length(Data(Restrict(Movtsd,interval_oF_Int))))=Data(Restrict(Movtsd,interval_oF_Int));
%         end
%         if 0
%             figure, bar([nanmean(squeeze(MovMat(:,1,[1:round(30/0.3780)])),2)  nanmean(squeeze(MovMat(:,1,[round(30/0.3780)+1:round(75/0.3780)])),2)  nanmean(squeeze(MovMat(:,1,[round(75/0.3780)+1:round(105/0.3780)])),2)])
%             legend ({'30 sec before'; '45s during';'30sec after'})
% 
%             figure;
%             colori=jet(length(union(CSmiInt,CSplInt)));
%             for j=1:length(union(CSmiInt,CSplInt))
%                 plot([1:length(squeeze(MovMat(j,1,:)))]*0.3780,squeeze(MovMat(j,1,:)),'Color',colori(j,:)),hold on
%             end
%             figure, 
%             shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(1:4,1,:))),nanstd(squeeze(MovMat(1:4,1,:))),'b',1),hold on        
%             shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(5:6,1,:))),nanstd(squeeze(MovMat(5:6,1,:))),'r',1) 
%             shadedErrorBar([1:length(squeeze(MovMat(j,1,:)))]*0.3780,nanmean(squeeze(MovMat(7:8,1,:))),nanstd(squeeze(MovMat(7:8,1,:))),'c',1)
%             line([30 75],[40 40],'Color','c','LineWidth',2)
%             line([30 60],[35 35],'Color','k','LineWidth',2)
%         end
%     else
%         for k=1:length(Start(LaserON_beh))
%         PercF(k,man)=tot_length(And(FreezeEpoch,subset(LaserON_beh,k)))/tot_length(subset(LaserON_beh,k));
%         PercF_bef(k,man)=tot_length(And(FreezeEpoch,shift(subset(LaserON_beh,k),-30*1E4)))/tot_length(subset(LaserON_beh,k));
% 
%         MovQty_During(k,man)= nanmean(Data(Restrict(Movtsd,subset(LaserON_beh,k))));
%         interval_oF_Int=intervalSet(Start(subset(LaserON_beh,k))-30*1E4, Start(subset(LaserON_beh,k)));
%         MovQty_bef(k,man)= nanmean(Data(Restrict(Movtsd,interval_oF_Int)));
%         end
% 
%     end
end

if rawPlo
    cd(res)
    try
        temp=load([StepName{stepN} '_' period  '_' optionfullper],'bilan');
        bilan2=temp.bilan;
    catch
        bilan2=bilan;
    end
    for man=1:length(Dir.path)
        figure(rawfig)
        subplot(length(Dir.path),5,(man-1)*5+4)
        bar(bilan{stepN}(man,:)), hold on %hold off
        if man==1,title(period),end
        if ~isempty(strfind(Dir.path{man},'EXT'))
            ylabel(optionfullper)
        end
%         abscis=[4 5 6];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 
%         abscis=[2];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','g','LineWidth',2); 
        
%         subplot(length(Dir.path),5,(man-1)*5+5)
%         bar(bilan2{stepN}(man,:)), hold on
%         abscis=[3];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','b','LineWidth',2); 
%         abscis=[4 5 6 ];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 
%         abscis=[2 ];
%         line([abscis-0.4;abscis+0.4],[0 0],'Color','g','LineWidth',2); 
%         if man==1,title('sound only'),end
set(gca,'XTickLabel',{'o';'-';'+';'+l';'+l';'+l';}), ylim([0 1  ])

    end
end


cd(res)
res=pwd;
if sav
saveas(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw.fig'])
saveFigure(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw'],res)
end
if sav
    cd(res)
    save([StepName{stepN} '_' period '_' optionfullper], 'bilan','StepName', 'Dir', 'freezeTh','period','bilanMovtsd','optionfullper')
end

figure ('Position',[ 507         517        1371         259])
subplot(1,3,1), PlotErrorBarN(bilan{stepN}(chr2mice,:),0)
ylim([0 1]), title('ChR2')
text(-0.2,1.05,[period],'units','normalized')
if ~isempty(strfind(Dir.path{man},'EXT'))
    ylabel(optionfullper)
end
subplot(1,3,2), PlotErrorBarN(bilan{stepN}(gfpmice,:),0)

ylim([0 1]), title('GFP')
subplot(1,3,3), bar([nanmean(bilan{stepN}(chr2mice,:),1); nanmean(bilan{stepN}(gfpmice,:),1)]')
ylim([0 1]), legend('ChR2','GFP')
for sp=1:3
    subplot(1,3,sp), hold on
    abscis=[2 ];
    line([abscis-0.4;abscis+0.4],[0 0],'Color','g','LineWidth',2); 
    abscis=[3];
    line([abscis-0.4;abscis+0.4]',[0 0],'Color','b','LineWidth',2); 
    abscis=[4 5 6 ];
    line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 

end
title( StepName{stepN})
if sav
saveas (gcf,[StepName{stepN} '_' period '_' optionfullper 'mean.fig'])
cd(res)
saveFigure(gcf,[StepName{stepN} '_' period '_' optionfullper 'mean'],res)
end



%% Quantification Freezing before sounds
figure, bar(bilan{stepN}')

barfig=figure;
figure(barfig);
if jour==1
    rang=[2:6];
elseif jour==5
    rang=[1:8];
else
    rang=[4:8];
end

subplot(131)
PlotErrorBarN(PercF_bef',0);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if jour<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
title(Dir.path{man}(ind_mouse+10:end))
ylabel('freezing before sound')
ylim([0 1 ])

subplot(132)
PlotErrorBarN(PercF',0);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if jour<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
title(Dir.path{man}(ind_mouse+10:end))
ylabel('freezing during sound')
ylim([0 1 ])

subplot(133)
h=bar([nanmean(PercF_bef,2) nanmean(PercF,2) ]);
hold on,line(([rang-0.4;rang+0.4]),0.7*[1 1],'Color','c', 'LineWidth',4)
set (gca, 'XTick',[1:8])
if jour<=4, set (gca, 'XTickLabel',{'-';'-';'+';'+';'+';'+';'+';'+'}), end
legend({'before','during'})
ylim([0 1 ])

if jour==5 || jour==6
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
saveas(barfig,[Dir.path{man}(70:end) '_' optionfullper '_bar.fig'])
saveFigure(barfig,[Dir.path{man}(70:end) '_' optionfullper '_bar'],res)
end