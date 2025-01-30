clear all
close all
exp='DeltaToneAll';

for mouse=[243 251 252 293 294]
    
    Dir=PathForExperimentsDeltaSleep2016('DeltaToneAll');
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    
    a=1;
    figure('color',[1 1 1])
    
    for i=1:length(Dir.path)
        DAY=(Dir.path{i});
        
        disp(' ')
        disp('******************************************************************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        disp('*******************************************************************************************************************')
        disp(' ')
        
        load SpikeData
        load newDeltaPFCx
            [Spk_NRT,NumNeuronsNRT]=GetSpikesFromStructure('NRT');
            NRT_Spk=PoolNeurons(Spk_NRT,NumNeuronsNRT);
            
            [Spk_Pfc,NumNeuronsPFC]=GetSpikesFromStructure('PFCx');
            PFC_Spk=PoolNeurons(Spk_Pfc,NumNeuronsPFC);
            
            [Spk_HPC,NumNeuronsHPC]=GetSpikesFromStructure('dHPC');
            HPC_Spk=PoolNeurons(Spk_HPC,NumNeuronsHPC);
            %<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

            [C_Delta_NRT,B_Delta]=CrossCorrGL(tDelta,Range(NRT_Spk),20,100); 
            D_SpkNRT_Delta(:,a)=C_Delta_NRT;
            
            
            [C_Delta_PFC,B_Delta]=CrossCorrGL(tDelta,Range(PFC_Spk),20,100); 
            D_SpkPFC_Delta(:,a)=C_Delta_PFC;
            
            smo=1;
            hold on, subplot(4,1,a) 
            hold on, plot(SmoothDec((B_Delta/1E3),smo),C_Delta_NRT,'b')
            hold on, plot(SmoothDec((B_Delta/1E3),smo),C_Delta_PFC,'r')
            hold on, title(['NRT neuron modulation around delta, mouse > #',num2str(mouse), ' _ day > n=',num2str(i)])
            hold on, xlabel(DAY(end-16:end))
            
            if ~isempty(Range(HPC_Spk))
                disp('GREAT ! neuron from dHPC')
                [C_Delta_HPC,B_Delta]=CrossCorrGL(tDelta,Range(HPC_Spk),20,100); 
                D_SpkHPC_Delta(:,a)=C_Delta_HPC;
                hold on, plot(SmoothDec((B_Delta/1E3),smo),C_Delta_HPC,'c')
            elseif isempty(Range(HPC_Spk))
                disp('no neuron from dHPC')
            end
            %<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
            
            a=a+1;
        
    end
    
    factor=10;
    if mouse==243
        factor=100;
    elseif mouse==251
        factor=1;
    end
    
    hold on, subplot(4,1,a)
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkPFC_Delta,2),smo),'r','linewidth',2)
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkPFC_Delta,2)+std(D_SpkPFC_Delta,0,2),smo),'r')
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkPFC_Delta,2)-std(D_SpkPFC_Delta,0,2),smo),'r')
    
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkNRT_Delta,2)*factor,smo),'b','linewidth',2)
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkNRT_Delta,2)*factor+std(D_SpkNRT_Delta,0,2)*factor,smo),'b')
    hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkNRT_Delta,2)*factor-std(D_SpkNRT_Delta,0,2)*factor,smo),'b')
    hold on, xlabel(['NRT neuron modulation around delta, mouse > #',num2str(mouse)])
    
    if ~isempty(Range(HPC_Spk))
        hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkHPC_Delta,2)*factor,smo),'c','linewidth',2)
        hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkHPC_Delta,2)*factor+std(D_SpkHPC_Delta,0,2)*factor,smo),'c')
        hold on, plot(B_Delta/1E3,SmoothDec(mean(D_SpkHPC_Delta,2)*factor-std(D_SpkHPC_Delta,0,2)*factor,smo),'c')
    elseif isempty(Range(HPC_Spk))
        disp('no neuron from dHPC')
    end
end

% clear SS
% SS{1}=NRT_Spk;
% SS=tsdArray(SS);
% Qs = MakeQfromS(SS,200);
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%             figure, [fh, rasterAx, histAx, matVal_PFCx_dMoCx] = ImagePETH(Qs, ts(tDelta(1:500)), -10000, +15000,'BinSize',500);
%             hold on, title(['NRT neuron modulation around delta in EARLY sleep, mouse #',num2str(mouse),')'])
%             figure, [fh, rasterAx, histAx, matVal_PFCx_dMoCx] = ImagePETH(Qs, ts(tDelta(end-500:end)), -10000, +15000,'BinSize',500);
%             hold on, title(['NRT neuron modulation around delta in LATE sleep, mouse #',num2str(mouse),')'])
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

