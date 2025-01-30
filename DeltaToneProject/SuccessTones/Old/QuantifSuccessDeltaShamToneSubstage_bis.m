% QuantifSuccessDeltaShamToneSubstage_bis
% 30.11.2016 KJ
%
% transfom data collected by QuantifSuccessDeltaToneSubstage, to be used in
% QuantifSuccessDeltaToneSubstage 2 and plotted
%
%
%   see 
%       QuantifSuccessDeltaToneSubstage QuantifSuccessDeltaShamToneSubstage2
%
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifSuccessDeltaShamToneSubstage_2.mat'])

%params
NameSubstages = {'N1','N2', 'N3','REM','Wake','SWS'}; % Sleep substages
 

%% Sham (Basal)
cond=1;
for sub=substages_ind
        for m=1:length(animals) 
            
            %Init variables
            for d=1:length(delays)
                for trig=1:2
                    for indu=1:2
                        downs.sham.nb(d,sub,m,trig,indu) = 0;
                        deltas.sham.nb(d,sub,m,trig,indu) = 0;
                    end
                end
            end
            epoch_duration(cond,sub,m) = 0;
            
            %loop over record to sum
            for p=1:length(shamsuccess_res.path)
                if strcmpi(shamsuccess_res.name{p},animals(m)) && strcmpi(shamsuccess_res.condition{p}, conditions{cond})
                    epoch_duration(cond,sub,m) = epoch_duration(cond,sub,m) + shamsuccess_res.epoch_duration{p,sub};
                    for d=1:length(delays)
                        for trig=1:2
                            for indu=1:2
                                downs.sham.nb(d,sub,m,trig,indu) = downs.sham.nb(d,sub,m,trig,indu) + shamsuccess_res.sham_down_substage{p,sub,d}{trig,indu};
                                deltas.sham.nb(d,sub,m,trig,indu) = deltas.sham.nb(d,sub,m,trig,indu) + shamsuccess_res.sham_delta_substage{p,sub,d}{trig,indu};
                            end
                        end
                    end
                end
            end
            
            %density
            for d=1:length(delays)
                for trig=1:2
                    for indu=1:2
                        downs.sham.density(d,sub,m,trig,indu) = downs.sham.nb(d,sub,m,trig,indu) / epoch_duration(cond,sub,m);
                        deltas.sham.density(d,sub,m,trig,indu) = deltas.sham.nb(d,sub,m,trig,indu) / epoch_duration(cond,sub,m);
                    end
                end
            end

        end
end


%% Random
cond=2;
for sub=substages_ind
    for m=1:length(animals) 

        %Init variables
        for trig=1:2
            for indu=1:2
                downs.random.nb(sub,m,trig,indu) = 0;
                deltas.random.nb(sub,m,trig,indu) = 0;
            end
        end
        epoch_duration(cond,sub,m) = 0;

        %loop over record to sum
        for p=1:length(tonesuccess_res.path)
            if strcmpi(tonesuccess_res.name{p},animals(m)) && strcmpi(tonesuccess_res.condition{p}, conditions{cond})
                epoch_duration(cond,sub,m) = epoch_duration(cond,sub,m) + tonesuccess_res.epoch_duration{p,sub};
                for trig=1:2
                    for indu=1:2
                        downs.random.nb(sub,m,trig,indu) = downs.random.nb(sub,m,trig,indu) + tonesuccess_res.tone_down_substage{p,sub}{trig,indu};
                        deltas.random.nb(sub,m,trig,indu) = deltas.random.nb(sub,m,trig,indu) + tonesuccess_res.tone_delta_substage{p,sub}{trig,indu};
                    end
                end
            end
        end

        %density
        for trig=1:2
            for indu=1:2
                downs.random.density(sub,m,trig,indu) = downs.random.nb(sub,m,trig,indu) / epoch_duration(cond,sub,m);
                deltas.random.density(sub,m,trig,indu) = deltas.random.nb(sub,m,trig,indu) / epoch_duration(cond,sub,m);
            end
        end
        
    end
end


%% DeltaTone
for cond=3:length(conditions)
    d = cond-2; %delay index
    for sub=substages_ind
        for m=1:length(animals) 

            %Init variables
            for trig=1:2
                for indu=1:2
                    downs.tone.nb(d,sub,m,trig,indu) = 0;
                    deltas.tone.nb(d,sub,m,trig,indu) = 0;
                end
            end
            epoch_duration(cond,sub,m) = 0;

            %loop over record to sum
            for p=1:length(tonesuccess_res.path)
                if strcmpi(tonesuccess_res.name{p},animals(m)) && strcmpi(tonesuccess_res.condition{p}, conditions{cond})
                    epoch_duration(cond,sub,m) = epoch_duration(cond,sub,m) + tonesuccess_res.epoch_duration{p,sub};
                    for trig=1:2
                        for indu=1:2
                            downs.tone.nb(d,sub,m,trig,indu) = downs.tone.nb(d,sub,m,trig,indu) + tonesuccess_res.tone_down_substage{p,sub}{trig,indu};
                            deltas.tone.nb(d,sub,m,trig,indu) = deltas.tone.nb(d,sub,m,trig,indu) + tonesuccess_res.tone_delta_substage{p,sub}{trig,indu};
                        end
                    end
                end
            end

            %density
            for trig=1:2
                for indu=1:2
                    downs.tone.density(d,sub,m,trig,indu) = downs.tone.nb(d,sub,m,trig,indu) / epoch_duration(cond,sub,m);
                    deltas.tone.density(d,sub,m,trig,indu) = deltas.tone.nb(d,sub,m,trig,indu) / epoch_duration(cond,sub,m);
                end
            end

        end
    end
end


%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifSuccessDeltaShamToneSubstage_bis2.mat downs deltas epoch_duration animals conditions substages_ind delays

