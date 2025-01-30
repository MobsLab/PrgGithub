%%ConnectivityAndResponseTones
% 21.01.2019 KJ
%
%
% see
%   NeuronClassAndConnectivity_KJ FigResponseNeuronsFR
%



clear

%params
zscoring = 2; %0 for firing rate, 1 for zscore, 2 for zscore by the pre period 


%% load
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseTypeNeurons.mat'))
p = find(strcmpi(resp_res.path,pwd));

load('SpikeConnectivity.mat')
load('SpikeData.mat')
load('InfoNeuronsAll.mat')



%% neurons

good_neuron = (InfoNeurons.ismua==0 & strcmpi(InfoNeurons.structure,'PFCx')');
MatConnectivity = MatConnectivity(good_neuron,good_neuron);
ConnectivityStrength = ConnectivityStrength(good_neuron,good_neuron);

nb_excit.output = sum(MatConnectivity==1,2);
nb_inhib.output = sum(MatConnectivity==-1,2);
nb_excit.input = sum(MatConnectivity==1,1)';
nb_inhib.input = sum(MatConnectivity==-1,1)';


%by group
labels = {'0','1-2','3-4','>4'};

neuronGroup.output{1} = find(nb_excit.output==0);
neuronGroup.output{2} = find(nb_excit.output>0 & nb_excit.output<=2);
neuronGroup.output{3} = find(nb_excit.output>2 & nb_excit.output<=4);
neuronGroup.output{4} = find(nb_excit.output>4);

neuronGroup.input{1} = find(nb_excit.input==0);
neuronGroup.input{2} = find(nb_excit.input>0 & nb_excit.input<=2);
neuronGroup.input{3} = find(nb_excit.input>2 & nb_excit.input<=4);
neuronGroup.input{4} = find(nb_excit.input>4);


%% concatenate and zscore

%data
MatTonesUpUP = resp_res.MatTonesUpUP{p};
MatTonesUpDown = resp_res.MatTonesUpDown{p};
MatTonesDownUp = resp_res.MatTonesDownUp{p};
MatTransitDownUp = resp_res.MatTransitDownUp{p};
MatTransitUpDown = resp_res.MatTransitUpDown{p};
neuronClass = resp_res.InfoNeuronClass{p};
neuronFR = resp_res.InfoNeuronFR{p};

%timestamps
t_corr = resp_res.t_corr{1};


%normalisation
if zscoring==1
    ZtonesUpUp = zscore(MatTonesUpUP,[],2);
    ZtonesUpDown = zscore(MatTonesUpDown,[],2);
    ZtonesDownUp = zscore(MatTonesDownUp,[],2);
    ZtransitDownUp = zscore(MatTransitDownUp,[],2);
    ZtransitUpDown = zscore(MatTransitUpDown,[],2);
    
elseif zscoring==2
    ZtonesUpUp = (MatTonesUpUP-mean(MatTonesUpUP(:,t_corr<-200),2)) ./ std(MatTonesUpUP(:,t_corr<-200),0,2);
    ZtonesUpDown = (MatTonesUpDown-mean(MatTonesUpDown(:,t_corr<-200),2)) ./ std(MatTonesUpDown(:,t_corr<-200),0,2);
    ZtonesDownUp = (MatTonesDownUp-mean(MatTonesDownUp(:,t_corr<-200),2)) ./ std(MatTonesDownUp(:,t_corr<-200),0,2);
    ZtransitDownUp = (MatTransitDownUp-mean(MatTransitDownUp(:,t_corr<-200),2)) ./ std(MatTransitDownUp(:,t_corr<-200),0,2);
    ZtransitUpDown = (MatTransitUpDown-mean(MatTransitUpDown(:,t_corr<-200),2)) ./ std(MatTransitUpDown(:,t_corr<-200),0,2);
    
else
    ZtonesUpUp = MatTonesUpUP ./ neuronFR;
    ZtonesUpDown = MatTonesUpDown ./ neuronFR;
    ZtonesDownUp = MatTonesDownUp ./ neuronFR;
    ZtransitDownUp = MatTransitDownUp ./ neuronFR;
    ZtransitUpDown = MatTransitUpDown ./ neuronFR;
end


%clean
ZtonesUpUp(~isfinite(ZtonesUpUp))=nan;
ZtonesUpDown(~isfinite(ZtonesUpDown))=nan;
ZtonesDownUp(~isfinite(ZtonesDownUp))=nan;
ZtransitDownUp(~isfinite(ZtransitDownUp))=nan;
ZtransitUpDown(~isfinite(ZtransitUpDown))=nan;



%% FR and connecitvity
fontsize=13;
sz = 20;
colori_neur = {'r', [0.5 0 0.5], [1 0.45 0], 'b'};

figure, hold on

%FR vs excitatory output
subplot(2,2,1), hold on 
scatter(neuronFR, nb_excit.output, sz, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('Firing rate'), ylabel('nb output'),
title('number of excitatory output'),

%FR vs excitatory input
subplot(2,2,2), hold on 
scatter(neuronFR, nb_excit.input, sz, 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('Firing rate'), ylabel('nb input'),
title('number of excitatory input'),


%response tones 
subplot(2,2,3), hold on 

for i=1:length(neuronGroup.output)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpUp(neuronGroup.output{i},:),1),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,labels)
title('on tones up>up - excitatory output')


%response tones 
subplot(2,2,4), hold on 

for i=1:length(neuronGroup.input)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpUp(neuronGroup.input{i},:),1),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,labels)
title('on tones up>up - excitatory input')

