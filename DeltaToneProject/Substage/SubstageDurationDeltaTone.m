% SubstageDurationDeltaTone
% 29.11.2016 KJ
%
% effect of stimulation on substage duration
%
%   see 
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);


for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'Basal')
        Dir.condition{p} = 'Basal';
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = 'RdmTone';
    elseif strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end 

animals = unique(Dir.name); %Mice
conditions = unique(Dir.condition); %Mice

%params
binsize = 100; %10ms
nbins = 100;
substages_ind = 1:6; %N1, N2, N3, REM, WAKE

for cond = 1:length(conditions)
    for m=1:length(animals)
        
        for sub=substages_ind
            subdur_res.epoch.nb_stim{m,cond,sub} = [];
            subdur_res.epoch.duration{m,cond,sub} = [];
            subdur_res.total.nb_stim{m,cond,sub} = [];
            subdur_res.total.duration{m,cond,sub} = [];
        end
        
        for p=1:length(Dir.path)
            if strcmpi(Dir.name{p},animals{m}) && strcmpi(Dir.condition{p},conditions{cond})
                disp(' ')
                disp('****************************************************************')
                eval(['cd(Dir.path{',num2str(p),'}'')'])
                disp(pwd)
                
                %% load
                %Substages and stages
                clear op NamesOp Dpfc Epoch noise
                load NREMepochsML.mat op NamesOp Dpfc Epoch noise
                disp('Loading epochs from NREMepochsML.m')
                [Substages,NamesSubstages]=DefineSubStages(op,noise);
                
                clear Down DeltaOffline tEvents 
                %Down states
                try
                    load newDownState Down
                catch
                    try
                        load DownSpk Down
                    catch
                        Down = intervalSet([],[]);
                    end
                end
                tdowns = (Start(Down)+End(Down))/2; 
                %Delta waves
                try
                    load DeltaPFCx DeltaOffline
                catch
                    load newDeltaPFCx DeltaEpoch
                    DeltaOffline =  DeltaEpoch; 
                    clear DeltaEpoch
                end
                tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;

                %Tones/Shams
                try
                    load('DeltaSleepEvent.mat', 'TONEtime1')
                    delay = Dir.delay{p}*1E4; %in 1E-4s
                    tones = ts(TONEtime1 + delay);
                catch
                    tones=ts([]);
                end
                nb_tones = length(tones);
                
                
                %% loop over substages
                for sub=substages_ind
                    subdur_res.total.nb_stim{m,cond,sub} = [subdur_res.total.nb_stim{m,cond,sub} length(Restrict(tones,Substages{sub}))];
                    subdur_res.total.duration{m,cond,sub} = [subdur_res.total.duration{m,cond,sub} tot_length(Substages{sub})/1E4];
                    nb_interval = length(Start(Substages{sub}));
                    
                    for i=1:nb_interval
                        sub_substage = subset(Substages{sub},i);
                        subdur_res.epoch.nb_stim{m,cond,sub} = [subdur_res.epoch.nb_stim{m,cond,sub} length(Restrict(tones,sub_substage))];
                        subdur_res.epoch.duration{m,cond,sub} = [subdur_res.epoch.duration{m,cond,sub} tot_length(sub_substage)/1E4];
                    end
                    
                end
                
            end
            
        end
        
        
    end
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save SubstageDurationDeltaTone.mat subdur_res animals conditions substages_ind




