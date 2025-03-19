
GetEmbReactMiceFolderList_BM

chan = Get_chan_numb_BM(CondSess.M41350{1} , 'ThetaREM');
LFP = ConcatenateDataFromFolders_SB(CondSess.M41350,'lfp','channumber',chan);
VHC_Stim_Epoch = ConcatenateDataFromFolders_SB(CondSess.M41350,'epoch','epochname','vhc_stim');
InstPhase = ConcatenateDataFromFolders_SB(CondSess.M41350,'instphase','suffix_instphase','H');
    
Hil = hilbert(Data(LFP));
HilPhase = imag(Hil);


[M,T] = PlotRipRaw(InstPhase, Start(VHC_Stim_Epoch)/1e4, 500);
[M2,T2] = PlotRipRaw(LFP, Start(VHC_Stim_Epoch)/1e4, 500);
[~,b] = sort(T(:,1));
T_sort = T(b,:);

figure
imagesc(T)

for i=1:size(T,2)
   
    clear X Y
    [X,Y] = hist(T(:,i),100);
    Phase(i,:) = X;
    
end


figure
imagesc(Phase')
caxis([0 20])

figure
plot(X,Y)


figure
plot(HilPhase)











FilTheta = FilterLFP(LFP,[4 12],1024); % filtering

Range_phase = linspace(0,max(Range(FilTheta)),length(phase))';
phase_tsd = tsd(Range_phase , phase);
phase_tsd_corr = Restrict(phase_tsd , FilTheta);

[M,T] = PlotRipRaw(phase_tsd, Start(VHC_Stim_Epoch)/1e4, 500);


for i=1:size(T,2)
   
    clear X Y
    [X,Y] = hist(T(:,i),100);
    Phase(i,:) = X;
    
end

figure
imagesc(Phase')
caxis([0 20])









