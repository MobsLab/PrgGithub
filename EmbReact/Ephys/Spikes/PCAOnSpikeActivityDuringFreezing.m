clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'UMazeCond'};
Dir = PathForExperimentsEmbReact(SessNames{1});

for dd=1:length(Dir.path)
     MaxTime=0;
     clear AllS
    if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
        for ddd=1:length(Dir.path{dd})
            cd(Dir.path{dd}{ddd})
            disp(Dir.path{dd}{ddd})
            
           
            keyboard
            for ff=1:length(FileNames)
                cd(FileNames{ff})
                disp(FileNames{ff})
                SpToUse=GetSpikesFromStructure('PFCx');
                load('SpikeData.mat')
                load('LFPData/LFP1.mat')
                load('ExpeInfo.mat')
                
                if  ExpeInfo.SleepSession==1
                    load('StateEpochSB.mat','smooth_ghi','wakeper')
                else
                    load('StateEpochSB.mat','smooth_ghi')
                end
                
                AllGamma=[AllGamma;Data(smooth_ghi)];
                AllGammaTime=[AllGammaTime;Range(smooth_ghi)+MaxTime];
                if exist('behavResources_SB.mat')>0
                    clear Behav
                    load('behavResources_SB.mat')
                    if isfield(Behav,'Vtsd')
                        %                 rg=Range(Behav.Xtsd);
                        %                 Behav.Vtsd=tsd(rg(1:end-1),Data(Behav.Vtsd));
                        %                 save('behavResources_SB.mat','Behav')
                        AllSpeed=[AllSpeed;Data(Behav.Vtsd)];
                        AllSpeedTime=[AllSpeedTime;Range(Behav.Vtsd)+MaxTime];
                    end
                else
                    %             AllSpeed=[AllSpeed;0];
                    %             AllSpeedTime=[AllSpeedTime;MaxTime];
                end
                
                
                
                clear Behav
                for sp=1:length(SpToUse)
                    if  ExpeInfo.SleepSession==1 & WakeOnly==1
                        AllS{sp}{ff}=Range(Restrict(S{SpToUse(sp)},wakeper))+MaxTime;
                    else
                        AllS{sp}{ff}=Range(S{SpToUse(sp)})+MaxTime;
                        
                    end
                end
                MaxTime=MaxTime+max(Range(LFP));
                RemTime(ff)=MaxTime;
            end
            
            fig=figure;
            fig.Units='normalized';
            fig.Position=[0.2 0.3 1 1];
            clear Y
            for s=1:length(AllS)
                Spikes=[];
                for ff=1:length(FileNames)
                    Spikes=[Spikes;AllS{s}{ff}];
                end
                [Y(s,:),X]=hist(Spikes,[0:1e5:max(RemTime)]);
            end
            Ytemp=Y;
            Ytemp(:,sum(Ytemp)==0)=[];
            Dat=zscore(Ytemp')';
            [EigVect,EigVals]=PerformPCA(Dat);
            Dat=zscore(Y')';
            for k=1:3
                subplot(5,4,[1:3]+(k-1)*4)
                ToPlot=EigVect(:,k)'*Dat;
                ToPlot(sum(Y)==0)=NaN;
                plot(X,ToPlot,'.'), hold on
                line([RemTime;RemTime],[RemTime*0+min(ylim);RemTime*0+max(ylim)],'color','k')
                xlim([0 max(RemTime)])
                ylabel(['Comp' num2str(k)])
                subplot(5,4,4+(k-1)*4)
                imagesc(X,1:length(EigVect),sortrows([EigVect(:,k),Dat]))
                line([RemTime;RemTime],[RemTime*0+min(ylim);RemTime*0+max(ylim)],'color','k')
                clim([-2 2]);
                set(gca,'YTick',[],'XTick',[])
            end
            subplot(5,4,13:15)
            plot(AllGammaTime,AllGamma)
            line([RemTime;RemTime],[RemTime*0+min(ylim);RemTime*0+max(ylim)],'color','k')
            xlim([0 max(RemTime)])
            ylabel('gamma OB')
            subplot(5,4,16)
            plot(cumsum(EigVals)/sum(EigVals))
            xlabel('comp num'), ylabel('% variance')
            subplot(5,4,17:19)
            plot(AllSpeedTime,AllSpeed)
            line([RemTime;RemTime],[RemTime*0+min(ylim);RemTime*0+max(ylim)],'color','k')
            xlim([0 max(RemTime)])
            xlabel('time (s)'), ylabel('speed')
            
            if WakeOnly==1
                saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PCA/PCAWithNoSleep',num2str(MiceNumber(mm)),'.fig'])
                saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PCA/PCAWithNoSleep',num2str(MiceNumber(mm)),'.png'])
            else
                saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PCA/PCAWithSleep',num2str(MiceNumber(mm)),'.fig'])
                saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PCA/PCAWithSleep',num2str(MiceNumber(mm)),'.png'])
            end
        end
        
        
        
        
