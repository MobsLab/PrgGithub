%%CompareIsiBasalCloseLoopPlot_fr
% 18.07.2019 KJ
%
% Look at the effect of tones/sham on the Intervals between down states

%
%   see 
%       FigISITonesShamOnDownStates
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'CompareIsiBasalCloseLoop.mat'))

animals = unique(basal_res.name);
% animals = unique(bci_res.name);


%% TONES - Pool by mouse

for k=1:3
    tones_success{k} = [];
    tones_failed{k}  = [];
    basal_isi{k}     = [];
end

for m=1:length(animals)
    
    for k=1:3
        %basal
        mouse_basal{k} = [];
        for p=1:length(basal_res.path)
            if strcmpi(animals{m}, basal_res.name{p})
                mouse_basal{k} = [mouse_basal{k} ; nanmean(basal_res.isi_basal{p}{k})];
            end
        end
        
        %tones
        mouse_success{k} = [];
        mouse_failed{k}  = [];
        for p=1:length(bci_res.path)
            if strcmpi(animals{m},bci_res.name{p})
                mouse_success{k} = [mouse_success{k} ; nanmean(bci_res.isi_success{p}{k})];
                mouse_failed{k}  = [mouse_failed{k} ; nanmean(bci_res.isi_failed{p}{k})];
            end
        end
        
        %concatenate
        basal_isi{k}     = [basal_isi{k} ; nanmean(mouse_basal{k})/10];
        tones_success{k} = [tones_success{k} ; nanmean(mouse_success{k})/10];
        tones_failed{k}  = [tones_failed{k} ; nanmean(mouse_failed{k})/10];
    end
    
    
end


%% Stat on data

for k=1:3
    [R.basal_isi(k),~,E.basal_isi(k)]         = MeanDifNan(basal_isi{k});
    [R.tones_success(k),~,E.tones_success(k)] = MeanDifNan(tones_success{k});
    [R.tones_failed(k),~,E.tones_failed(k)]   = MeanDifNan(tones_failed{k});
end






%% line

x_line{1} =  R.tones_success;
x_line{2} =  R.basal_isi;
x_line{3} =  R.tones_failed;

bar_line{1} =  E.tones_success;  
bar_line{2} =  E.basal_isi;
bar_line{3} =  E.tones_failed;


%% PLOT

linecolors = {'b', 'k', 'r'};
labels = {' Sons réussis', ' Basal', ' Sons manqués'};
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)'}; %ISI


figure, hold on

%lines
for k=1:length(labels)
    hpl(k)=plot(x_line{k}, 1:length(NameISI),'color',linecolors{k},'Linewidth',4); hold on
end
%error bar
for k=1:length(labels)
    eb=herrorbar(x_line{k},1:length(NameISI),bar_line{k},'.k'); hold on
    set(eb,'color',linecolors{k},'Linewidth',4); %bold error bar
end

title('Inter delta intervalles'), xlabel('ms'), hold on,
set(gca, 'YTickLabel',NameISI, 'YTick',1:length(NameISI),'YLim',[0.5 length(NameISI)+0.5],'fontsize',32), hold on,
set(gca, 'XTick',0:1000:7000,'XLim',[0 7000]);
legend(hpl,labels),



















