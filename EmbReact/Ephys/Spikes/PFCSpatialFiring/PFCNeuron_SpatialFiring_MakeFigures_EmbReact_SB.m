clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring
SessNames={'Habituation','TestPre', 'UMazeCond','TestPost','Extinction'};
load('DataForeSpatialLinearizedSpiking.mat')
NumLims = 40; %Number of spatial bins
x = [2:NumLims-1];

MITypes = {'Hab','FzCond','RunCond','Ext'};
for type = 1 : length(MITypes)
    load(['Firing_',MITypes{type},'_NewRandomisation.mat'])
    
    FR.(MITypes{type}).Shock=[];
    FR.(MITypes{type}).Safe=[];
    
    Duration.(MITypes{type}).Shock=[];
    Duration.(MITypes{type}).Safe=[];
    
    MouseNum.(MITypes{type})=[];
    
    IsSig.(MITypes{type})=[];
    
    FLD = fieldnames(EpochFR{1}(1));
    
    for mouse_num=1:7
        for sp=1:length(EpochFR{mouse_num})
            if IsPFCNeuron{mouse_num}(sp)==1
                
                FR.(MITypes{type}).Shock = [FR.(MITypes{type}).Shock , EpochFR{mouse_num}(sp).(FLD{1}).Shock.real];
                FR.(MITypes{type}).Safe = [FR.(MITypes{type}).Safe , EpochFR{mouse_num}(sp).(FLD{1}).NoShock.real];
                
                Duration.(MITypes{type}).Shock = [Duration.(MITypes{type}).Shock , EpochDur.(FLD{1}){mouse_num}(1)];
                Duration.(MITypes{type}).Safe = [Duration.(MITypes{type}).Safe , EpochDur.(FLD{1}){mouse_num}(2)];
                
                MouseNum.(MITypes{type}) = [MouseNum.(MITypes{type}) , mouse_num];
                
                IsSig.(MITypes{type})=[IsSig.(MITypes{type}) , EpochFR{mouse_num}(sp).(FLD{1}).Shock_NoShock.IsSig];
                
                
            end
        end
    end
    
    MI.(MITypes{type})=(FR.(MITypes{type}).Shock-FR.(MITypes{type}).Safe)./(FR.(MITypes{type}).Shock+FR.(MITypes{type}).Safe);
    
end

%% Make overview figures
SaveFigsTo = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Figs_06012018/';

% Shock vs no shock modulation
fig=figure;
for type = 1 : length(MITypes)
    
    % all units
    subplot(2,4,type)
    dat_temp = MI.(MITypes{type});
    histogram(dat_temp,[-1:0.05:1],'Normalization','probability')
    hold on
    ylim([0 0.17]), xlim([-1 1])
    [h,p]=ttest(dat_temp);
    if p<0.05
        plot(nanmean(dat_temp),0.12,'.','MarkerSize',15,'color','k')
        line([nanmean(dat_temp)-nanstd(dat_temp),nanmean(dat_temp)+nanstd(dat_temp)],[1 1]*0.12,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color',[0.6 0.6 0.6])
    title(MITypes{type})
    set(gca,'XTick',[-1,1],'XTickLabel', {'SafePref','ShockPref'})
    if type ==1
        ylabel('AllUnits')
    end
    TotUnits = sum(not(isnan(dat_temp)));
    
    % only sig units
    subplot(2,4,type+4)
    dat_temp = MI.(MITypes{type})(abs(IsSig.(MITypes{type}))>0);
    histogram(dat_temp,[-1:0.05:1],'Normalization','probability')
    hold on
    ylim([0 0.14]), xlim([-1 1])
    [p,h]=signrank(dat_temp);
    if p<0.05
        plot(nanmean(dat_temp),0.12,'.','MarkerSize',15,'color','k')
        line([nanmean(dat_temp)-nanstd(dat_temp),nanmean(dat_temp)+nanstd(dat_temp)],[1 1]*0.12,'color','k','linewidth',2)
    end
    line([0 0],ylim,'color',[0.6 0.6 0.6])
    set(gca,'XTick',[-1,1],'XTickLabel', {'SafePref','ShockPref'})
    SigUnits = sum(not(isnan(dat_temp)));
    
    text(-0.8,0.09,[num2str(round(100*(SigUnits./TotUnits))), '%'])
    if type ==1
        ylabel('Sig Units')
    end
end
fig.Position = [2182 293 1528 631];
saveas(fig.Number,[SaveFigsTo,'MIDsitributions.png'])
saveas(fig.Number,[SaveFigsTo,'MIDsitributions.fig'])

% correlations between MI
fig=figure;
subplot(1,3,1)
UnitsOfInterest = (abs(IsSig.Hab)>0 | abs(IsSig.Ext)>0);
Hab_X = MI.Hab(UnitsOfInterest);
Ext_Y = MI.Ext(UnitsOfInterest);
Ext_Y(isnan(Hab_X)) = [];
Hab_X(isnan(Hab_X)) = [];
Hab_X(isnan(Ext_Y)) = [];
Ext_Y(isnan(Ext_Y)) = [];
plot(Hab_X,Ext_Y,'.')
line([-1 1],[-1 1])
xlim([-1 1]), ylim([-1 1]), axis square
[R,P]=corrcoef(Hab_X,Ext_Y);
xlabel('MI Hab'),ylabel('MI Ext')

subplot(1,3,2)
UnitsOfInterest = (abs(IsSig.FzCond)>0 | abs(IsSig.RunCond)>0);
FzCond_X = MI.FzCond(UnitsOfInterest);
RunCond_Y = MI.RunCond(UnitsOfInterest);
RunCond_Y(isnan(FzCond_X)) = [];
FzCond_X(isnan(FzCond_X)) = [];
FzCond_X(isnan(RunCond_Y)) = [];
RunCond_Y(isnan(RunCond_Y)) = [];
plot(FzCond_X,RunCond_Y,'.')
line([-1 1],[-1 1])
xlim([-1 1]), ylim([-1 1]), axis square
[R,P]=corrcoef(FzCond_X,RunCond_Y)
xlabel('MI FzCond'),ylabel('MI RunCond')

subplot(1,3,3)
UnitsOfInterest = (abs(IsSig.Ext)>0 | abs(IsSig.RunCond)>0);
Ext_X = MI.Ext(UnitsOfInterest);
RunCond_Y = MI.RunCond(UnitsOfInterest);
RunCond_Y(isnan(Ext_X)) = [];
Ext_X(isnan(Ext_X)) = [];
Ext_X(isnan(RunCond_Y)) = [];
RunCond_Y(isnan(RunCond_Y)) = [];
plot(Ext_X,RunCond_Y,'.')
line([-1 1],[-1 1])
xlim([-1 1]), ylim([-1 1]), axis square
[R,P]=corrcoef(Ext_X,RunCond_Y)
xlabel('MI Ext'),ylabel('MI RunCond')
fig.Position = [2376 277 809 5561];
saveas(fig.Number,[SaveFigsTo,'MICorrelations.png'])
saveas(fig.Number,[SaveFigsTo,'MICorrelations.fig'])



% correlations between MI
fig=figure;
subplot(1,3,1)
UnitsOfInterest = (abs(IsSig.FzCond)>0 | abs(IsSig.Hab)>0);
FzCond_X = MI.FzCond(UnitsOfInterest);
Hab_Y = MI.Hab(UnitsOfInterest);
Hab_Y(isnan(FzCond_X)) = [];
FzCond_X(isnan(FzCond_X)) = [];
FzCond_X(isnan(Hab_Y)) = [];
Hab_Y(isnan(Hab_Y)) = [];
plot(FzCond_X,Hab_Y,'.')
line([-1 1],[-1 1])
xlim([-1.1 1.1]), ylim([-1.1 1.1]), axis square
[R,P]=corrcoef(FzCond_X,Hab_Y)
xlabel('MI FzCond'),ylabel('MI Hab')

subplot(1,3,2)
UnitsOfInterest = (abs(IsSig.FzCond)>0 | abs(IsSig.RunCond)>0);
FzCond_X = MI.FzCond(UnitsOfInterest);
RunCond_Y = MI.RunCond(UnitsOfInterest);
RunCond_Y(isnan(FzCond_X)) = [];
FzCond_X(isnan(FzCond_X)) = [];
FzCond_X(isnan(RunCond_Y)) = [];
RunCond_Y(isnan(RunCond_Y)) = [];
plot(FzCond_X,RunCond_Y,'.')
line([-1 1],[-1 1])
xlim([-1.1 1.1]), ylim([-1.1 1.1]), axis square
[R,P]=corrcoef(FzCond_X,RunCond_Y)
xlabel('MI FzCond'),ylabel('MI RunCond')

subplot(1,3,3)
UnitsOfInterest = (abs(IsSig.FzCond)>0 | abs(IsSig.Ext)>0);
FzCond_X = MI.FzCond(UnitsOfInterest);
Ext_Y = MI.Ext(UnitsOfInterest);
Ext_Y(isnan(FzCond_X)) = [];
FzCond_X(isnan(FzCond_X)) = [];
FzCond_X(isnan(Ext_Y)) = [];
Ext_Y(isnan(Ext_Y)) = [];
plot(FzCond_X,Ext_Y,'.')
line([-1 1],[-1 1])
xlim([-1.1 1.1]), ylim([-1.1 1.1]), axis square
[R,P]=corrcoef(FzCond_X,Ext_Y)
xlabel('MI FzCond'),ylabel('MI Ext')
fig.Position = [2376 277 809 5561];
saveas(fig.Number,[SaveFigsTo,'MICorrelationsOnFzCond.png'])
saveas(fig.Number,[SaveFigsTo,'MICorrelationsOnFzCond.fig'])


% Project activity onto MI
for type = 1 : length(MITypes)
    
    fig=figure;
    
    for ss=1:length(SessNames)
        subplot(3,2,ss)
        temp=nanzscore(AllSpkProfiles{ss}')';
        temp=temp(:,2:end-1);
        weights=MI.(MITypes{type})';
        
        weights(Duration.(MITypes{type}).Safe<5)=[];
        temp(Duration.(MITypes{type}).Safe<5,:)=[];
        msnum=MouseNum.(MITypes{type});
        msnum(Duration.(MITypes{type}).Safe<5)=[];
        
        ToExclude=find(sum(isnan(temp')>0));
        temp(ToExclude,:)=[];
        weights(ToExclude)=[];
        msnum(ToExclude)=[];
        
        ToExclude=find((isnan(weights')>0));
        weights(ToExclude)=[];
        temp(ToExclude,:)=[];
        msnum(ToExclude)=[];
        
        bar(x,temp'*weights), hold on
        for mouse_num=1:7
            if not(isempty(find(msnum==mouse_num)))
                [R,P]=corr(x',temp(find(msnum==mouse_num),:)'*weights(find(msnum==mouse_num)));
                if P<0.05
                    plot(x,temp(find(msnum==mouse_num),:)'*weights(find(msnum==mouse_num)),'linewidth',2,'color','r')
                else
                    plot(x,temp(find(msnum==mouse_num),:)'*weights(find(msnum==mouse_num)),'linewidth',2,'color',[0.6 0.6 0.6])
                end
            end
        end
        ylim([-30 30])
        [R,P]=corr(x',temp'*weights);
        if P<0.05
            hold on
            coeffpolyfit = polyfit(x',temp'*weights,1);
            % Evaluate the fitted polynomial p and plot:
            f = polyval(coeffpolyfit,[2:NumLims-1]);
            plot(x,f,'r-','linewidth',2)
            
        end
        title(SessNames{ss})
        set(gca,'XTick',[1 40],'XTickLabel', {'Shock','Safe'})
        
    end
    
    fig.Position = [2130 102 695 751];
    saveas(fig.Number,[SaveFigsTo,'MIProjectionOfLinFiring',MITypes{type},'.png'])
    saveas(fig.Number,[SaveFigsTo,'MIProjectionOfLinFiring',MITypes{type},'.fig'])
    
end

% use only spikes from animals that visited the whole environment
temp=[];
for ss=1:length(SessNames)
    temp=[temp,nanzscore(AllSpkProfiles{ss}')'];
end
ToUse=(sum(isnan(temp)')<10);
RefToUse = [1,3,3,5]; % this is the location in Spike_Line_sorted of the spikes used to calc the MI

% All units
for type = 1:4
    fig=figure;
    AllNeurMI=MI.(MITypes{type})(ToUse);
    
    for ss=1:length(SessNames)
        Spike_Line=(nanzscore(AllSpkProfiles{ss}')');
        Spike_Line=Spike_Line(:,2:end-1);
        Spike_Line=Spike_Line(ToUse,:);
        
        subplot(5,2,(ss-1)*2+1)
        Spike_Line_sorted{ss}=(sortrows([AllNeurMI',Spike_Line]));
        
        Spike_Line_sorted{ss}=Spike_Line_sorted{ss}(:,2:end);
        imagesc(Spike_Line_sorted{ss}(:,2:end)),axis xy
        set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
        title(SessNames{ss})
        clim([-2 2])
    end
    
    Xref = corr(Spike_Line_sorted{RefToUse(type)}',Spike_Line_sorted{RefToUse(type)}');
    
    for ss=1:length(SessNames)
        X=corr(Spike_Line_sorted{ss}',Spike_Line_sorted{RefToUse(type)}');
        subplot(5,2,(ss-1)*2+2)
        imagesc(X),clim([-0.3 0.3]),axis xy
        xlabel('Hab'), ylabel(SessNames{ss})
        [R,P] = corrcoef(Spike_Line_sorted{ss},Spike_Line_sorted{RefToUse(type)});
        Rdist(type,ss) = R(1,2);
        Pdist(type,ss) = P(1,2);
        
    end
    fig.Position = [2130 2 615 972];
    saveas(fig.Number,[SaveFigsTo,'MIorderedLinFiringwiCorrMat',MITypes{type},'.png'])
    saveas(fig.Number,[SaveFigsTo,'MIorderedLinFiringwiCorrMat',MITypes{type},'.fig'])
    
end


% Only sig units
for type = 1:4
    fig=figure;
    AllNeurMI=MI.(MITypes{type});
    GoodUnits = (abs(IsSig.(MITypes{type}))>0);
    AllNeurMI=AllNeurMI(and(GoodUnits,ToUse));
    
    for ss=1:length(SessNames)
        Spike_Line=(nanzscore(AllSpkProfiles{ss}')');
        Spike_Line=Spike_Line(:,2:end-1);
        Spike_Line=Spike_Line(and(GoodUnits,ToUse),:);
        
        subplot(5,2,(ss-1)*2+1)
        Spike_Line_sorted{ss}=(sortrows([AllNeurMI',Spike_Line]));
        
        Spike_Line_sorted{ss}=Spike_Line_sorted{ss}(:,2:end);
        imagesc(Spike_Line_sorted{ss}(:,2:end)),axis xy
        set(gca,'XTick',[10,28],'XTickLabel',{'Shock','Safe'})
        title(SessNames{ss})
        clim([-2 2])
    end
    
    Xref = corr(Spike_Line_sorted{RefToUse(type)}',Spike_Line_sorted{RefToUse(type)}');
    for ss=1:length(SessNames)
        X=corr(Spike_Line_sorted{ss}',Spike_Line_sorted{RefToUse(type)}');
        subplot(5,2,(ss-1)*2+2)
        imagesc(X),clim([-0.3 0.3]),axis xy
        xlabel('Hab'), ylabel(SessNames{ss})
        [R,P] = corrcoef(Spike_Line_sorted{ss},Spike_Line_sorted{RefToUse(type)});
        Rdist(type,ss) = R(1,2);
        Pdist(type,ss) = P(1,2);
    end
    fig.Position = [2130 2 615 972];
    saveas(fig.Number,[SaveFigsTo,'MIorderedLinFiringwiCorrMatOnlySig',MITypes{type},'.png'])
    saveas(fig.Number,[SaveFigsTo,'MIorderedLinFiringwiCorrMatOnlySig',MITypes{type},'.fig'])
    
end


fig=figure;
plot([2:5],Rdist(1,2:end),'o-','linewidth',2,'color','b'), hold on
plot([1:4],Rdist(4,1:end-1),'o-','linewidth',2,'color','r')
for k=2:5
    if Pdist(1,k)<0.05/4
        plot(k,0.18,'b*')
    end
end
for k=1:4
    if Pdist(4,k)<0.05/4
        plot(k,0.17,'r*')
    end
end
legend('Hab','Ext')
xlim([0.5,5.5]), ylim([-0.01 0.19])
box off
set(gca,'XTick',[1:5],'XTickLabel',SessNames)
ylabel('Correlation of firing maps')
saveas(fig.Number,[SaveFigsTo,'CorrelationOfFiringMaps.png'])
saveas(fig.Number,[SaveFigsTo,'CorrelationOfFiringMaps.fig'])
