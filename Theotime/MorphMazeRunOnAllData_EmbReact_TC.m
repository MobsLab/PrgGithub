
clear all

cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
% load('Sess.mat')
Mouse_names={'M1199'}; mouse=1;
load('behavResources.mat', 'SessionEpoch', 'Xtsd', 'Ytsd')
SessionNames = fieldnames(SessionEpoch);
OutPutXtsd = tsd([],[]);
OutPutYtsd = tsd([],[]);
OutPutLinearized = tsd([], []);

tps = 0;
for i = 1:length(SessionNames)
    clear Behav Params Results TTLInfo AlignedXtsd AlignedYtsd ZoneEpochAligned
    clear Vtsd Xtsd Ytsd Imdifftsd FreezeEpoch FreezeAccEpoch MovAcctsd
    MazeCoordDone = 0;
    Params = load(['behavResources-' num2str(i, '%02d') '.mat']);
    if not(MazeCoordDone)
        disp('Need to calculate')

        if isfield(Params,'Ratio_IMAonREAL')
            Ratio_IMAonREAL = Params.Ratio_IMAonREAL;
        else
            Ratio_IMAonREAL = 1./Params.pixratio;
            Params.Ratio_IMAonREAL = Ratio_IMAonREAL;
        end
        if strfind(lower(SessionNames{i}), lower('Sleep'))
            [Params.AlignedXtsd,Params.AlignedYtsd,Params.XYOutput] = MorphCageToSingleShape_Align(Params.Xtsd,Params.Ytsd);
            Params.LinearDist = tsd([], []);

        end
    else
        if ~isfield(Params, 'CleanXtsd')
            clean = 0;
            [Params.AlignedXtsd,Params.AlignedYtsd,Params.ZoneEpochAligned,Params.XYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (Params.Xtsd,Params.Ytsd, Params.Zone{1}, Params.ref, Ratio_IMAonREAL);
            Params.LinearDist = LinearizeMaze(Params, 1);
        else
            clean = 1;
            [Params.CleanAlignedXtsd,Params.CleanAlignedYtsd,Params.CleanZoneEpochAligned,Params.CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (Params.CleanXtsd,Params.CleanYtsd, Params.Zone{1}, Params.ref, Ratio_IMAonREAL);
            Params.CleanLinearDist = LinearizeMaze(Params, 1);
        end
    end


    if isfield(Params,'CleanAlignedXtsd')
        tpsmax = max(Range(Params.CleanAlignedXtsd));
        TotEpoch = intervalSet(0,tpsmax);
        rg = Range(Restrict(Params.CleanAlignedXtsd,TotEpoch));
        dt = Data(Restrict(Params.CleanAlignedXtsd,TotEpoch));
        dt2 = Data(Restrict(Params.CleanAlignedYtsd,TotEpoch));
        dt4 = Data(Restrict(Params.CleanLinearDist, TotEpoch));
        OutPutXtsd = tsd([Range(OutPutXtsd);rg+tps],[Data(OutPutXtsd);dt]);
        OutPutYtsd = tsd([Range(OutPutYtsd);rg+tps],[Data(OutPutYtsd);[dt2]]);
        OutPutLinearized = tsd([Range(OutPutLinearized);rg+tps],[Data(OutPutLinearized);dt4]);

    elseif isfield(Params,'AlignedXtsd')
            tpsmax = max(Range(Params.AlignedXtsd));
        TotEpoch = intervalSet(0,tpsmax);
        rg = Range(Restrict(Params.AlignedXtsd,TotEpoch));
        dt = Data(Restrict(Params.AlignedXtsd,TotEpoch));
        dt2 = Data(Restrict(Params.AlignedYtsd,TotEpoch));
        dt4 = Data(Restrict(Params.LinearDist, TotEpoch));
        OutPutXtsd = tsd([Range(OutPutXtsd);rg+tps],[Data(OutPutXtsd);dt]);
        OutPutYtsd = tsd([Range(OutPutYtsd);rg+tps],[Data(OutPutYtsd);[dt2]]);
        OutPutLinearized = tsd([Range(OutPutLinearized);rg+tps],[Data(OutPutLinearized);dt4]);
    else 
        error('achtung')
    end
    tps=tps + tpsmax;

keyboard

%     save(['behavResources-' num2str(i, '%02d') '.mat'],'-struct', 'Params')


% if clean
%     save(['behavResources-' num2str(i, '%02d') '.mat'],'-struct', 'Params')
% else
%     save(['behavResources-' num2str(i, '%02d') '.mat'],'Params')
% end
clear Behav Params
end
clear XYOutput