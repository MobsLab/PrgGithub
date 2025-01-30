

%% Position
% firing rate
clear all
PFC=0;
SortByEigVal = 1;
Binsize = 0.05*1e4;
win_size = 2e3;
num = 1;

if PFC
    Session_type={'Cond','Ext','Fear'}; sess=1;
    MiceNumber=[490,507,508,509]; % excluded 514, too few ripples
    cd('/home/ratatouille/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_BM/Ripples_Reactivations')
else
    MiceNumber = [905,906,911,994,1161,1162,1168,1186,1230,1239]; %no 1182 because problem of stim
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
end


for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch strength templates correlations eigenvectors lambdaMax
    if PFC
        load(['RippleReactInfo_NewRipples_SWR_' Session_type{sess} '_M',num2str(MiceNumber(mm)),'.mat'])
    else
        load(['RippleReactInfo_NewRipples_Mouse',num2str(MiceNumber(mm)),'.mat'])
    end
    
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    if and(PFC , mm==2)
        Ripples = Restrict(Ripples,TotEpoch);
    else
        Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    end
    Ripples = Restrict(Ripples , and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch));
%     Ripples = Restrict(Ripples , FreezeEpoch);
    
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    Q = tsd(Range(Q),nanzscore(full(Data(Q))));
    
    D = Data(Q); 
    for neur=1:size(D,2)
        Q_neur{neur} = tsd(Range(Q) , D(:,neur));
        
        [M,T] = PlotRipRaw(Q_neur{neur},Start(StimEpoch,'s'),win_size,0,0);
        FiringRateEvol_Stim{mm}(neur,:) = M(:,2);
        
        [M,T] = PlotRipRaw(Q_neur{neur},Range(Ripples,'s'),win_size,0,0);
        FiringRateEvol_Rip{mm}(neur,:) = M(:,2);
        
        mean_FR{mm}(neur) = length(Range(Spikes{neur}))/(sum(DurationEpoch(TotEpoch))/1e4);
    end
end


FiringRateEvol_Stim_all=[];
FiringRateEvol_Rip_all=[];
Mean_FR_all=[];
for mm=1:length(MiceNumber)
    FiringRateEvol_Stim_all = [FiringRateEvol_Stim_all ; FiringRateEvol_Stim{mm}];
    FiringRateEvol_Rip_all = [FiringRateEvol_Rip_all ; FiringRateEvol_Rip{mm}];
    Mean_FR_all = [Mean_FR_all ; mean_FR{mm}'];
end


%%
g = round(nanmedian(size(FiringRateEvol_Stim_all,2))/2);

if PFC
%     ind1=[46:61]; ind2=[39:46]; optimal
    ind1=[46:61]; ind2=[39:46];
    FiringRateEvol_Stim_all(:,g:g+((size(FiringRateEvol_Stim_all,2)-1)/(2*win_size/1e3))/5) = NaN;
else
    ind1=[44:81]; ind2=[39:43];
    FiringRateEvol_Stim_all(:,g:g+((size(FiringRateEvol_Stim_all,2)-1)/(2*win_size/1e3))/10) = NaN;
end


[i_stim,j_stim]=sort(nanmean(FiringRateEvol_Stim_all(:,ind1)')); 
[i_rip,j_rip]=sort(nanmean(FiringRateEvol_Rip_all(:,ind2)')); 

% peri-event
figure
subplot(2,9,1:2)
imagesc(linspace(-win_size/1e3,win_size/1e3,size(FiringRateEvol_Stim_all,2)) , [1:size(FiringRateEvol_Stim_all,1)] , FiringRateEvol_Stim_all(j_stim,:))
xlim([-win_size/1e3 win_size/1e3]), caxis([-2 2])
vline(0,'--r')
ylabel('neurons around stim')
title('sorted by stim response')

subplot(2,9,3)
clear A, A = runmean(nanmean(FiringRateEvol_Stim_all(j_stim,ind1)'),10);
plot(A,[1:size(FiringRateEvol_Stim_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Stim_all,1)])
yticklabels({''})

subplot(2,9,4:5)
imagesc(linspace(-win_size/1e3,win_size/1e3,size(FiringRateEvol_Stim_all,2)) , [1:size(FiringRateEvol_Stim_all,1)] , FiringRateEvol_Stim_all(j_rip,:))
xlim([-win_size/1e3 win_size/1e3]), caxis([-2 2])
vline(0,'--r')
title('sorted by rip response')

subplot(2,9,6)
clear A, A = runmean(nanmean(FiringRateEvol_Stim_all(j_rip,ind1)'),10);
plot(A,[1:size(FiringRateEvol_Stim_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Stim_all,1)])
yticklabels({''})


subplot(2,9,10:11)
imagesc(linspace(-win_size/1e3,win_size/1e3,size(FiringRateEvol_Rip_all,2)) , [1:size(FiringRateEvol_Rip_all,1)] , FiringRateEvol_Rip_all(j_stim,:))
xlim([-win_size/1e3 win_size/1e3]), %caxis([-2 2])
vline(0,'--r')
xlabel('time (s)'), ylabel('neurons around ripples')

subplot(2,9,12)
clear A, A = runmean(nanmean(FiringRateEvol_Rip_all(j_stim,ind2)'),10);
plot(A,[1:size(FiringRateEvol_Rip_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Stim_all,1)])
xlabel('zscore'), yticklabels({''})

subplot(2,9,13:14)
imagesc(linspace(-win_size/1e3,win_size/1e3,size(FiringRateEvol_Stim_all,2)) , [1:size(FiringRateEvol_Rip_all,1)] , FiringRateEvol_Rip_all(j_rip,:))
xlim([-win_size/1e3 win_size/1e3]), %caxis([-2 2])
vline(0,'--r')
xlabel('time (s)'), yticklabels({''})

subplot(2,9,15)
clear A, A = runmean(nanmean(FiringRateEvol_Rip_all(j_rip,ind2)'),10);
plot(A,[1:size(FiringRateEvol_Rip_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Rip_all,1)])
xlabel('zscore'), yticklabels({''})


colormap viridis


subplot(133)
[R,P]=PlotCorrelations_BM(nanmean(FiringRateEvol_Stim_all(:,ind1)') , nanmean(FiringRateEvol_Rip_all(:,ind2)') , 'method' , 'pearson')
axis square
xlabel('change in firing around stim'), ylabel('change in firing around ripples')
vline(0,'--r'), hline(0,'--r')



% corr matrices
A = corr(FiringRateEvol_Stim_all(:,ind1)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
ind=~isnan(A(:,1)); A=A(ind,ind); FiringRateEvol_Stim_all=FiringRateEvol_Stim_all(ind,:);
[row,~] = ind2sub([length(A) length(A)],find(or(A==1 , isnan(A)))); row=unique(row); 
FiringRateEvol_Stim_all(row,:)=[];



figure
subplot(121)
A = corr(FiringRateEvol_Stim_all);
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)) , linspace(-win_size/1e3 , win_size/1e3,length(A)) , A), axis square
l=vline(0,'--r'); set(l,'LineWidth',5); l=hline(0,'--r'); set(l,'LineWidth',5);
xlabel('time (s)'), ylabel('time (s)')

subplot(224)
A = corr(FiringRateEvol_Stim_all(:,ind1)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
[A_bis , ~ , ~ , v] = OrderMatrix_BM(A  , {''} , [] , 0);
imagesc(A_bis), axis square
xlabel('no neuron'), ylabel('no neuron')
title('after stim')
caxis([-1 1])

subplot(222)
A = corr(FiringRateEvol_Stim_all(:,1:g-2)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
imagesc(A(v,v)), axis square
xlabel('no neuron'), ylabel('no neuron')
title('before stim')
caxis([-1 1])

colormap redblue



A = corr(FiringRateEvol_Stim_all(:,ind1)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
ind=~isnan(A(:,1)); A=A(ind,ind); FiringRateEvol_Stim_all=FiringRateEvol_Stim_all(ind,:);
[row,~] = ind2sub([length(A) length(A)],find(or(A==1 , isnan(A)))); row=unique(row); 
FiringRateEvol_Stim_all(row,:)=[];


figure
subplot(121)
A = corr(FiringRateEvol_Rip_all);
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)) , linspace(-win_size/1e3 , win_size/1e3,length(A)) , A), axis square
vline(0,'--r'), hline(0,'--r')
xlabel('time (s)'), ylabel('time (s)')

subplot(224)
A = corr(FiringRateEvol_Rip_all(:,ind2)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
[A_bis , ~ , ~ , v] = OrderMatrix_BM(A  , {''} , [] , 0);
imagesc(A_bis), axis square
xlabel('no neuron'), ylabel('no neuron')
title('ripples epoch')

subplot(222)
A = corr(FiringRateEvol_Rip_all(:,1:g-4)');
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end
imagesc(A(v,v)), axis square
xlabel('no neuron'), ylabel('no neuron')
title('control epoch')
caxis([-1 1])

colormap redblue


% Sophie's stuff
FiringRateEvol_Stim_all=[];
FiringRateEvol_Rip_all=[];
for mm=1:length(MiceNumber)
    FiringRateEvol_Stim_all = [FiringRateEvol_Stim_all ; FiringRateEvol_Stim{mm}];
    FiringRateEvol_Rip_all = [FiringRateEvol_Rip_all ; FiringRateEvol_Rip{mm}];
end



figure
A = corr([nanzscore(FiringRateEvol_Stim_all')' , nanzscore(FiringRateEvol_Rip_all')'],...
[nanzscore(FiringRateEvol_Stim_all')',nanzscore(FiringRateEvol_Rip_all')']);
for i=1:length(A)
    A(i,i)=nanmedian(nanmedian(A));
end

subplot(221)
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)),linspace(-win_size/1e3 , win_size/1e3,length(A)),A(1:81,1:81))
axis square, ylabel('time (s)')
title('Autocorr stim')

subplot(222)
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)),linspace(-win_size/1e3 , win_size/1e3,length(A)),A(1:81,82:162))
axis square
title('Corr stim x ripples')

subplot(223)
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)),linspace(-win_size/1e3 , win_size/1e3,length(A)),A(82:162,1:81))
axis square
xlabel('time (s)'), ylabel('time (s)')
title('Corr ripples x stim')

subplot(224)
imagesc(linspace(-win_size/1e3 , win_size/1e3,length(A)),linspace(-win_size/1e3 , win_size/1e3,length(A)),A(82:162,82:162))
axis square
xlabel('time (s)')
title('Autocorr ripples')

colormap redblue






figure
imagesc(corr([zscore(FiringRateEvol_Stim_all')',zscore(FiringRateEvol_Rip_all')'],[zscore(FiringRateEvol_Stim_all')',zscore(FiringRateEvol_Rip_all')']))



figure
subplot(221)
clear A, A = runmean(nanmean(FiringRateEvol_Stim_all(j_stim,ind1)'),10);
plot(A,[1:size(FiringRateEvol_Stim_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Stim_all,1)]), ylabel('neurons sorted by stim response')
yticklabels({''})
title('Firing rate after stim')

subplot(222)
clear A, A = runmean(Mean_FR_all(j_stim),10);
plot(A,[1:size(Mean_FR_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse'); set(gca,'XScale','log');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Stim_all,1)])
yticklabels({''})
title('Mean firing rate')

subplot(223)
clear A, A = runmean(nanmean(FiringRateEvol_Rip_all(j_rip,ind2)'),10);
plot(A,[1:size(FiringRateEvol_Rip_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse');
box off
xlim([min(A) max(A)]), ylim([0 size(FiringRateEvol_Rip_all,1)]), ylabel('neurons sorted by ripples response')
xlabel('zscore'), yticklabels({''})
title('Firing rate around ripples')

subplot(224)
clear A, A = runmean(Mean_FR_all(j_rip),10);
plot(A,[1:size(Mean_FR_all,1)] , 'k' , 'LineWidth' , 2), axis xy
set(gca,'YDir','reverse'); set(gca,'XScale','log');
box off
xlim([0 20]), ylim([0 size(FiringRateEvol_Stim_all,1)])
yticklabels({''}), xlabel('Firing rate (Hz)')
title('Mean firing rate')



