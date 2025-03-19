% ParcoursDeltaDetection2


%% Get data

tic
Dir=PathForExperimentsDeltaSleepKJ_062016('basal');

a=1;
saving=0;
toPlot=0;
for i=1:length(Dir.path)
    try
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        disp(num2str(a))
        [met_mua{a}, met_mua_deep{a}, met_mua_sup{a}, tmp{a}, met_lfp{a}, met_lfp_deep{a}, met_lfp_sup{a}, tmp2{a}, nb_delta{a}, nb_delta_deep{a}, nb_delta_sup{a}, nb_down1{a}, nb_down2{a}, mnQ_Down1{a}, tmp_down1{a}, mnQ_stDown1{a}, mnQ_enDown1{a}, mnLFP_Down1{a}, mnLFP_stDown1{a}, mnLFP_enDown1{a}, mnQ_Down2{a}, tmp_down2{a}, mnQ_stDown2{a}, mnQ_enDown2{a}, mnLFP_Down2{a}, mnLFP_stDown2{a}, mnLFP_enDown2{a}, nb_neurons(a)] = DeltaDetectionTh2(saving, toPlot);
        MiceName{a}=Dir.name{i};
        PathOK{a}=Dir.path{i};
        a=a+1;
    catch
        disp(['error with ' Dir.path{i}])
    end
end

toc

% Number of down for the two thresholds
for a=1:length(nb_down1)
nombreDown(a,1) = nb_down1{a};
nombreDown(a,2) = nb_down2{a};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%night_ind = 1:length(nb_down1);
night_ind = [2 4 6 8];


%% MUA and LFP mean curves 
% triggered on deltas detection (several thresholds) and on down states (bold green curve) 

% Diff
figure('color',[1 1 1])
for i=1:length(night_ind)
subplot(2,length(night_ind),i), plot(tmp{i},met_mua{i},'color',[0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08]), hold on, plot(tmp{i},mnQ_Down1{i},'g','linewidth',2)
subplot(2,length(night_ind),i+length(night_ind)), plot(tmp2{i},met_lfp{i},'k'), title(MiceName{i}), hold on, plot(tmp_down1{i},mnLFP_Down1{i},'g','linewidth',2)
end
subplot(2, length(night_ind),1), ylabel('Diff')   
subplot(2, length(night_ind),length(night_ind)+1), ylabel('Diff')


% Deep
figure('color',[1 1 1])
for i=1:length(night_ind)
subplot(2, length(night_ind),i), plot(tmp{i},met_mua_deep{i}, 'color', [0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08])
subplot(2, length(night_ind), i+length(night_ind)), plot(tmp2{i}, met_lfp_deep{i}, 'b'), title(MiceName{i})
end
   
subplot(2, length(night_ind),1), ylabel('Deep')
subplot(2, length(night_ind),length(night_ind)+1), ylabel('Deep')

    
% Sup
figure('color',[1 1 1])
for i=1:length(night_ind)
subplot(2,length(night_ind),i), plot(tmp{i},met_mua_sup{i},'color',[0.7 0.7 0.7]), title(MiceName{i}), yl=ylim; ylim([0 0.08])
subplot(2,length(night_ind),i+length(night_ind)), plot(tmp2{i},met_lfp_sup{i},'r'), title(MiceName{i})
end
subplot(2, length(night_ind),1), ylabel('Sup')
subplot(2, length(night_ind),length(night_ind)+1), ylabel('Sup')


%% MUA minimum for different thresholds and detection

%mua in the center of the curve
figure('color',[1 1 1]), hold on
for i=1:length(night_ind)
subplot(1,3,1), hold on, plot(0.2:0.2:4,met_mua{i}(:,98),'k')
subplot(1,3,2), hold on, plot(0.2:0.2:4,met_mua_deep{i}(:,98),'b')
subplot(1,3,3), hold on, plot(0.2:0.2:4,met_mua_sup{i}(:,98),'r')
end

%mua minimum
figure('color',[1 1 1]), hold on
for i=1:length(night_ind)
subplot(1,3,1), hold on, plot(0.2:0.2:4, min(met_mua{i},[],2), 'k')
subplot(1,3,2), hold on, plot(0.2:0.2:4, min(met_mua_deep{i},[],2), 'b')
subplot(1,3,3), hold on, plot(0.2:0.2:4, min(met_mua_sup{i},[],2), 'r')
end

% fold the number of neurons
figure('color',[1 1 1]), hold on
for i=1:length(night_ind)
subplot(1,3,1), hold on, plot(0.2:0.2:4, nb_neurons(i) * min(met_mua{i},[],2), 'k')
subplot(1,3,2), hold on, plot(0.2:0.2:4, nb_neurons(i) * min(met_mua_deep{i},[],2), 'b')
subplot(1,3,3), hold on, plot(0.2:0.2:4, nb_neurons(i) * min(met_mua_sup{i},[],2), 'r')
end


%% Number of delta and down per seconds
nombreDown(nombreDown(:,1)>2,:)=[];
figure('color',[1 1 1]), hold on
for i=1:length(night_ind)
subplot(1,3,1), hold on, plot(0.2:0.2:4,nb_delta{i},'k'), xl=xlim; line(xl, [nombreDown(:,1) nombreDown(:,1)]','color',[0.7 0.7 0.7])
subplot(1,3,2), hold on, plot(0.2:0.2:4,nb_delta_deep{i},'b'), xl=xlim; line(xl, [nombreDown(:,1) nombreDown(:,1)]','color',[0.7 0.7 0.7])
subplot(1,3,3), hold on, plot(0.2:0.2:4,nb_delta_sup{i},'r'), xl=xlim; line(xl, [nombreDown(:,1) nombreDown(:,1)]','color',[0.7 0.7 0.7])
end




