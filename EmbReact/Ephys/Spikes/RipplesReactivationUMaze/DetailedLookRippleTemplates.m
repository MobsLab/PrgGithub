clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB

Binsize = 0.1*1e4;
SpeedLim = 2;

EpoName = {'Hab','Cond','TestPost'};

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    Ripples.Cond{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'ripples');
    
    Ripples.SleepPre{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'epoch','epochname','sleepstates');
    Ripples.SleepPre{mm} = Restrict(Ripples.SleepPre{mm},SleepStates{2});
    
    Ripples.SleepPost{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'epoch','epochname','sleepstates');
    Ripples.SleepPost{mm} = Restrict(Ripples.SleepPost{mm},SleepStates{2});
    
    Spikes{mm}.SleepPre = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'spikes');
    cd(Dir{mm}.SleepPre{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPre = Spikes{mm}.SleepPre(numNeurons);
    
    
    Spikes{mm}.SleepPost = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'spikes');
    cd(Dir{mm}.SleepPost{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPost = Spikes{mm}.SleepPost(numNeurons);
    
    for ep = 1:length(EpoName)
        
        Spikes{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'spikes');
        cd(Dir{mm}.(EpoName{ep}){1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes{mm}.(EpoName{ep}) = Spikes{mm}.(EpoName{ep})(numNeurons);
        
        NoiseEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','noiseepochclosestims');
        FreezeEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','freezeepoch');
        StimEpoch{mm}.(EpoName{ep})= ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','stimepoch');
        
        LinPos{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'linearposition');
        Vtsd{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'speed');
        MovEpoch{mm}.(EpoName{ep}) = thresholdIntervals(Vtsd{mm}.(EpoName{ep}),SpeedLim,'Direction','Above');
        MovEpoch{mm}.(EpoName{ep}) = mergeCloseIntervals(MovEpoch{mm}.(EpoName{ep}),2*1e4);
        
        
        
    end
end

%%%%
SaveFig = '/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/';
timebin = [0.01,0.05,0.1,0.2]; % in s
RipEpoch = {'Cond','SleepPre','SleepPost'};

for rr = 1:length(RipEpoch)
    for tb = 1%:length(timebin)
        BinSize = timebin(tb);
        mkdir([SaveFig 'Timebin' num2str(timebin(tb)*10)])
        clear ProjInfo ProjInfoPre StrInfo StrInfoPre
        
        for mm=1:length(MiceNumber)
            
            Q = MakeQfromS(Spikes{mm}.(RipEpoch{rr}),BinSize*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            Q_temp = Data(Q);
            clear AllRip
            if rr == 1
                StimEpochToRemove = intervalSet(Start(StimEpoch{mm}.Cond),Start(StimEpoch{mm}.Cond)+0.2*1e4);
                Ripples_Sf = Restrict(Ripples.(RipEpoch{rr}){mm},thresholdIntervals(LinPos{mm}.Cond,0.6,'Direction','Above'));
            else
                StimEpochToRemove = intervalSet(0,0.1);
                Ripples_Sf = Ripples.(RipEpoch{rr}){mm};
            end
            
            
            PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples_Sf)-0.1*1e4,Range(Ripples_Sf)+0.3*1e4),0.1*1e4)-StimEpochToRemove;
            AllRip = Data(Restrict(Q,PostRipples));
            
            clear varexpl varexpl_CV
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(AllRip,0);
            
            RemovRipEpoc = intervalSet(0,max(Range(Q))) - PostRipples;
            
            % Position
            for ep_pos = 1:3
                Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),BinSize*1e4);
                
                strength_temp = ReactivationStrength_SB(nanzscore(Data(Q)),templates);
                
                clear proj_temp
                for e =  1: size(eigenvectors,2)
                    proj_temp(:,e) = nanzscore(Data(Q))*eigenvectors(:,e);
                end
                
                for comp = 1:size(strength_temp,2)
                    strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                    proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                    pos_tsd = LinPos{mm}.(EpoName{ep_pos});
                    
                    if ep_pos==2
                        strength_temp_tsd = Restrict(strength_temp_tsd,RemovRipEpoc);
                        proj_temp_tsd = Restrict(proj_temp_tsd,RemovRipEpoc);
                        pos_tsd = Restrict(pos_tsd,RemovRipEpoc);
                    end
                    
                    for l = 1:8
                        LitEpo = thresholdIntervals(pos_tsd,(l-1)*0.125,'Direction','Above');
                        LitEpo = and(LitEpo,thresholdIntervals(pos_tsd,(l)*0.125,'Direction','Below'));
                        StrInfo.StrPos{mm}(ep_pos,comp,l) = nanmean(Data(Restrict(strength_temp_tsd,LitEpo)));
                        ProjInfo.StrPos{mm}(ep_pos,comp,l) = nanmean(Data(Restrict(proj_temp_tsd,LitEpo)));
                        
                    end
                    
                    [R,P] = corrcoef(Data(strength_temp_tsd),Data(Restrict(pos_tsd,Range(strength_temp_tsd))));
                    StrInfo.CorrPos{mm}(ep_pos,comp) = (R(1,2));
                    StrInfo.CorrPos_Sig{mm}(ep_pos,comp) = (P(1,2));
                    
                    [R,P] = corrcoef(Data(proj_temp_tsd),Data(Restrict(pos_tsd,Range(proj_temp_tsd))));
                    ProjInfo.CorrPos{mm}(ep_pos,comp) = (R(1,2));
                    ProjInfo.CorrPos_Sig{mm}(ep_pos,comp) = (P(1,2));
                end
            end
            
            % Stimulation
            Evts = Start(StimEpoch{mm}.Cond,'s');
            
            Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
            strength_temp = ReactivationStrength_SB(nanzscore(Data(Q)),templates);
            
            clear proj_temp
            for e =  1: size(eigenvectors,2)
                proj_temp(:,e) = nanzscore(Data(Q))*eigenvectors(:,e);
            end
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                pos_tsd = LinPos{mm}.(EpoName{ep_pos});
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,5000,0,0);
                StrInfo.StimResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,5000,0,0);
                ProjInfo.StimResp{mm}(comp,:) = M(:,2);
                
            end
            tps_stim = M(:,1);
            Fr_tsd = tsd(Range(Q),nanmean(Data(Q)')');
            [M,T] = PlotRipRaw(Fr_tsd,Evts,5000,0,0);
%             ProjInfo.StimResp{mm}(:,M(:,2)<0.1) = NaN;
%             StrInfo.StimResp{mm}(:,M(:,2)<0.1) = NaN;
            
            % Freezing
            Evts = Start(FreezeEpoch{mm}.Cond,'s');
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,5000,0,0);
                StrInfo.FreezeResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,5000,0,0);
                ProjInfo.FreezeResp{mm}(comp,:) = M(:,2);
            end
            tps_fz = M(:,1);
            
            % Ripples
            Ep =  FreezeEpoch{mm}.Cond - or(NoiseEpoch{mm}.Cond,StimEpochToRemove);
            Evts = Range(Restrict(Ripples.Cond{mm},Ep),'s');
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
                StrInfo.RipResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
                ProjInfo.RipResp{mm}(comp,:) = M(:,2);
            end
            tps_rip = M(:,2);
            
            fig = figure;
            subplot(4,4,1)
            PlotErrorBarN_KJ(abs(ProjInfo.CorrPos{mm}'),'newfig',0)
            set(gca,'XTick',1:3,'XTickLabel',EpoName)
            ylabel('Proj')
            title('Spat corr')
            
            subplot(4,4,2)
            PlotErrorBarN_KJ(abs(StrInfo.CorrPos{mm}'),'newfig',0)
            set(gca,'XTick',1:3,'XTickLabel',EpoName)
            ylabel('React str')
            title('Spat corr')
            
            subplot(4,4,3)
            imagesc(tps_stim,1:size(strength_temp,2),nanzscore(ProjInfo.StimResp{mm}')')
            title('Stim Proj')
            
            
            subplot(4,4,4)
            imagesc(tps_stim,1:size(strength_temp,2),nanzscore(StrInfo.StimResp{mm}')')
            title('Stim ReSt')
            caxis([-2 4])
            
            subplot(4,4,5)
            imagesc(tps_fz,1:size(strength_temp,2),nanzscore(ProjInfo.FreezeResp{mm}')')
            title('Fz ReSt')
            caxis([-2 2])
            
            subplot(4,4,6)
            imagesc(tps_fz,1:size(strength_temp,2),nanzscore(StrInfo.FreezeResp{mm}')')
            title('Fz Proj')
            caxis([-2 2])
            
            subplot(4,4,7)
            imagesc(tps_rip,1:size(strength_temp,2),nanzscore(ProjInfo.RipResp{mm}')')
            title('Rip Proj')
            caxis([-2 2])
            
            subplot(4,4,8)
            imagesc(tps_rip,1:size(strength_temp,2),nanzscore(StrInfo.RipResp{mm}')')
            title('Rip ReStr')
            caxis([-2 2])
            
            PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples_Sf)-1*1e4,Range(Ripples_Sf)-0.6*1e4),0.1*1e4)-StimEpochToRemove)-PostRipples;
            AllRip = Data(Restrict(Q,PreRipples));
            
            clear varexpl varexpl_CV
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(AllRip,0);
            
            RemovRipEpoc = intervalSet(0,max(Range(Q))) - PreRipples;
            
            % Position
            for ep_pos = 1:3
                Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),BinSize*1e4);
                
                strength_temp = ReactivationStrength_SB(nanzscore(Data(Q)),templates);
                
                clear proj_temp
                for e =  1: size(eigenvectors,2)
                    proj_temp(:,e) = nanzscore(Data(Q))*eigenvectors(:,e);
                end
                
                for comp = 1:size(strength_temp,2)
                    strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                    proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                    pos_tsd = LinPos{mm}.(EpoName{ep_pos});
                    
                    if ep_pos==2
                        strength_temp_tsd = Restrict(strength_temp_tsd,RemovRipEpoc);
                        proj_temp_tsd = Restrict(proj_temp_tsd,RemovRipEpoc);
                        pos_tsd = Restrict(pos_tsd,RemovRipEpoc);
                    end
                    
                    for l = 1:8
                        LitEpo = thresholdIntervals(pos_tsd,(l-1)*0.125,'Direction','Above');
                        LitEpo = and(LitEpo,thresholdIntervals(pos_tsd,(l)*0.125,'Direction','Below'));
                        StrInfoPre.StrPos{mm}(ep_pos,comp,l) = nanmean(Data(Restrict(strength_temp_tsd,LitEpo)));
                        ProjInfoPre.StrPos{mm}(ep_pos,comp,l) = nanmean(Data(Restrict(proj_temp_tsd,LitEpo)));
                        
                    end
                    
                    [R,P] = corrcoef(Data(strength_temp_tsd),Data(Restrict(pos_tsd,Range(strength_temp_tsd))));
                    StrInfoPre.CorrPos{mm}(ep_pos,comp) = (R(1,2));
                    StrInfoPre.CorrPos_Sig{mm}(ep_pos,comp) = (P(1,2));
                    
                    [R,P] = corrcoef(Data(proj_temp_tsd),Data(Restrict(pos_tsd,Range(proj_temp_tsd))));
                    ProjInfoPre.CorrPos{mm}(ep_pos,comp) = (R(1,2));
                    ProjInfoPre.CorrPos_Sig{mm}(ep_pos,comp) = (P(1,2));
                end
            end
            
            % Stimulation
            Evts = Start(StimEpoch{mm}.Cond,'s');
            
            Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
            strength_temp = ReactivationStrength_SB(nanzscore(Data(Q)),templates);
            
            clear proj_temp
            for e =  1: size(eigenvectors,2)
                proj_temp(:,e) = nanzscore(Data(Q))*eigenvectors(:,e);
            end
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                pos_tsd = LinPos{mm}.(EpoName{ep_pos});
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,5000,0,0);
                StrInfoPre.StimResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,5000,0,0);
                ProjInfoPre.StimResp{mm}(comp,:) = M(:,2);
                
            end
            Fr_tsd = tsd(Range(Q),nanmean(Data(Q)')');
            [M,T] = PlotRipRaw(Fr_tsd,Evts,5000,0,0);
%             ProjInfoPre.StimResp{mm}(:,M(:,2)<0.1) = NaN;
%             StrInfoPre.StimResp{mm}(:,M(:,2)<0.1) = NaN;
            
            % Freezing
            Evts = Start(FreezeEpoch{mm}.Cond,'s');
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,5000,0,0);
                StrInfoPre.FreezeResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,5000,0,0);
                ProjInfoPre.FreezeResp{mm}(comp,:) = M(:,2);
            end
            
            % Ripples
            Ep =  FreezeEpoch{mm}.Cond - or(NoiseEpoch{mm}.Cond,StimEpochToRemove);
            Evts = Range(Restrict(Ripples.Cond{mm},Ep),'s');
            
            for comp = 1:size(strength_temp,2)
                strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
                
                [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
                StrInfoPre.RipResp{mm}(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
                ProjInfoPre.RipResp{mm}(comp,:) = M(:,2);
            end
            
            
            subplot(4,4,1+8)
            PlotErrorBarN_KJ(abs(ProjInfoPre.CorrPos{mm}'),'newfig',0)
            set(gca,'XTick',1:3,'XTickLabel',EpoName)
            ylabel('Proj')
            title('Spat corr')
            
            subplot(4,4,2+8)
            PlotErrorBarN_KJ(abs(StrInfoPre.CorrPos{mm}'),'newfig',0)
            set(gca,'XTick',1:3,'XTickLabel',EpoName)
            ylabel('React str')
            title('Spat corr')
            
            subplot(4,4,3+8)
            imagesc(tps_stim,1:size(strength_temp,2),nanzscore(ProjInfoPre.StimResp{mm}')')
            title('Stim Proj')
            
            
            subplot(4,4,4+8)
            imagesc(tps_stim,1:size(strength_temp,2),nanzscore(StrInfoPre.StimResp{mm}')')
            title('Stim ReSt')
            caxis([-2 4])
            
            subplot(4,4,5+8)
            imagesc(tps_fz,1:size(strength_temp,2),nanzscore(ProjInfoPre.FreezeResp{mm}')')
            title('Fz ReSt')
            caxis([-2 2])
            
            subplot(4,4,6+8)
            imagesc(tps_fz,1:size(strength_temp,2),nanzscore(StrInfoPre.FreezeResp{mm}')')
            title('Fz Proj')
            caxis([-2 2])
            
            subplot(4,4,7+8)
            imagesc(tps_rip,1:size(strength_temp,2),nanzscore(ProjInfoPre.RipResp{mm}')')
            title('Rip Proj')
            caxis([-2 2])
            
            subplot(4,4,8+8)
            imagesc(tps_rip,1:size(strength_temp,2),nanzscore(StrInfoPre.RipResp{mm}')')
            title('Rip ReStr')
            caxis([-2 2])
            
            saveas(fig.Number,[SaveFig 'Timebin' num2str(timebin(tb)*10) filesep 'ProjectRipplesPrePost',RipEpoch{rr},'_',num2str(mm),'.png'])
        end
        save([SaveFig 'Timebin' num2str(timebin(tb)*10) filesep 'ProjectRipplesPrePost',RipEpoch{rr},'.mat'],...
            'ProjInfoPre','ProjInfo','StrInfoPre','StrInfo')
        
        fig = figure;
        subplot(311)
        AllStimProj = [];
        AllStimProjPre = [];
        for mm = 1:5
            AllStimProj = [AllStimProj;(ProjInfo.StimResp{mm})];
            AllStimProjPre = [AllStimProjPre;(ProjInfoPre.StimResp{mm})];
        end
        errorbar(tps_stim,nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
        hold on
        errorbar(tps_stim,nanmean(AllStimProj),stdError(AllStimProj),'r')
        title('Stim')
        
        subplot(212)
        AllStimProj = [];
        AllStimProjPre = [];
        for mm = 1:5
            AllStimProj = [AllStimProj;(ProjInfo.FreezeResp{mm})];
            AllStimProjPre = [AllStimProjPre;(ProjInfoPre.FreezeResp{mm})];
        end
        errorbar(tps_fz,nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
        hold on
        errorbar(tps_fz,nanmean(AllStimProj),stdError(AllStimProj),'r')
        title('Freezing')
        saveas(fig.Number,[SaveFig 'Timebin' num2str(timebin(tb)*10) filesep 'ProjectRipplesPrePostOverall',RipEpoch{rr},'.png'])
        
    end
end


%% other way around
figure
for rr = 1:length(RipEpoch)
    
    BinSize=0.1;
    clear RipRespP_Pre RipRespP_Post RipRespS_Post RipRespS_Pre
    for mm = 1:5
        Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        
        PostStim=intervalSet(Start(StimEpoch{mm}.Cond)+0.1*1e4,Start(StimEpoch{mm}.Cond)+1*1e4);
        StimData = (Data(Restrict(Q,PostStim)));
        
        clear varexpl varexpl_CV
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(StimData,1);
        
        
        Q = MakeQfromS(Spikes{mm}.(RipEpoch{rr}),BinSize*1e4);
        strength_temp = ReactivationStrength_SB(nanzscore(Data(Q)),templates);
        
        clear proj_temp
        for e =  1: size(eigenvectors,2)
            proj_temp(:,e) = (Data(Q))*eigenvectors(:,e);
        end
        
        % Ripples
        if rr == 1
            StimEpochToRemove = intervalSet(Start(StimEpoch{mm}.Cond),Start(StimEpoch{mm}.Cond)+0.2*1e4);
            Ripples_Sf = Restrict(Ripples.(RipEpoch{rr}){mm},thresholdIntervals(LinPos{mm}.Cond,0.6,'Direction','Above'));
        else
            Ripples_Sf = Ripples.(RipEpoch{rr}){mm};
        end
        
        Ripples_Sf = intervalSet(Range(Ripples_Sf),Range(Ripples_Sf)+0.1*1e4);
        Ripples_Sf = mergeCloseIntervals(Ripples_Sf,1*1e4);
        
        Evts = Range(Ripples_Sf,'s');
        %% By position
        if rr ==1
            AllSafe = thresholdIntervals(LinPos{mm}.Cond,0.6,'Direction','Above');
            RipplePer = thresholdIntervals(tsd(Range(Q),runmean(hist(Evts,Range(Q,'s')),floor(3/median(diff(Range(Q,'s')))))'),1e-3,'Direction','Above');
            RipplePer = mergeCloseIntervals(RipplePer,1*1e4);
            
            
            AllShk = thresholdIntervals(LinPos{mm}.Cond,0.4,'Direction','Below')-StimEpochToRemove;

            
        end

        
        for comp = 1:3
            strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
            proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
            
            [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
            RipRespS_Post{mm}(comp,:) = M(:,2);
            
            [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
            RipRespP_Post{mm}(comp,:) = M(:,2);
            
            SafeProj{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllSafe)));
            SafeProjNoRip{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllSafe-RipplePer)));
            SafeProjRip{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,and(AllSafe,RipplePer))));
            SlProj{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllShk)));


        end
        
        
        
        PreStim=intervalSet(Start(StimEpoch{mm}.Cond)-2*1e4,Start(StimEpoch{mm}.Cond)-1*1e4)-PostStim;
        StimData = (Data(Restrict(Q,PreStim)));
        
        clear varexpl varexpl_CV
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(StimData,0);
        
        
        Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
        strength_temp = ReactivationStrength_SB((Data(Q)),templates);
        
        clear proj_temp
        for e =  1: size(eigenvectors,2)
            proj_temp(:,e) = (Data(Q))*eigenvectors(:,e);
        end
        
        % Ripples
        
        for comp = 1:size(strength_temp,2)
            strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
            proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
            
            [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
            RipRespS_Pre{mm}(comp,:) = M(:,2);
            
            [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
            RipRespP_Pre{mm}(comp,:) = M(:,2);
        end
        
    end
    
    subplot(2,3,rr)
    AllStimProj = [];
    AllStimProjPre = [];
    for mm = 1:5
        AllStimProj = [AllStimProj;(RipRespP_Post{mm}')'];
        AllStimProjPre = [AllStimProjPre;(RipRespP_Pre{mm}')'];
    end
    errorbar(M(:,1),nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
    hold on
    errorbar(M(:,1),nanmean(AllStimProj),stdError(AllStimProj),'r')
    ylim([0 1.5])
    makepretty
xlabel('time to rip (s)')

        subplot(2,3,rr+3)
    AllStimProj = [];
    AllStimProjPre = [];
    for mm = 1:5
        AllStimProj = [AllStimProj;(RipRespS_Post{mm}')'];
        AllStimProjPre = [AllStimProjPre;(RipRespS_Pre{mm}')'];
    end
    errorbar(M(:,1),nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
    hold on
    errorbar(M(:,1),nanmean(AllStimProj),stdError(AllStimProj),'r')
    ylim([0 2.5])
xlabel('time to rip (s)')

end


AllSf = [];
AllSfNoRip = [];
AllSfRip = [];
AllSk = [];

for mm = 1:5
    AllSf = [AllSf,SafeProj{mm}];
    AllSfNoRip = [AllSfNoRip,SafeProjNoRip{mm}];
    AllSfRip = [AllSfRip,SafeProjRip{mm}];
    AllSk = [AllSk,SlProj{mm}];

end

%% Some plots
figure
for rr = 1:3
    load([SaveFig 'Timebin' num2str(timebin(tb)*10) filesep 'ProjectRipplesPrePost',RipEpoch{rr},'.mat'],...
        'ProjInfoPre','ProjInfo','StrInfoPre','StrInfo')
    
    subplot(2,3,rr)
    AllStimProj = [];
    AllStimProjPre = [];
    for mm = 1:5
        AllStimProj = [AllStimProj;(ProjInfo.StimResp{mm})];
        AllStimProjPre = [AllStimProjPre;(ProjInfoPre.StimResp{mm})];
    end
    shadedErrorBar([1:nanmean(AllStimProjPre)],nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
    hold on
    shadedErrorBar([1:nanmean(AllStimProjPre)],nanmean(AllStimProj),stdError(AllStimProj),'r')
    title('Stim')
    AllStimProjPre(:,100:105) = NaN;
    AllStimProj(:,100:105) = NaN;
    Vals{1} = nanmax(AllStimProjPre(:,100:120)');
    Vals{2} = nanmax(AllStimProj(:,100:120)');
    
    %     xlim([80 150])
    
    subplot(2,3,rr+3)
    AllStimProj = [];
    AllStimProjPre = [];
    for mm = 1:5
        AllStimProj = [AllStimProj;(StrInfo.StimResp{mm})];
        AllStimProjPre = [AllStimProjPre;(StrInfoPre.StimResp{mm})];
    end
    shadedErrorBar([1:nanmean(AllStimProjPre)],nanmean(AllStimProjPre),stdError(AllStimProjPre),'k')
    hold on
    shadedErrorBar([1:nanmean(AllStimProjPre)],nanmean(AllStimProj),stdError(AllStimProj),'r')
    title('Stim')
    AllStimProjPre(:,100:105) = NaN;
    AllStimProj(:,100:105) = NaN;
    Vals{1} = nanmax(AllStimProjPre(:,100:120)');
    Vals{2} = nanmax(AllStimProj(:,100:120)');
    
    
end