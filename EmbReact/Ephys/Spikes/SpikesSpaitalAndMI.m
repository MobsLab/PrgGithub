figure
NumLims=20;
x=[2:NumLims-1];
load('Firing_FzCond_NewRandomisation.mat')
for mouse_num=1:7
    clear AllSpkProfiles
    FR.FzCond{1}=[];
    FR.FzCond{2}=[];
    Duration_Shock.FzCond=[];
    Duration_NoShock.FzCond=[];
    MI.FzCond{1}=[];
    for sp=1:length(EpochFR{mouse_num})
        if IsPFCNeuron{mouse_num}(sp)==1
            % Habituation
            FR.FzCond{1}=[FR.FzCond{1},EpochFR{mouse_num}(sp).Fz.Shock.real];
            FR.FzCond{2}=[FR.FzCond{2},EpochFR{mouse_num}(sp).Fz.NoShock.real];
            Duration_Shock.FzCond=[Duration_Shock.FzCond,EpochDur.Fz{mouse_num}(1)];
            Duration_NoShock.FzCond=[Duration_NoShock.FzCond,EpochDur.Fz{mouse_num}(2)];
        end
    end
    MI.FzCond{1}=(FR.FzCond{1}-FR.FzCond{2})./(FR.FzCond{1}+FR.FzCond{2});
    
    
    clear SpikeTemp AllSpkProfiles
    for ss=1:length(SessNames)
        AllSpkProfiles{ss}=[];
        AllOccup{ss}=[];
        AllSpeedLin{ss}=[];
        
        for d=mouse_num
            clear SpikeTemp
            Lintemp=[];
            SpeedTemp=[];
            for sp=1:length(SAll{ss}{d}{1})
                SpikeTemp{sp}=[];
            end
            
            for dd=1:length(SAll{ss}{d})
                Lintemp=[Lintemp;LinDistAll{ss}{d}{dd}];
                SpeedTemp=[SpeedTemp;SpeedAll{ss}{d}{dd}];
                
                for sp=1:length(SAll{ss}{d}{dd})
                    SpikeTemp{sp}=[SpikeTemp{sp};Data(SAll{ss}{d}{dd}{sp})];
                end
            end
            
            clear MeanSpk  Occup
            for sp=1:length(SAll{ss}{d}{dd})
                for k=1:NumLims
                    Bins=find(Lintemp>(k-1)*1/NumLims & Lintemp<(k)*1/NumLims);
                    MeanSpk(sp,k)=nansum(SpikeTemp{sp}(Bins))./length(Bins);
                    Occup(k)=length(Bins);
                    Spd(k)=nanmean(SpeedTemp(Bins));
                end
            end
            
            AllSpkProfiles{ss}=[AllSpkProfiles{ss};MeanSpk];
            AllOccup{ss}=[AllOccup{ss};Occup];
            AllSpeedLin{ss}=[AllSpeedLin{ss};Spd];
            
            disp(num2str(length(AllSpkProfiles{ss})))
        end
        
    end
    
    if unique(Duration_NoShock.FzCond)>100
        weights=MI.FzCond{1}';
        if not(isempty(temp))
            for ss=1:length(SessNames)
                subplot(3,2,ss)
                temp=nanzscore(AllSpkProfiles{ss}')';
                temp=temp(:,2:end-1);
                
                ToExclude=find(sum(isnan(temp')>0));
                temp(ToExclude,:)=[];
                weights(ToExclude)=[];
                ToExclude=find((isnan(weights')>0));
                weights(ToExclude)=[];
                temp(ToExclude,:)=[];
                
                plot(x,nanzscore(temp'*weights),'linewidth',2), hold on
            end
        end
    end
end