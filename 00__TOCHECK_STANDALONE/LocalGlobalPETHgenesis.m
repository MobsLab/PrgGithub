% LocalGlobalPETHgenesis:
% 
% if plo= 1 =>  LFP:matVal{i,j}
% if plo= 2 =>  Spk:matValSpk{i,j}
% i=> numero de la voie LFP/numero du neurone
% j=> associe a� chaque variante de son dans le protocole Local/Global/Omission
% 1: Local Standard - Global Standard A
% 2: Local Standard - Global Standard B
% 3: Local Deviant - Global Standard A
% 4: Local Deviant - Global Standard B
% 5: Local Deviant - Global Deviant A
% 6: Local Deviant - Global Deviant B
% 7: Omission AAAA (bloc Omission only)
% 8: Omission rare A (during classical bloc - occurence 10%)
% 9: Omission BBBB (bloc Omission only)
% 10: Omission rare A (during classical bloc - occurence 10%)




function [matVal,st,LocalGlobalAssignment]=LocalGlobalPETHgenesis(start,plo)

[LFP,st]=MMNfilegenesis(start);

disp(['    ----->  debut du protole au rang n�', num2str(start)]);


%% -----------------------   LFP   -----------------------------------------
if plo==1
    disp('    ----->  PETH generation for LFP');
    if start<9216;
        load LocalGlobalAssignment
    else
        load LocalGlobalAssignment2
    end
    for i=1:length(LFP);
        figure, [fh, rasterAx, histAx, matVal{i,1}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdA)), -1000, +13000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - channel LFP n�',num2str(i)]);close 
        figure, [fh, rasterAx, histAx, matVal{i,2}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdB)), -1000, +13000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,3}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,4}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,5}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,6}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,7}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobDvtA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,8}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobDvtB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,9}] = ImagePETH(LFP{i}, ts(sort(OmiAAAA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,10}] = ImagePETH(LFP{i}, ts(sort(OmissionRareA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,11}] = ImagePETH(LFP{i}, ts(sort(OmiBBBB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
        figure, [fh, rasterAx, histAx, matVal{i,12}] = ImagePETH(LFP{i}, ts(sort(OmissionRareB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n�',num2str(i)]);close
    end
end



%% ----------------------- Spikes ------------------------------------------

if plo==2;
    disp('    ----->  PETH generation for Spike');
    load SpikeData;
    
    if start<9200;
        load LocalGlobalAssignment
    else
        load LocalGlobalAssignment2
    end
    
    for i=1:length(S);
        figure, [fh, sq{i,1}, sweeps{i,1}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalStdGlobStdA)), -1000, +13000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - Neuron',num2str(i)]);close 
        figure, [fh, sq{i,2}, sweeps{i,2}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalStdGlobStdB)), -1000, +13000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,3}, sweeps{i,3}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalDvtGlobStdA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,4}, sweeps{i,4}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalDvtGlobStdB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,5}, sweeps{i,5}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalDvtGlobDvtA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,6}, sweeps{i,6}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalDvtGlobDvtB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,7}, sweeps{i,7}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalStdGlobDvtA)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,8}, sweeps{i,8}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(LocalStdGlobDvtB)), -1000, +13000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,9}, sweeps{i,9}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(OmiAAAA)),          -1000, +13000,'BinSize',50);title(['Block OmiAAAA   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,10}, sweeps{i,10}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(OmissionRareA)),   -1000, +13000,'BinSize',50);title(['Block OmissionRareA   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,11}, sweeps{i,11}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(OmiBBBB)),         -1000, +13000,'BinSize',50);title(['Block OmiBBBB   - Neuron',num2str(i)]);close
        figure, [fh, sq{i,12}, sweeps{i,12}, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(OmissionRareB)),   -1000, +13000,'BinSize',50);title(['Block OmissionRareB   - Neuron',num2str(i)]);close
    end
end

% ToneA= [LocalStdGlobStdA;LocalStdGlobDvtA;OmiAAAA];
% ToneB= [LocalStdGlobStdB;LocalStdGlobDvtB;OmiBBBB];
% for i=Spike1:Spike2;
%     figure, [fh, sq, sweeps, rasterAx, histAx] = RasterPETH(S{i}, ts(st), -1000, +11000,'BinSize',50);title(['Response to all tone - channel LFP n�',num2str(i)]);
%     figure, [fh, sq, sweeps, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(ToneA)), -1000, +11000,'BinSize',50);title(['Response to tone A  - channel LFP n�',num2str(i)]);
%     figure, [fh, sq, sweeps, rasterAx, histAx] = RasterPETH(S{i}, ts(sort(ToneB)), -1000, +11000,'BinSize',50);title(['Response to tone B  - channel LFP n�',num2str(i)]);
% end

%% ----------------------------------------- Saving ------------------------------------------
if start<9200;
    try
        save matVal1 matVal;
    end
    try
        save SQ1 sq
        save SWEEPS1 sweeps
    end
end
if start>9200;
    try
        save matVal2 matVal;
    end
    try
        save SQ2 sq
        save SWEEPS2 sweeps
    end
end

end
