clear all
close all
Dir_All.All{1} = PathForExperimentFEAR('FearCBNov15','fear');
Dir_All.Ext{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','EXT-24h-envC');
Dir_All.Hab{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','HAB-grille');

Dir_All.All{2} = PathForExperimentFEAR('ManipFeb15Bulbectomie','fear');
Dir_All.Ext{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','EXT-24h-envC');
Dir_All.Hab{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','HAB-envC');

% these mice extinguished in the plethysmograph so we're using 48hrs
Dir_All.All{3} = PathForExperimentFEAR('ManipDec14Bulbectomie','fear');
Dir_All.Ext{3} = RestrictPathForExperiment(Dir_All.All{3},'Session','EXT-48h-envB')
Dir_All.Hab{3} = RestrictPathForExperiment(Dir_All.All{3},'Session','HAB-envA')

TimePostCS = 60; % freezign will be calculated during the CS and then for this amount of time after
Cols = {[0.4 0.4 0.4],[1 0.4 0.4],[0.8 0.6 0.6]};
SessionTypes = {'Hab','Ext'};

%% Freezing durations
for exp = [4]
    
    for ss = 1:2
        clear FzPerc CSEpoch
        if exp ==5
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){1},Dir_All.(SessionTypes{ss}){2});
            Dir = MergePathForExperiment(Dir,Dir_All.(SessionTypes{ss}){3});
        elseif exp ==4
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){3},Dir_All.(SessionTypes{ss}){2});
        else
            Dir = Dir_All.(SessionTypes{ss}){exp};
        end
        
        for mm=1:length(Dir.path)
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
                        TotEpoch = intervalSet(0,800*1e4);
                        FreezeEpoch = and(FreezeEpoch,TotEpoch);
            Fz.(SessionTypes{ss}){mm} = Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
            NoFz.(SessionTypes{ss}){mm} = Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
        end
    end
    
    % Get the identity of the mice
    a=strfind(Dir.group,'OBX');
    CTRL=cellfun('isempty',a);
    
    FzX = [0:1:60];
    FzY = [0:1:150];
    
    % Ctrl
    clear AllCtrlFz AllCtrlNoFz  AllBBXFz AllBBXNoFz MeanCtrlFz MeanCtrlNoFz DurActEp_CHR2 DurFzEp_CHR2
    
    IdMiceFz=find(CTRL==1);
    for k = 1:length(IdMiceFz)
        DurFzEp_GFP(k,:) = nanmean(Fz.Ext{IdMiceFz(k)});
        DurActEp_GFP(k,:) = nanmean(NoFz.Ext{IdMiceFz(k)});
        PercFz_GFP(k,:) = nansum(Fz.Ext{IdMiceFz(k)})./(nansum(Fz.Ext{IdMiceFz(k)})+nansum(NoFz.Ext{IdMiceFz(k)}))
        FreqInit_GFP(k,:) = length(Fz.Ext{IdMiceFz(k)})./(nansum(Fz.Ext{IdMiceFz(k)})+nansum(NoFz.Ext{IdMiceFz(k)}))
        
        
    end
    
    IdMiceFz=find(CTRL==0);
    for k = 1:length(IdMiceFz)
        DurFzEp_CHR2(k,:) = nanmean(Fz.Ext{IdMiceFz(k)});
        DurActEp_CHR2(k,:) = nanmean(NoFz.Ext{IdMiceFz(k)});
        FreqInit_CHR2(k,:) = length(Fz.Ext{IdMiceFz(k)})./(nansum(Fz.Ext{IdMiceFz(k)})+nansum(NoFz.Ext{IdMiceFz(k)}))
        PercFz_CHR2(k,:) = nansum(Fz.Ext{IdMiceFz(k)})./(nansum(Fz.Ext{IdMiceFz(k)})+nansum(NoFz.Ext{IdMiceFz(k)}))
    end
    
    
end


StepSizes = [0.5,1,1.5,2,3,4];
l=1;
for st = 3%1:length(StepSizes)
    stepsize = StepSizes(st);
    
    load([dropbox '/Mobs_member/SophieBagur/Figures/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'.mat'])
    cols = {'k','b','r'}
    
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
%             ErrMat(isinf(ErrMat))=NaN;
%             imagesc(log(ErrMat))
%             pause
            Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row,col)).^2;
            Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row,col)).^2;
            
        end
    
    
        for k=1:size(DurFzEp_CHR2,1)
            ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
            Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row,col)).^2;
%             ErrMat(isinf(ErrMat))=NaN;
%             imagesc(log(ErrMat))
%             pause
            Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row,col)).^2;
            
        
    end
    
end


fig = figure;
subplot(211)
line([0 0.6],[0 0.6],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.6]), ylim([0 0.6]), hold on
xlabel('PercFz - model'), ylabel('PercFz - data')
subplot(212)
line([0 0.15]*800,[0 0.15]*800,'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.07]*800),ylim([0 0.07]*800), hold on
xlabel('Num Fz bouts - model'), ylabel('Num Fz bouts - data')
num=1;
for l=1
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,1,1)
        plot(PercFz(row,col),PercFz_GFP(k,l),'.','color',[0.4 0.4 0.4],'MarkerSize',20),hold on
        Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row,col)).^2;
        X1(num) = PercFz(row,col);
        Y1(num) = PercFz_GFP(k,l);
        
        subplot(2,1,2)
        plot(FreqInit(row,col)*800,FreqInit_GFP(k,l)*800,'.','color',[0.8 0.4 0.4],'MarkerSize',20),hold on
        Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row,col)).^2;
        FreqInit_GFP_model(k,l) = FreqInit(row,col);
           X2(num) = FreqInit(row,col);
        Y2(num) = FreqInit_GFP(k,l);
            num=num+1;

    end
end

for l =1
    for k=1:size(DurFzEp_CHR2,1)
        ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,1,1)
        plot(PercFz(row,col),PercFz_CHR2(k,l),'.','color',[0.8 0.4 0.4],'MarkerSize',20),hold on
        Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row,col)).^2;
         X1(num) = PercFz(row,col);
        Y1(num) = PercFz_CHR2(k,l);
        
        subplot(2,1,2)
        plot(FreqInit(row,col)*800,FreqInit_CHR2(k,l)*800,'.','color',[0.4 0.4 0.4],'MarkerSize',20),hold on
        Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row,col)).^2;
        FreqInit_CHR2_model(k,l) = FreqInit(row,col);
           X2(num) = FreqInit(row,col);
        Y2(num) = FreqInit_CHR2(k,l);
            num=num+1;

    end
end
