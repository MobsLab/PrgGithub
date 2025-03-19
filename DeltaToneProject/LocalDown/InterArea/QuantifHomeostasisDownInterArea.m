%%QuantifHomeostasisDownInterArea
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     ScriptLocalDeltaWavesParietal QuantifHomeostasisDownInterAreaPlotAll
%    


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    if ~strcmpi(Dir.name{p},'Mouse243') && ~strcmpi(Dir.name{p},'Mouse244')
        continue
    end
        
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p local_res
    
    local_res.path{p}   = Dir.path{p};
    local_res.manipe{p} = Dir.manipe{p};
    local_res.name{p}   = Dir.name{p};
    local_res.date{p}   = Dir.date{p};
    local_res.hemisphere{p}  = Dir.hemisphere{p};
    local_res.tetrodes{p} = Dir.tetrodes{p};
    
    %params
    windowsize_density = 60e4; %60s  

    
    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [N1, N2, N3, ~, ~] = GetSubstages;


    %% Deltas

    %PaCx
    if strcmpi(Dir.name{p},'Mouse243')
        load('ChannelsToAnalyse/PaCx_deep.mat')
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channel)])
        eval(['PaDeltas = delta_ch_' num2str(channel) ';'])
    else
        load('DeltaWaves.mat', 'deltas_PaCx')
        PaDeltas = deltas_PaCx;
    end
    
    %MoCx
    load('DeltaWaves.mat', 'deltas_MoCx')
    MoDeltas = deltas_MoCx;


    %PFCx Diff
    load('DeltaWaves.mat', 'deltas_PFCx')
    PFCxDeltas = deltas_PFCx;
    
    
    %% Inter et Intra
    
    %PaCx et PFCx
    [Inter_PfcPaCxRaw, ~, ~, id1,id2] = GetIntersectionsEpochs(PFCxDeltas, PaDeltas);
    Intra_PfcNoPa = subset(PFCxDeltas, setdiff(1:length(Start(PFCxDeltas)),id1)');
    Intra_PaCxNoPFC = subset(PaDeltas, setdiff(1:length(Start(PaDeltas)),id2)');
    %remove MoCx
    [~, ~, ~, id1,~] = GetIntersectionsEpochs(Intra_PfcNoPa, MoDeltas);
    Intra_PFC = subset(Intra_PfcNoPa, setdiff(1:length(Start(Intra_PfcNoPa)),id1)');
    
    %MoCx et PFCx
    [Inter_PfcMoCxRaw, ~, ~, id1,id2] = GetIntersectionsEpochs(PFCxDeltas, MoDeltas);
    Intra_PfcNoMo = subset(PFCxDeltas, setdiff(1:length(Start(PFCxDeltas)),id1)');
    Intra_MoCxNoPFC = subset(MoDeltas, setdiff(1:length(Start(MoDeltas)),id2)');

    %Inter Pa-Mo, Intra PaCx et Intra MoCx
    [Inter_MoPa, ~, ~, idMo,idPa] = GetIntersectionsEpochs(Intra_MoCxNoPFC, Intra_PaCxNoPFC);
    Intra_MoCx = subset(Intra_MoCxNoPFC, setdiff(1:length(Start(Intra_MoCxNoPFC)),idMo)');
    Intra_PaCx = subset(Intra_PaCxNoPFC, setdiff(1:length(Start(Intra_PaCxNoPFC)),idPa)');
    
    %Inter ALL, Inter PFC-Mo et Inter PFC-Pa
    [Inter_All, ~, ~, id1,id2] = GetIntersectionsEpochs(Inter_PfcPaCxRaw, Inter_PfcMoCxRaw);
    Inter_PfcPa = subset(Inter_PfcPaCxRaw, setdiff(1:length(Start(Inter_PfcPaCxRaw)),id1)');
    Inter_PfcMo = subset(Inter_PfcMoCxRaw, setdiff(1:length(Start(Inter_PfcMoCxRaw)),id2)');
    
    %Intra gathered
    Intras = or(or(Intra_PFC,Intra_PaCx),Intra_MoCx);
    
    %nb
    local_res.all_deltas.nb{p}  = length(Start(PFCxDeltas)) + length(Start(Inter_MoPa)) + length(Start(Intra_PaCx)) + length(Start(Intra_MoCx));
    local_res.inter_all.nb{p} = length(Start(Inter_All));
    local_res.intras.nb{p} = length(Start(Intras));

    local_res.pfc_pa.nb{p} = length(Start(Inter_PfcPa));
    local_res.pfc_mo.nb{p} = length(Start(Inter_PfcMo));
    local_res.mo_pa.nb{p} = length(Start(Inter_MoPa));
    
    local_res.intra_pfc.nb{p} = length(Start(Intra_PFC));
    local_res.intra_pa.nb{p} = length(Start(Intra_PaCx));
    local_res.intra_mo.nb{p} = length(Start(Intra_MoCx));
    
    
    local_res.all_pfc.nb{p} = length(Start(PFCxDeltas));
    local_res.all_pa.nb{p}  = length(Start(PaDeltas));
    local_res.all_mo.nb{p}  = length(Start(MoDeltas));    
    
    
    %% Substages
    
    %Restrict to substages
    Substages = {N1,N2,N3};
    for s=1:length(Substages)
        %all
        tDeltas = ts(sort([Start(PFCxDeltas) ; Start(Inter_MoPa) ; Start(Intra_PaCx) ; Start(Intra_MoCx)]));
        local_res.all_deltas.substages{p}(s) = length(Restrict(tDeltas,Substages{s}));
        
        tDeltas = ts(Start(PFCxDeltas));
        local_res.all_pfc.substages{p}(s) = length(Restrict(tDeltas,Substages{s}));
        tDeltas = ts(Start(PaDeltas));
        local_res.all_pa.substages{p}(s)  = length(Restrict(tDeltas,Substages{s}));
        tDeltas = ts(Start(MoDeltas));
        local_res.all_mo.substages{p}(s)  = length(Restrict(tDeltas,Substages{s}));
        
        
        %inter all
        tDeltas = ts(Start(Inter_All));
        local_res.inter_all.substages{p}(s) = length(Restrict(tDeltas,Substages{s}));
        
        %intra PFCx
        tDeltas = ts(Start(Intra_PFC));        
        local_res.intra_pfc.substages{p}(s) = length(Restrict(tDeltas,Substages{s}));
        tDeltas = ts(Start(Intra_PaCx));        
        local_res.intra_pa.substages{p}(s)  = length(Restrict(tDeltas,Substages{s}));
        tDeltas = ts(Start(Intra_MoCx));        
        local_res.intra_mo.substages{p}(s)  = length(Restrict(tDeltas,Substages{s}));
        tDeltas = ts(Start(Intras));        
        local_res.intras.substages{p}(s)    = length(Restrict(tDeltas,Substages{s}));
        
        
    end
    
    
    
    %% Homeostasie Absolut
    
    %Inter ALL
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_All, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.inter_all.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_All)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.inter_all.absolut.Dstat{p} = Dstat;
    
    %Inter Area
    %PFC-Pa
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_PfcPa, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.pfc_pa.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_PfcPa)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.pfc_pa.absolut.Dstat{p} = Dstat;
    %PFC-Mo
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_PfcMo, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.pfc_mo.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_PfcMo)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.pfc_mo.absolut.Dstat{p} = Dstat;
    %Mo-Pa
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_MoPa, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.mo_pa.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_MoPa)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.mo_pa.absolut.Dstat{p} = Dstat;
    
    %Intra
    %PFC
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_PFC, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_pfc.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_PFC)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_pfc.absolut.Dstat{p} = Dstat;
    %PaCx
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_PaCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_pa.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_PaCx)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_pa.absolut.Dstat{p} = Dstat;
    %MoCx
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_MoCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_mo.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_MoCx)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intra_mo.absolut.Dstat{p} = Dstat;
    
    %All intras
    [~, ~, Hstat] = DensityOccupation_KJ(Intras, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intras.absolut.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intras)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    local_res.intras.absolut.Dstat{p} = Dstat;
    
    
    %% Homeostasie rescaled
    
    %Inter ALL
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_All, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.inter_all.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_All)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.inter_all.rescaled.Dstat{p} = Dstat;
    
    
    %Inter Area
    %PFC-Pa
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_PfcPa, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.pfc_pa.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_PfcPa)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.pfc_pa.rescaled.Dstat{p} = Dstat;
    %PFC-Mo
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_PfcMo, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.pfc_mo.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_PfcMo)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.pfc_mo.rescaled.Dstat{p} = Dstat;
    %Mo-Pa
    [~, ~, Hstat] = DensityOccupation_KJ(Inter_MoPa, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.mo_pa.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Inter_MoPa)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.mo_pa.rescaled.Dstat{p} = Dstat;
    
    %Intra
    %PFC
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_PFC, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_pfc.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_PFC)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_pfc.rescaled.Dstat{p} = Dstat;
    %PaCx
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_PaCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_pa.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_PaCx)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_pa.rescaled.Dstat{p} = Dstat;
    %MoCx
    [~, ~, Hstat] = DensityOccupation_KJ(Intra_MoCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_mo.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intra_MoCx)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intra_mo.rescaled.Dstat{p} = Dstat;
    
    %All intras
    [~, ~, Hstat] = DensityOccupation_KJ(Intras, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intras.rescaled.Hstat{p} = Hstat;
    [~, ~, Dstat] = DensityCurves_KJ(ts(Start(Intras)), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    local_res.intras.rescaled.Dstat{p} = Dstat;

end


%saving data
cd(FolderDeltaDataKJ)
save QuantifHomeostasisDownInterArea.mat local_res



