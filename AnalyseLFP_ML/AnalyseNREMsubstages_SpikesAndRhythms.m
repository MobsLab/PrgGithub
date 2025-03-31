%AnalyseNREMsubstages_SpikesAndRhythms
%
% RasterPETH of PFCx neurons at moments od Delta/Spindles/Ripples
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NREMsubSpikesAndRhythm/';
savFig=0; clear Val1 Dir
colori=[0.5 0.2 0.1; 0.1 0.7 0; 0.7 0.2 0.9;1 0.7 0.6 ; 1 0 1 ];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<

Dir=PathForExperimentsDeltaSleepNew('BASAL');
Dir=RestrictPathForExperiment(Dir,'nMice',[243 244 251 252]);


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

try
    load([res,'/AnalySubStages-SpikesAndRhythms.mat'])
    Val1; Dir;
catch
    
    Val1={}; Val2={}; Val3={}; 
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        try
            %%%%%%%%%%%%%%%%%%%%%%%% GET RHYTHMS %%%%%%%%%%%%%%%%%%%%%%%%%%
            % get delta
            clear tDelta Dpfc
            load('AllDeltaPFCx.mat','tDelta');
            Dpfc=ts(tDelta);
            
            % get ripples
            clear dHPCrip chHPC rip
            load('AllRipplesdHPC25.mat','dHPCrip','chHPC');
            rip=ts(dHPCrip(:,2)*1E4);
            
            % get spindles sup          
            clear spiHsup spiLsup
            [SpiTot,SpiHigh,SpiLow]=GetSpindlesML('PFCx_sup');
            spiHsup=ts(SpiHigh(:,2)*1E4);
            spiLsup=ts(SpiLow(:,2)*1E4);
            
            % get spindles deep 
            clear spiHdep spiLdep
            [SpiTot,SpiHigh,SpiLow]=GetSpindlesML('PFCx_deep');
            spiHdep=ts(SpiHigh(:,2)*1E4);
            spiLdep=ts(SpiLow(:,2)*1E4);
            
            
            if ~isempty(tDelta) && ~isempty(dHPCrip)
                
                %%%%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
                disp('- RunSubstages.m')
                [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages;
                close
                
                %%%%%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%
                %                 disp('... loading rec time with GetZT_ML.m')
                %                 NewtsdZT=GetZT_ML(Dir.path{man});
                %  rgZT=Range(NewtsdZT);
                
                %%%%%%%%%%%%%%%%%%%%%%%% GET SPIKES %%%%%%%%%%%%%%%%%%%%%%%
                % Get PFCx Spikes
                [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
                % remove MUA from the analysis
                nN=numNeurons;
                for s=1:length(numNeurons)
                    if TT{numNeurons(s)}(2)==1
                        nN(nN==numNeurons(s))=[];
                    end
                end
                            
                clear PFCx_MUA
                PFCx_MUA{1}=PoolNeurons(S,nN);
                PFCx_MUA=tsdArray(PFCx_MUA);
                QMua = MakeQfromS(PFCx_MUA,200);
                
                %%%%%%%%%%%%%%%%%%%%% run ImagePETH %%%%%%%%%%%%%%%%%%%%%%%
                disp('- Calculating ImagePETH for all neurons')
                figure, [fh, rasterAx, histAx, Val1{man,1}] = ImagePETH(QMua, Dpfc, -5000, +7000,'BinSize',100);close
                figure, [fh, rasterAx, histAx, Val2{man,1}] = ImagePETH(QMua, rip, -5000, +7000,'BinSize',100);close
                figure, [fh, rasterAx, histAx, Val3{man,1}] = ImagePETH(QMua, spiLsup, -5000, +7000,'BinSize',100);close
%                 figure, [fh, rasterAx, histAx, Val4{man,1}] = ImagePETH(QMua, spiHsup, -5000, +7000,'BinSize',100);close
%                 figure, [fh, rasterAx, histAx, Val5{man,1}] = ImagePETH(QMua, spiHdep, -5000, +7000,'BinSize',100);close
%                 figure, [fh, rasterAx, histAx, Val6{man,1}] = ImagePETH(QMua, spiLdep, -5000, +7000,'BinSize',100);close

                for n=1:3
                    disp(NamesStages{n+2})
                    eval(['epoch=',NamesStages{n+2},';'])
                    figure, try [fh, rasterAx, histAx, Val1{man,n+1}] = ImagePETH(QMua, Restrict(Dpfc,epoch), -5000, +7000,'BinSize',100);end;close
                    figure, try [fh, rasterAx, histAx, Val2{man,n+1}] = ImagePETH(QMua, Restrict(rip,epoch), -5000, +7000,'BinSize',100);end;close
                    figure, try [fh, rasterAx, histAx, Val3{man,n+1}] = ImagePETH(QMua, Restrict(spiLsup,epoch), -5000, +7000,'BinSize',100);end;close
%                     figure, [fh, rasterAx, histAx, Val4{man,n+1}] = ImagePETH(QMua, Restrict(spiHsup,epoch), -5000, +7000,'BinSize',100);close
%                     figure, [fh, rasterAx, histAx, Val5{man,n+1}] = ImagePETH(QMua, Restrict(spiHdep,epoch), -5000, +7000,'BinSize',100);close
%                     figure, [fh, rasterAx, histAx, Val6{man,n+1}] = ImagePETH(QMua, Restrict(spiLdep,epoch), -5000, +7000,'BinSize',100);close
                end
                
                %%%%%%%%%%%%%%%%%%%%% Plot Per Mouse %%%%%%%%%%%%%%%%%%%%%%
                disp('- Plot and save...')
                figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.8]),
                nameVal={'All',NamesStages{3:5}};
                coloriV=[0 0 0; colori(3:5,:)];
                Leg1=[];Leg2=[];Leg3=[];
                
                for i=1:4
                    % delta
                    subplot(3,6,i), try imagesc(Range(Val1{man,i},'s'),1:size(Data(Val1{man,i}),2),Data(Val1{man,i})'); end
                    axis xy; title(['PFCx MUA - ',nameVal{i},' Delta'])
                    if i==3, title({Dir.path{man},' ',['PFCx MUA - ',nameVal{i},' Delta']});end
                    subplot(3,6,5:6), hold on, try plot(Range(Val1{man,i},'s'),mean(Data(Val1{man,i})'),'Color',coloriV(i,:));
                    Leg1=[Leg1,{sprintf([nameVal{i},' n=%d'],size(Data(Val1{man,i}),2))}]; end
                    if i==4, legend(Leg1,'Location','BestOutside');end
                    % rip
                    subplot(3,6,6+i), try imagesc(Range(Val2{man,i},'s'),1:size(Data(Val2{man,i}),2),Data(Val2{man,i})');end
                    axis xy; title(['PFCx MUA - ',nameVal{i},' Ripples'])
                    subplot(3,6,11:12), hold on, try plot(Range(Val2{man,i},'s'),mean(Data(Val2{man,i})'),'Color',coloriV(i,:));
                    Leg2=[Leg2,{sprintf([nameVal{i},' n=%d'],size(Data(Val2{man,i}),2))}];end
                    if i==4, legend(Leg2,'Location','BestOutside');end
                    % spind
                    subplot(3,6,12+i), try imagesc(Range(Val3{man,i},'s'),1:size(Data(Val3{man,i}),2),Data(Val3{man,i})');end
                    axis xy; title(['PFCx MUA - ',nameVal{i},' Spindles Low sup'])
                    subplot(3,6,17:18), hold on, try plot(Range(Val3{man,i},'s'),mean(Data(Val3{man,i})'),'Color',coloriV(i,:));
                    Leg3=[Leg3,{sprintf([nameVal{i},' n=%d'],size(Data(Val3{man,i}),2))}];end
                    if i==4, legend(Leg3,'Location','BestOutside');end
                end
                xlabel('Time (s)')
                % save
                saveFigure(gcf,sprintf('AnalyseNREM-SpikesAndRhythms%d',man),FolderToSave)
                
            end
        end
    end
    save([res,'/AnalySubStages-SpikesAndRhythms.mat'],'Dir','Val1','Val2','Val3','nameVal','NamesStages')
end

