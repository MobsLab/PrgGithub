% AnalyseNREMsubstages_N1evalML.m

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
% CaracteristicsSubstagesML.m
% CodePourMarieCrossCorrDeltaSpindlesRipples.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/N1mouvement';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
analyname='AnalySubstagesN1notWake';

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% check that N1 is not only movement

DoEp={'N1','WAKE','N3'};
wind=10E4;% in 1/1E4 second
VarName={'mov','tsdEMG','tsdGhi'};

try
    clear MATsp; load([res,'/',analyname]);
    if exist('MATsp','var'), disp([analyname,' already exists: loaded !']),else, error;end
    
catch
    for n=1:length(DoEp), MATsp{n}=[];for v=1:length(VarName), MAT{n,v}=[];MATind{n,v}=[];end;end
    
    % figure these Marie, aller dans: 
    % /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013%
    % test=colormap('gray');colormap(test(end:-1:1,:));
    % pour movment non-zscore: caxis([0.5 6])
    % pour gamma OB: caxis([31 43]);
    
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        cd(Dir.path{man})
        
        % -----------------------
        % load movements
        clear WAKE REM N1 N2 N3 SleepStages
        try
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close;
            SleepStages=[];
            disp('Calculating SleepStages...')
            for n=1:length(NamesStages)
                eval(['epoch=',NamesStages{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            SavSleepSt{man}=SleepStages;
            
            % -----------------------
            % load movements
            mov=tsd([],[]);
            clear Mmov 
            try load('StateEpoch.mat','Mmov');end
            if exist('Mmov','var')
                rg=Range(Mmov,'s'); Dt=Data(Mmov);
                dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
                mov=tsd(1E4*(rg(1):0.05:rg(end)),zscore(dt)); %sample at 20Hz
                %mov=tsd(1E4*(rg(1):0.05:rg(end)),dt); %sample at 20Hz
            end
            
            % -----------------------
            % laod EMG if exists
            clear InfoLFP emg tsdEMG LFP
            load('LFPData/InfoLFP.mat');
            emg=min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]);
            if ~isempty(emg)
                disp('Loading and filtering EMG channel... WAIT...')
                load(['LFPData/LFP',num2str(emg),'.mat'],'LFP');
                tsdEMG=FilterLFP(LFP,[50 300], 1024);
                Dt=abs(Data(tsdEMG));rg=Range(tsdEMG,'s');
                dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
                tsdEMG=tsd(1E4*(rg(1):0.05:rg(end))',zscore(dt)); %sample at 25Hz
            else
                tsdEMG=tsd([],[]);
            end
            
            % -----------------------
            % load gamma OB
            tsdGhi=tsd([],[]);
            clear Spectro
            try
                %load('StateEpochSB.mat','smooth_ghi');
                %tsdGhi=Restrict(smooth_ghi,ts(Range(Mmov)));
                load('B_High_Spectrum.mat');
                tsdGhi=tsd(Spectro{2}*1E4,mean(10*log10(Spectro{1}(:,Spectro{3}>50 & Spectro{3}<70)),2));
                newTsd=Restrict(tsdGhi,ts(min(Range(tsdGhi)):1E4/49:max(Range(tsdGhi))));
                rg=Range(newTsd);Dt=Data(newTsd);Dt(Dt==Inf | Dt==-Inf)=NaN;
                tsdGhi=tsd(rg,nanzscore(SmoothDec(Dt,100)));
                %tsdGhi=tsd(rg,SmoothDec(Dt,100));
            end
            
            % -----------------------
            % load PFCx spectrum low
            clear channel sp t f Sptsd
            disp('Loading Spectrum PFCx... WAIT...')
            load('ChannelsToAnalyse/PFCx_deep.mat','channel')
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            if man==1,fL=f;end
            Sptsd=tsd(t*1E4,Data(Restrict(tsd(f',Sp'),ts(fL)))');
            
            % -----------------------
            % trig variables on epoch start
            figure('Color',[1 1 1],'Unit','normalized','Position',[0.05 0.1 0.5 0.85]),numF=gcf;
            Cl=nan(length(VarName),2*length(DoEp));
            savM=[];
            for n=1:length(DoEp)
                disp(DoEp{n})
                eval(['epoch=',DoEp{n},';']);
                st=Start(epoch);sto=Stop(epoch);
                durEp=Stop(epoch,'s')-Start(epoch,'s');
                m1=max([Range(mov);Range(tsdEMG);Range(tsdGhi)]);
                m2=min([Range(mov);Range(tsdEMG);Range(tsdGhi)]);
                st=st(st < m1-wind & st > m2+wind);
                sto=sto(st < m1-wind & st > m2+wind);
                durEp=durEp(st < m1-wind & st > m2+wind);
                % previous stage
                NatR=6+zeros(length(st),1);
                for i=1:length(st), try NatR(i)=SleepStages(find(abs(st(i)-SleepStages(:,2)*1E4)<5),3);end;end
                % remove noise episods
                if 1
                    st(NatR==6)=[]; sto(NatR==6)=[]; durEp(NatR==6)=[]; NatR(NatR==6,:)=[];
                end
                
                for v=1:length(VarName)
                    eval(['vr=',VarName{v},';']);
                    if ~isempty(Data(vr))
                        
                        % imagePETH
                        if 1
                            tps=[-10:1/50:10];
                            dt=nan(length(st),length(tps));
                            for tt=1:length(st)
                                I=ts(st(tt)+tps*1E4);
                                dt(tt,:)=Data(Restrict(vr,I))';
                            end
                        else
                            [M,T]=PlotRipRaw(vr,st/1E4,10E3);close;
                            dt=nan(length(st),size(M,1)); dt(1:size(T,1),:)=T;
                            tps=M(:,1);
                        end
                        %figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vr,ts(st),-wind,wind,'BinSize',1); %close;
                        %dt=Data(matVal)'; rg=Range(matVal,'s')';
                        
                        % ------------ period from 0 to 3s after N1 onset --------------
                        [temp,ind]=sortrows(-mean(dt(:,find(tps<3 & tps>0)),2),1);
                        
                        % ------------ order by episod length --------------
                        [~,ind]=sort(durEp);
                        % ------------ order by nature of previous episod --------------
                        [~,ind2]=sort(NatR);
                        
                        figure(numF),
                        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
                        imagesc(tps,1:size(dt,1),dt(ind,:));
                        hold on, plot(durEp(ind),1:size(dt,1),'.k')
                        line([0,0],[0,size(dt,1)],'Color','k','Linewidth',2)
                        %
                        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v),
                        imagesc(tps,1:size(dt,1),dt(ind2,:));
                        idLine=find(diff(NatR(ind2))~=0);
                        for i=1:length(idLine),line(xlim,idLine(i)+[0 0],'Color','k','Linewidth',2);end
                        xlabel(NamesStages(unique(NatR(NatR<6))))
                        
                        % for save
                        temp=MAT{n,v};
                        MAT{n,v}=[temp;dt];
                        temp=MATind{n,v};
                        MATind{n,v}=[temp;[durEp,NatR,man*ones(length(st),1)]];
                        
                        disp(['      - ',VarName{v},' done !'])
                    else
                        disp(['      - skip',VarName{v}])
                    end
                    figure(numF),subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
                    ylabel(VarName{v})
                    xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by epoch duration'})
                    Cl(v,2*n-1:2*n)=caxis;
                    
                    if v==2 && n==1, title(Dir.path{man});end
                    
                    
                end
                
                % get mtspectrum
                [M,S,t]=AverageSpectrogram(Sptsd,fL,ts(st),200,100,0);
                subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*n),
                imagesc(t/1E3,fL,M), axis xy
                line([0,0],[0,size(dt,1)],'Color','k','Linewidth',2)
                ylabel('Spectrum PFCx')
                xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by epoch duration'})
                %xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by (-3)-0s period'})
                
                savM=[savM;M];
            end
            
            % for save
            savM=zscore(savM);
            for n=1:length(DoEp)
                temp=MATsp{n};
                if ~isempty(temp)
                    MATsp{n}=temp+savM(length(fL)*(n-1)+1:length(fL)*n,:);
                else
                    MATsp{n}=savM(length(fL)*(n-1)+1:length(fL)*n,:);
                end
            end
            % caxis
            for v=1:length(VarName)
                m=[min(Cl(v,:)),max(Cl(v,:))];
                for n=1:length(DoEp),
                    subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1), caxis(m);
                    subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v), caxis(m);
                end
            end
            
            % saveFigure
            saveFigure(numF,sprintf(['AnalyseNREM-N1noWake%dzc-',Dir.name{man}],man),FolderToSave);
            
            % plot
            %         figure, plot(Range(tsdGhi,'s'),Data(tsdGhi));
            %         hold on, plot(Range(mov,'s'),rescale(-Data(mov),-1200,0),'k');
            %         legend({'OBgamma','Movmt'})
        catch
            disp('missig data from EMG or Movement, skip')
        end
        
        %if man==3, keyboard;end
    end
    disp(['saving in ',analyname,'...'])
    save([res,'/',analyname],'Dir','SavSleepSt','fL','MATsp','MAT','MATind','DoEp','wind','VarName','t','tps','NamesStages');
    
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< Display ALL concatenates <<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


figure('Color',[1 1 1],'Unit','normalized','Position',[0.05 0.1 0.5 0.85]),numF=gcf;
Cl=nan(length(VarName),2*length(DoEp));
for n=1:length(DoEp)
    for v=1:length(VarName)
        dt=MAT{n,v};
        if ~isempty(dt)
        % ------------ order by episod length --------------
        durEp=MATind{n,v}(:,1);
        [~,ind]=sort(durEp);
        % ------------ order by nature of previous episod --------------
        NatR=MATind{n,v}(:,2);
        [~,ind2]=sort(NatR);
        
        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
        imagesc(tps,1:size(dt,1),dt(ind,:));
        hold on, plot(durEp(ind),1:size(dt,1),'.k')
        line([0,0],[0,size(dt,1)],'Color','k'); ylabel(VarName{v})
        xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by epoch duration'})
        caxis([0 4]);%Cl(v,2*n-1:2*n)=caxis;
        %
        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v),
        imagesc(tps,1:size(dt,1),dt(ind2,:));caxis([0 4]);
        idLine=find(diff(NatR(ind2))~=0);line([0,0],[0,size(dt,1)],'Color','k');
        for i=1:length(idLine),line(xlim,idLine(i)+[0 0],'Color','w','Linewidth',2);end
        xlabel(NamesStages(unique(NatR(NatR<6))))
        end
    end
    % mtspectrum
    subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*n),
    imagesc(t/1E3,fL,MATsp{n}), axis xy
    line([0,0],[min(fL),max(fL)],'Color','k','Linewidth',2)
    ylabel('Spectrum PFCx')
    xlabel(['Time around ',DoEp{n},' start (s)'])
    
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Display mean for ALL <<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
iW=find(strcmp(NamesStages,'WAKE'));
v=1; % mov;
figure('Color',[1 1 1]),
for v=1:3
    subplot(1,3,v),hold on,
    
    dt=MAT{1,v};% N1
    info=MATind{1,v};
    dt2=MAT{2,v};% Wake
    info2=MATind{2,v};
    tps2=[-10:1/20:10];
    if v==3, tps2=tps;end
    
    clear matbar matbar1 matbar2
    for man=1:length(Dir.path)
        matbar(man,1:size(dt,2))=nanmean(dt(find(info(:,3)==man & info(:,2)==iW),:),1); % N1 after wake
        matbar1(man,1:size(dt,2))=nanmean(dt(find(info(:,3)==man & info(:,2)~=iW & info(:,2)<6),:),1); % N1 after other
        matbar2(man,1:size(dt2,2))=nanmean(dt2(find(info2(:,3)==man & info2(:,2)<6),:),1); % WAKE after other
    end
    
    plot(tps2,nanmean(matbar),'Linewidth',2,'Color','k')
    plot(tps2,nanmean(matbar1),'Linewidth',2,'Color','b')
    plot(tps2,nanmean(matbar2),'Linewidth',2,'Color','r')
    ylabel([VarName{v},' zscore']); xlabel('Time (s)')
    Nind=find(isnan(nanmean(matbar,2))==0);
    title(sprintf('n=%d expe, N=%d mice',length(Nind),length(unique(Dir.name(Nind)))))
    plot(tps2,nanmean(matbar)+stdError(matbar),'Color','k');
    plot(tps2,nanmean(matbar1)+stdError(matbar1),'Color','b');
    plot(tps2,nanmean(matbar2)+stdError(matbar2),'Color','r');
    plot(tps2,nanmean(matbar)-stdError(matbar),'Color','k');
    plot(tps2,nanmean(matbar1)-stdError(matbar1),'Color','b');
    plot(tps2,nanmean(matbar2)-stdError(matbar2),'Color','r');
    line([0 0],ylim,'Color',[0.5 0.5 0.5])
end
    legend('WAKE -> N1','other -> N1','other -> WAKE')
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< OLD <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% check that N1 is not only movement
MeanMat=nan(length(Dir.path),2000);
stdMat=nan(length(Dir.path),2000);
%mice=unique(Dir.name);
Colori=colormap('jet');close
Colori=Colori(1:floor(64/length(mice)):end,:);

for man=1:length(Dir.path)
    disp(Dir.path{man})
    cd(Dir.path{man})
    clear Mmov mov N1 channel Sp t f Sptsd InfoLFP emg LFP tsdEMG
    try
        
        %cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251
        [WAKE,REM,N1]=RunSubstages('Movement');%close
        % load movements
        load('StateEpoch.mat','Mmov');
        rg=Range(Mmov,'s'); Dt=Data(Mmov);
        mov=tsd(1E4*(rg(1):0.01:rg(end)),interp1(rg,Dt,rg(1):0.01:rg(end))'); %sample at 100Hz
        
        % laod EMG if exists
        load('LFPData/InfoLFP.mat');
        emg=min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]);
        if ~isempty(emg)
            disp('Loading and filtering EMG channel... WAIT...')
            load(['LFPData/LFP',num2str(emg),'.mat'],'LFP');
            tsdEMG=FilterLFP(LFP,[50 300], 1024);
            dt=abs(Data(tsdEMG));rg=Range(tsdEMG);
            tsdEMG=tsd(rg(1:10:end),SmoothDec(dt(1:10:end),10));
        end
        
        % load PFCx spectrum low
        disp('Loading Spectrum PFCx... WAIT...')
        load('ChannelsToAnalyse/PFCx_deep.mat','channel')
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
        Sptsd=tsd(t*1E4,Sp);fL=f;
        
        % load PFCx spectrum high
        clear Sp t f LFP
        disp('Loading high Spectrum PFCx... WAIT...')
        eval(['load(''SpectrumDataH/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')']);
        SptsdH=tsd(t*1E4,Sp);fH=f;
    catch
        disp('Problem... skipping');close
    end
    
    
    if exist('N1','var')
        st=Start(N1);sto=Stop(N1);
        wind=10E4;% 1/1E4 second
        st=st(st<max(Range(mov))-wind);sto=sto(st<max(Range(mov))-wind);
        % movement
        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(mov,ts(st),-wind,wind,'BinSize',1); %close;
        dt=Data(matVal)';
        rg=Range(matVal,'s')';
        
        % get mtspectrum
        matSp=[];matSpH=[];
        for ep=1:length(st)
            %matSp=[matSp;mean(Data(Restrict(Sptsd,intervalSet(st(ep),st(ep)+wind))),1)];
            matSp=[matSp;mean(Data(Restrict(Sptsd,intervalSet(st(ep),sto(ep)))),1)];
            matSpH=[matSpH;mean(Data(Restrict(SptsdH,intervalSet(st(ep),sto(ep)))),1)];
        end
        
        figure('Color',[1 1 1],'Unit','normalized','Position',[0.05 0.1 0.5 0.85]),
        % ------------ period from -3s to 0s before N1 onset --------------
        
        % movement %
        [temp,ind]=sortrows(-mean(dt(:,rg<0 & rg>-3),2),1);
        subplot(2,8,1), imagesc(rg,1:size(dt,1),dt(ind,:));
        caxis([-max(temp),-min(temp)]); ylabel('Movement')
        xlabel({'Time before N1 start (s)','Ordered by (-3)-0s period'})
        l=min(30,floor(length(ind)/2));
        
        subplot(2,8,2),plot(rg,mean(dt(ind(1:l),:)),'k','Linewidth',2)
        hold on, plot(rg,mean(dt(ind(1:l),:))+std(dt(ind(1:l),:))/sqrt(l),'k')
        hold on, plot(rg,mean(dt(ind(1:l),:))-std(dt(ind(1:l),:))/sqrt(l),'k')
        plot(rg,mean(dt(ind(end-l:end),:)),'b','Linewidth',2)
        hold on, plot(rg,mean(dt(ind(end-l:end),:))+std(dt(ind(end-l:end),:))/sqrt(l),'b')
        hold on, plot(rg,mean(dt(ind(end-l:end),:))-std(dt(ind(end-l:end),:))/sqrt(l),'b')
        xlabel({'Time before N1 start (s)','Ordered by (-3)-0s period'}); ylabel('10*log10(Movement)')
        
        % emg
        if ~isempty(emg)
            figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(tsdEMG,ts(st),-wind,wind,'BinSize',1); close;
            demg=Data(matVal2)';
            remg=Range(matVal2,'s')';
            
            subplot(2,8,3), imagesc(remg,1:size(demg,1),demg(ind,:)); ylabel('EMG')
            xlabel({'Time before N1 start (s)','Ordered by (-3)-0s period'})
            
            subplot(2,8,4),plot(remg,mean(demg(ind(1:l),:)),'k','Linewidth',2)
            hold on, plot(remg,mean(demg(ind(1:l),:))+std(demg(ind(1:l),:))/sqrt(l),'k')
            hold on, plot(remg,mean(demg(ind(1:l),:))-std(demg(ind(1:l),:))/sqrt(l),'k')
            plot(remg,mean(demg(ind(end-l:end),:)),'b','Linewidth',2)
            hold on, plot(remg,mean(demg(ind(end-l:end),:))+std(demg(ind(end-l:end),:))/sqrt(l),'b')
            hold on, plot(remg,mean(demg(ind(end-l:end),:))-std(demg(ind(end-l:end),:))/sqrt(l),'b')
            xlabel({'Time before N1 start (s)','Ordered by (-3)-0s period'}); ylabel('10*log10(EMG)')
        end
        
        % PFCx Spectrum low %
        subplot(2,8,5), imagesc(fL,1:size(dt,1),10*log10(matSp(ind,:)));
        caxis([15,55]); ylabel('Spectrum of 10 first seconds of N1')
        xlabel({'Frequency (Hz) ','Ordered by (-3)-0s period'})
        title({Dir.path{man},' ',' '})
        
        subplot(2,8,6),plot(fL,10*log10(mean(matSp(ind(1:l),:))),'k','Linewidth',2)
        hold on, plot(fL,10*log10(mean(matSp(ind(1:l),:))+std(matSp(ind(1:l),:))/sqrt(l)),'k')
        hold on, plot(fL,10*log10(mean(matSp(ind(1:l),:))-std(matSp(ind(1:l),:))/sqrt(l)),'k')
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))),'b','Linewidth',2)
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))+std(matSp(ind(end-l:end),:))/sqrt(l)),'b')
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))-std(matSp(ind(end-l:end),:))/sqrt(l)),'b')
        xlabel({'Frequency (Hz) ','Ordered by (-3)-0s period'}); ylabel('10*log10(LOWspectrum)')
        
        % PFCx Spectrum high %
        subplot(2,8,7), imagesc(fH,1:size(dt,1),10*log10(matSpH(ind,:)));
        caxis([5,30]);xlim([20 120]); ylabel('Spectrum of 10 first seconds of N1')
        xlabel({'Frequency (log Hz) ','Ordered by (-3)-0s period'})
        
        subplot(2,8,8),plot(fH,10*log10(mean(matSpH(ind(1:l),:))),'k','Linewidth',2)
        hold on, plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))),'b','Linewidth',2)
        hold on, plot(fH,10*log10(mean(matSpH(ind(1:l),:))+std(matSpH(ind(1:l),:))/sqrt(l)),'k')
        hold on, plot(fH,10*log10(mean(matSpH(ind(1:l),:))-std(matSpH(ind(1:l),:))/sqrt(l)),'k')
        plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))+std(matSpH(ind(end-l:end),:))/sqrt(l)),'b')
        plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))-std(matSpH(ind(end-l:end),:))/sqrt(l)),'b')
        legend({[num2str(l),'first'],[num2str(l),'last']})
        xlabel({'Frequency (Hz) ','Ordered by (-3)-0s period'}); ylabel('10*log10(HIGHspectrum)')
        
        % ------------ period from 0 to 2s after N1 onset --------------
        
        % movement %
        [temp,ind]=sortrows(-mean(dt(:,rg<5 & rg>0),2));
        subplot(2,8,9), imagesc(rg,1:size(dt,1),dt(ind,:));
        caxis([-max(temp),-min(temp)]); ylabel('Movement')
        xlabel({'Time before N1 start (s)','Ordered by 0-5s period'})
        l=min(30,floor(length(ind)/2));
        
        subplot(2,8,10),plot(rg,mean(dt(ind(1:l),:)),'k','Linewidth',2)
        hold on, plot(rg,mean(dt(ind(1:l),:))+std(dt(ind(1:l),:))/sqrt(l),'k')
        hold on, plot(rg,mean(dt(ind(1:l),:))-std(dt(ind(1:l),:))/sqrt(l),'k')
        hold on, plot(rg,mean(dt(ind(end-l:end),:)),'b','Linewidth',2)
        hold on, plot(rg,mean(dt(ind(end-l:end),:))+std(dt(ind(end-l:end),:))/sqrt(l),'b')
        hold on, plot(rg,mean(dt(ind(end-l:end),:))-std(dt(ind(end-l:end),:))/sqrt(l),'b')
        ylabel('10*log10(Movement)'); xlabel({'Time before N1 start (s)','Ordered by 0-5s period'})
        
        % emg
        if ~isempty(emg)
            subplot(2,8,11), imagesc(remg,1:size(demg,1),demg(ind,:));ylabel('EMG')
            xlabel({'Time before N1 start (s)','Ordered by (-3)-0s period'})
            
            subplot(2,8,12),plot(remg,mean(demg(ind(1:l),:)),'k','Linewidth',2)
            hold on, plot(remg,mean(demg(ind(1:l),:))+std(demg(ind(1:l),:))/sqrt(l),'k')
            hold on, plot(remg,mean(demg(ind(1:l),:))-std(demg(ind(1:l),:))/sqrt(l),'k')
            plot(remg,mean(demg(ind(end-l:end),:)),'b','Linewidth',2)
            hold on, plot(remg,mean(demg(ind(end-l:end),:))+std(demg(ind(end-l:end),:))/sqrt(l),'b')
            hold on, plot(remg,mean(demg(ind(end-l:end),:))-std(demg(ind(end-l:end),:))/sqrt(l),'b')
            xlabel({'Time before N1 start (s)','Ordered by 0-5s period'}); ylabel('10*log10(EMG)')
        end
        
        % PFCx Spectrum low %
        subplot(2,8,13), imagesc(fL,1:size(dt,1),10*log10(matSp(ind,:)));
        caxis([15,55]); ylabel('Spectrum of 10 first seconds of N1')
        xlabel({'Frequency (Hz) ','Ordered by 0-5s period'})
        
        subplot(2,8,14),plot(fL,10*log10(mean(matSp(ind(1:l),:))),'k','Linewidth',2)
        hold on, plot(fL,10*log10(mean(matSp(ind(1:l),:))+std(matSp(ind(1:l),:))/sqrt(l)),'k')
        hold on, plot(fL,10*log10(mean(matSp(ind(1:l),:))-std(matSp(ind(1:l),:))/sqrt(l)),'k')
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))),'b','Linewidth',2)
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))+std(matSp(ind(end-l:end),:))/sqrt(l)),'b')
        plot(fL,10*log10(mean(matSp(ind(end-l:end),:))-std(matSp(ind(end-l:end),:))/sqrt(l)),'b')
        ylabel('10*log10(LOWspectrum)'); xlabel({'Frequency (Hz) ','Ordered by 0-5s period'})
        
        
        % PFCx Spectrum high %
        subplot(2,8,15), imagesc(fH,1:size(dt,1),10*log10(matSpH(ind,:)));
        caxis([5,30]);xlim([20 120]); ylabel('Spectrum of 10 first seconds of N1')
        xlabel({'Frequency (Hz) ','Ordered by 0-5s period'})
        
        subplot(2,8,16),plot(fH,10*log10(mean(matSpH(ind(1:l),:))),'k','Linewidth',2)
        hold on, plot(fH,10*log10(mean(matSpH(ind(1:l),:))+std(matSpH(ind(1:l),:))/sqrt(l)),'k')
        hold on, plot(fH,10*log10(mean(matSpH(ind(1:l),:))-std(matSpH(ind(1:l),:))/sqrt(l)),'k')
        plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))),'b','Linewidth',2)
        plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))+std(matSpH(ind(end-l:end),:))/sqrt(l)),'b')
        plot(fH,10*log10(mean(matSpH(ind(end-l:end),:))-std(matSpH(ind(end-l:end),:))/sqrt(l)),'b')
        ylabel('10*log10(HIGHspectrum)'); xlabel({'Frequency (Hz) ','Ordered by 0-5s period'})
        
        %keyboard
        saveFigure(gcf,['NREMsubstages_N1MvtSpectrum',num2str(man),Dir.name{man}],'/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages')
        
        MeanMat(man,:)=mean(Data(matVal)');
        stdMat(man,:)=std(Data(matVal)');
    end
end

%% display
figure('Color',[1 1 1],'Unit','normalized','Position',[0.25 0.1 0.2 0.8]), 
subplot(2,1,1), hold on,
for man=1:length(Dir.path)
    plot(-5:10/(size(MeanMat,2)-1):5,zscore(MeanMat(man,:)),'Color',Colori(strcmp(Dir.name{man},mice),:))
end
line([0 0],ylim,'Color','k'); legend('see below','Location','EastOutside')
xlabel('Time (s)'); ylabel('zscore')
title('movement triggered on N1 onset')

subplot(2,1,2), hold on,
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    plot(-5:10/(size(MeanMat,2)-1):5,zscore(nanmean(MeanMat(ind,:),1)),'Color',Colori(mi,:),'Linewidth',2)
end
title(sprintf('N = %d, n = %d',length(mice),length(~isnan(nanmean(MeanMat,2)))))
line([0 0],ylim,'Color','k'); legend(mice,'Location','EastOutside')
xlabel('Time (s)'); ylabel('zscore')

saveFigure(gcf,['AnalyseNREM-movementTrigOnN1_',date],'/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NREMstagesMergeDrop/')
