% QuantifDensityDeltaPerSession_bis
% 18.11.2016 KJ
%
% - Use the data collected in QuantifDensityDeltaPerSession
% - transform them to be used by QuantifDensityDeltaPerSessionPlot
%
% See 
%   QuantifDensityDeltaPerSession QuantifDensityDeltaPerSessionPlot QuantifDensityDeltaPerSession2
%   
%

cd([FolderProjetDelta 'Data/'])
clear 
load QuantifDensityDeltaPerSession.mat

%% Concatenate
animals = unique(deltatone_res.name);
delays = [delays -1];

for p=1:length(deltatone_res.path)
    if strcmpi(deltatone_res.manipe{p},'RdmTone')
        deltatone_res.delay{p} = -1;
    end
end

for sub=substages_ind
    for s=sessions_ind
        for d=1:length(delays)
            for m=1:length(animals)
                
                if delays(d)==0
                    nb_delta = 0;
                    nb_down = 0;
                    duration = 0; %in s
                    density_delta = [];
                    density_down = [];
                    for p=1:length(basal_res.path)
                        if strcmpi(basal_res.name{p},animals(m))
                            nb_delta = nb_delta + basal_res.nb_delta{p,s,sub};
                            nb_down = nb_delta + basal_res.nb_down{p,s,sub};
                            duration = nb_delta + basal_res.duration{p,s,sub};
                            density_delta = basal_res.nb_delta{p,s,sub} / basal_res.duration{p,s,sub};
                            density_down = basal_res.nb_down{p,s,sub} / basal_res.duration{p,s,sub};
                        end
                    end
                    perioduration.total(d,s,sub,m) = duration;
                    deltas.total.nb(d,s,sub,m) = nb_delta;
                    deltas.total.density(d,s,sub,m) = nb_delta/duration;
                    deltas.median.density(d,s,sub,m)= median(density_delta(density_delta>0));
                    downs.total.nb(d,s,sub,m) = nb_down;
                    downs.total.density(d,s,sub,m) = nb_down/duration;
                    downs.median.density(d,s,sub,m)= median(density_down(density_down>0));
                                        
                else
                    nb_delta = 0;
                    nb_down = 0;
                    duration = 0; %in s
                    for p=1:length(deltatone_res.path) 
                        if deltatone_res.delay{p}==delays(d) && strcmpi(deltatone_res.name{p},animals(m))
                            nb_delta = nb_delta + deltatone_res.nb_delta{p,s,sub};
                            nb_down = nb_delta + deltatone_res.nb_down{p,s,sub};
                            duration = nb_delta + deltatone_res.duration{p,s,sub};
                            density_delta = deltatone_res.nb_delta{p,s,sub} / deltatone_res.duration{p,s,sub};
                            density_down = deltatone_res.nb_down{p,s,sub} / deltatone_res.duration{p,s,sub};
                        end
                    end
                    perioduration.total(d,s,sub,m) = duration;
                    deltas.total.nb(d,s,sub,m) = nb_delta;
                    deltas.total.density(d,s,sub,m) = nb_delta/duration;
                    deltas.median.density(d,s,sub,m)= median(density_delta(density_delta>0));
                    downs.total.nb(d,s,sub,m) = nb_down;
                    downs.total.density(d,s,sub,m) = nb_down/duration;
                    downs.median.density(d,s,sub,m)= median(density_down(density_down>0));
                end

            end
        end
    end
end

clear sub d p m s
clear nb_delta nb_down duration density_delta density_down
clear deltatone_res basal_res

save QuantifDensityDeltaPerSession_bis animals delays deltas downs perioduration sessions_ind substages_ind
