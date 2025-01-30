edirt Corclear all
Dir = PathForExperimentFEAR('Fear-electrophy');
LongLim  = [6,14,22];
LongLimEnd  = [14,22,40];

for lg = 1:length(LongLim)
    bi=2000;
    binsize=5*(LongLimEnd(lg)+LongLim(lg))/2;
    
    MiceDone = {};
    
    mousenum=0;
    for mm=1:length(Dir.path)
        
        if strcmp(Dir. group{mm},'CTRL') %%&& sum(strcmp(MiceDone,Dir.name{mm}))==0
            
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch FreezeAccEpoch
            
            if exist('SpikeData.mat')>0 
                disp(Dir.path{mm})

                clear S W TT cellnames UnitID AllParamsNew WFInfo BestElec figid
                
                load('SpikeData.mat')
                disp(['size S: ' num2str(size(S))])
                disp(['size TT: ' num2str(size(TT))])
                
                
                if (size(S,2)) ~= (size(TT,2))
                    SetCurrentSession
                    global DATA
                    tetrodeChannels=DATA.spikeGroups.groups;
                    
                    RemoveMUA = 0;
                    a=1;
                    clear TT cellnames
                    for i=1:max(s(:,2))
                        UnitNums=[unique(s(s(:,2)==i,3))]
                        if RemoveMUA
                            UnitNums(UnitNums<2)=[];
                        else
                            UnitNums(UnitNums<1)=[];
                        end
                        
                        for j=1:length(UnitNums)
                            try
                                if length(find(s(:,2)==i&s(:,3)==UnitNums(j)))>1
                                    TT{a}=[i,UnitNums(j)];
                                    cellnames{a}=['TT',num2str(i),'c',num2str(UnitNums(j))];
                                    disp(['Cluster : ',cellnames{a},' > done'])
                                    a=a+1;
                                end
                            end
                        end
                    end
                    
                    save('SpikeData.mat','TT','cellnames','tetrodeChannels','-append')
                    disp('corrected')
                    load('SpikeData.mat')
                    disp(['size S: ' num2str(size(S))])
                    disp(['size TT: ' num2str(size(TT))])
                end
                
                if exist('MeanWaveform.mat')>0
                    load('MeanWaveform.mat')
                    disp(['size W: ' num2str(size(W))])
                else
                    disp('no wf')
                    load('Waveforms.mat')
                    save('MeanWaveform.mat','W')
                    disp('corrected')
                    disp(['size W: ' num2str(size(W))])

                end
                
                if num2str(size(S,2)) ~= num2str(size(W,2))
                    keyboard
                end
                
                for i=1:length(S)
                    if TT{i}(2)==1
                        W{i} = W{i}*NaN;
                    end
                end
                
                [UnitID,AllParamsNew,WFInfo,BestElec,figid] = MakeData_ClassifySpikeWaveforms(W,'/home/vador/Dropbox/Kteam',1,'recompute',1);
                set(figid,'Position',get(0,'ScreenSize'))
                saveas(figid,'NeuronClassification.fig')
                close(figid)
                InfoNeurons = MakeData_NeuronsInfo;
                disp(InfoNeurons)
                
                
                
            end
        end
    end
end

