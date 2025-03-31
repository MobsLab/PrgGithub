%LookForDataPeriods.m

%% OPTIONS
NameDir='BASAL';
useSleepScoringSB=0;
removeNoisyEpochs=1;
namePeriods={'Wake','SWS','REM'};
DoPeriod=2; % 1 for Wake, 2 for SWS, 3 for REM 
erasePrevious=0;
DoHilbert=0; % 1 if Hilbert, 0 for spectra
freqSlow=[30 40]; %[1.5 5];
ZTepoch=10:2:20;

%% ------------------------------ INITIATE -------------------------------

Dir=PathForExperimentsML(NameDir);
ANALYNAME='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/DataBasalZT';

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500]; 
params.pad=2;
if freqSlow(2)<20, 
    HighorLow='L';
    movingwin=[3 0.2];
    params.fpass=[0.01 20];
    params.tapers=[3,5]; %new default [1 2]
else
    HighorLow='H';
    movingwin=[0.1 0.005];
    params.fpass=[20 200];
    params.tapers=[1,2];
end
ANALYNAME=[ANALYNAME,HighorLow];
if DoHilbert, ANALYNAME=[ANALYNAME,'_h'];end

%% ------------------------------ RUN -------------------------------
try 
   load(ANALYNAME)
    MatZTBasal{1,1}(1);
    Start(MatEpochsBasal{1,1});
    MATampBOzt(1,1,1,1);MATampBO(1,1,1);
catch
    
    MATampBO=nan(length(Dir.path),20,length(namePeriods));
    MATampBOzt=nan(length(Dir.path),20,length(ZTepoch),length(namePeriods));
    
    for man=1:length(Dir.path)
        disp('  '); disp([Dir.group{man},' ',Dir.path{man}])
        cd(Dir.path{man})
               
        disp('... Getting channels to analyze')
        clear chanBO InfoLFP SWS       
        % --------------- get channels -------------
        load LFPData/InfoLFP
        chanBO=[InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'))',InfoLFP.depth(strcmp(InfoLFP.structure,'Bulb'))'];
        chanBO=sortrows(chanBO,2); chanBO=chanBO(:,1)';
        
        channel=nan;
        load ChannelsToAnalyse/Bulb_deep.mat
        eval(['LBO=load(''LFPData/LFP',num2str(channel),'.mat'');']);
        
        

        disp('... Recalculating ZeitgeberTime')
        % -------------------------------
        % Recording time
        clear  PreEpoch TimeEndRec tpsdeb tpsfin
        load behavResources PreEpoch TimeEndRec tpsdeb tpsfin
        tfinR=TimeEndRec*[3600 60 1]';
        for ti=1:length(tpsdeb)
            dur(ti)=tpsfin{ti}-tpsdeb{ti};
            tdebR(ti)=tfinR(ti)-dur(ti);
            if ti>1 && tdebR(ti)<=tfinR(ti-1)
                tdebR(ti)=tfinR(ti-1)+1;
            end
        end
        % -------------------------------
        % Recalculate ZT
        clear tsdZT t ZT tim ZTstart ZTstop 
        tim=[]; ZT=[]; t=Range(LBO.LFP,'s')';
        for ttt=1:length(tpsdeb)
            tim_temp=t(t>=tpsdeb{ttt} & t<tpsfin{ttt});
            if tpsdeb{ttt}~=tpsfin{ttt}
                ZT_temp= interp1([tpsdeb{ttt},tpsfin{ttt}],[tdebR(ttt) tfinR(ttt)],tim_temp);
                tim=[tim,tim_temp]; ZT=[ZT,ZT_temp];
                if ~issorted(ZT); disp('problem, TimeEndRec unsorted');keyboard;end
            end
        end
        tsdZT=tsd(1E4*tim',ZT'/3600);
        
        
        disp('... Loading sleep Epochs')
        % -------------------------------
        % sleepscoring info, classical or with bulb SB
        clear MovEpoch Wake REMEpoch SWSEpoch SWS REM
        if useSleepScoringSB
            try
                load StateEpochSB SWSEpoch Wake REMEpoch
                SWSEpoch;
            catch
                BulbSleepScriptKB
                close all
                load StateEpochSB SWSEpoch Wake REMEpoch
            end
            Wake=and(Wake,PreEpoch);
        else
            load StateEpoch SWSEpoch MovEpoch REMEpoch
            Wake=and(MovEpoch,PreEpoch);
        end
        
        SWS=and(SWSEpoch,PreEpoch);
        REM=and(REMEpoch,PreEpoch);
        
        
        % -------------------------------
        % remove noisy epochs
        if removeNoisyEpochs
            clear WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
            load StateEpoch WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
            if ~exist('WeirdNoiseEpoch','var'), WeirdNoiseEpoch=intervalSet([],[]);end
            if ~exist('GndNoiseEpoch','var'), GndNoiseEpoch=intervalSet([],[]);end
            if ~exist('NoiseEpoch','var'), NoiseEpoch=intervalSet([],[]);end
            SWS=SWS-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
            REM=REM-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
            Wake=Wake-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
        end
        
        disp('... Recalculating epochs in ZeitGeber time')
        % -------------------------------
        % Recalculating epochs in ZT
        for per=1:length(namePeriods)
            temp=[];
            eval(['tempep=',namePeriods{per},';'])
            for ep=1:length(Start(tempep))
                ZTe=Data(Restrict(tsdZT,subset(tempep,ep)));
                temp=[temp,min(ZTe),max(ZTe)];
            end
            eval([namePeriods{per},'zt=temp;'])
        end
        

        % --------------- get LFP or Sp -------------
        disp('... Getting Sp or LFP, all channels Bulb')
        cc=1;
        for chan=1:length(chanBO)
            try
                clear S0 amp slow L0
                if DoHilbert
                    eval(['L0=load(''LFPData/LFP',num2str(chanBO(chan)),'.mat'');']);
                    disp(['    LFP',num2str(chanBO(chan))])
                    slow=FilterLFP(L0.LFP,freqSlow,1024);
                    Hil=hilbert(Data(slow));
                    H=abs(Hil);
                    H(H<100)=100;
                    amp=tsd(Range(slow),H);
                else
                    disp(['    Spectrum',num2str(chanBO(chan))])
                    try
                        eval(['S0=load(''SpectrumData',HighorLow,'/Spectrum',num2str(chanBO(chan)),'.mat'');']);
                    catch
                        [Spi,ti,fi]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,'Bulb','All',HighorLow);
                        S0.Sp=Spi; S0.f=fi; S0.t=ti;
                    end
                    amp=tsd(1E4*S0.t',mean(S0.Sp(:,find(S0.f >= freqSlow(1) & S0.f < freqSlow(2))),2));
                end
                
                % restrict per epochs
                for per=1:length(namePeriods)
                    eval(['MATampBO(man,cc,per)=nanmean(Data(Restrict(amp,',namePeriods{per},')));'])
                end
                
                for per=1:length(namePeriods)
                    eval(['epzt=',namePeriods{per},'zt;'])
                    
                    for zt=1:length(ZTepoch)-1
                        sta=epzt(1:2:end); stp=epzt(2:2:end);
                        ep=find(sta>=ZTepoch(zt) & stp<ZTepoch(zt+1));
                        try 
                            eval(['MATampBOzt(man,cc,zt,per)=nanmean(Data(Restrict(amp,subset(',namePeriods{per},',ep))));']) 
%                         catch
%                             keyboard;
                        end
                    end
                end
                
                if chanBO(chan)==channel
                    rankChBO(man)=cc;
                end
                cc=cc+1;
                
                
            catch
                keyboard;
            end
        end
        
        disp('... Saving in MatZTBasal')
        % -------------------------------
        MatZTBasal(man,1:3)={Wakezt,SWSzt,REMzt};
        MatEpochsBasal(man,1:3)={Wake,SWS,REM};
    end
    
    save(ANALYNAME,'NameDir','useSleepScoringSB','removeNoisyEpochs','namePeriods','MatZTBasal','MatEpochsBasal',...
        'MATampBO','freqSlow','params','DoHilbert','MATampBOzt','rankChBO')
end
if DoHilbert, yla='Mean Hilbert Bulb'; else, yla='Mean Spectrum Bulb';end



% -------------------------------------------------------------------------
%% ------------------------------ PLOT DATA -------------------------------
% -------------------------------------------------------------------------
cd /media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb
disp(' '); disp('Adding to plot ...')

figure('Color',[1 1 1]), hold on,
subplot(1,6,1:5), hold on

for man=1:length(Dir.path)
    Wakezt=MatZTBasal{man,1};
    SWSzt=MatZTBasal{man,2};
    REMzt=MatZTBasal{man,3};
    infos(man,1:4)=[min([SWSzt,REMzt]),man,find(strcmp(Dir.group{man},{'WT','dKO'})),str2num(Dir.name{man}(6:end))];
end
%index= sortrows(infos,1);ind=[index(index(:,3)==1,:);index(index(:,3)==2,:)];
index= sortrows(infos,4);ind=index;
%index=infos;ind=index;


a=0;
for man=1:length(ind)
    Wakezt=MatZTBasal{ind(man,2),1};
    SWSzt=MatZTBasal{ind(man,2),2};
    REMzt=MatZTBasal{ind(man,2),3};
    
    % -------------------------------
    plot(Wakezt,a*ones(1,length(Wakezt)),'oc','MarkerFaceColor','c');
    plot(SWSzt,a*ones(1,length(SWSzt)),'or','MarkerFaceColor','r');
    plot(REMzt,a*ones(1,length(REMzt)),'og','MarkerFaceColor','g');
    if a==0, legend({'Wake','SWS','REM'}); end
    
    for ep=1:length(Wakezt)/2
        line([Wakezt(2*ep-1),Wakezt(2*ep)],[a a],'Color','c')
    end
    for ep=1:length(SWSzt)/2
        line([SWSzt(2*ep-1),SWSzt(2*ep)],[a a],'Color','r')
    end
    for ep=1:length(REMzt)/2
        line([REMzt(2*ep-1),REMzt(2*ep)],[a a],'Color','g')
    end
    a=a+2;
end

%hold off,
a=0;
subplot(1,6,6), hold on,
for man=1:size(ind,1)
    tempMat=squeeze(MATampBO(:,:,DoPeriod));
    
    L=sum(~isnan(tempMat(ind(man,2),:)));
    plot(tempMat(ind(man,2),1:L),a*ones(L,1),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5]);
    line(tempMat(ind(man,2),1:L),a*ones(L,1),'Color',[0.5 0.5 0.5])
    if ind(man,3)==2
        hold on, plot(tempMat(ind(man,2),rankChBO(ind(man,2))),a,'ok','MarkerFaceColor','r');
    else
        hold on, plot(tempMat(ind(man,2),rankChBO(ind(man,2))),a,'ok','MarkerFaceColor','k');
    end
    
    a=a+2;
end

%% plot MATampBOzt

figure('Color',[1 1 1])
for zt=1:length(ZTepoch)-1
    
    subplot(length(ZTepoch)-1,10,(zt-1)*10+[1:8]), hold on,
    
    tempMat=squeeze(MATampBOzt(:,:,zt,DoPeriod));
    
    a=0;
    Matbar=nan(length(ind),4);
    for man=1:length(ind)
        L=sum(~isnan(tempMat(ind(man,2),:)));
        plot(a*ones(L,1),tempMat(ind(man,2),1:L),'o','Color',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5]);
        line(a*ones(L,1),tempMat(ind(man,2),1:L),'Color',[0.5 0.5 0.5])
        if ind(man,3)==2
            hold on, plot(a,tempMat(ind(man,2),rankChBO(ind(man,2))),'ok','MarkerFaceColor','r');
        else
            hold on, plot(a,tempMat(ind(man,2),rankChBO(ind(man,2))),'ok','MarkerFaceColor','k');
        end
        Matbar(man,1:4)=[tempMat(ind(man,2),rankChBO(ind(man,2))),max(tempMat(ind(man,2),:)),ind(man,3:4)];
        a=a+2;
    end
    
    title(['t=',num2str(ZTepoch(zt)),'h-',num2str(ZTepoch(zt+1)),'h'])
    ylabel(yla)
    
    % plot bar N
    Uwt=unique(Matbar(Matbar(:,3)==1,4));
    Udko=unique(Matbar(Matbar(:,3)==2,4));
    MattM=nan(max(length(Uwt),length(Udko)),2);
    for i=1:length(Uwt)
        MattM(i,1)=nanmean(Matbar(Matbar(:,4)==Uwt(i),1));
        MattMax(i,1)=nanmean(Matbar(Matbar(:,4)==Uwt(i),2));
    end
    for i=1:length(Udko)
        MattM(i,2)=nanmean(Matbar(Matbar(:,4)==Udko(i),1));
        MattMax(i,2)=nanmean(Matbar(Matbar(:,4)==Udko(i),2));
    end
    
    subplot(length(ZTepoch)-1,10,(zt-1)*10+9), 
    pval=plotErrorBarN(MattM,0,0);
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'WT','dKO'})
    title(['p=',num2str(floor(1E3*pval)/1E3)])
    
    subplot(length(ZTepoch)-1,10,zt*10), 
    pval=plotErrorBarN(MattMax,0,0);
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'WT','dKO'})
    title(['p=',num2str(floor(1E3*pval)/1E3)])
end
