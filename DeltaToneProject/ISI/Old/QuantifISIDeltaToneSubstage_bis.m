% QuantifISIDeltaToneSubstage_bis
% 24.11.2016 KJ
%
% Transform data from QuantifISIDeltaToneSubstage to be used in plot
%
% Info
%   In this version of QuantifIsiDeltaToneSubstage:
%       - intervals between down/deltas are collected for basal/random/deltatone
%       - we discriminate tones that induced delta/down or not
%       - we discriminate tones that were triggered by real delta/down or not
%       - sham is included, coming from basal records
%       - data are collected per substage
%
% See
%   QuantifISIDeltaToneSubstage
%


%load
cd([FolderProjetDelta 'Data/'])
clear 
load QuantifISIDeltaToneSubstage_all2.mat 

%% Params
animals = unique(quantif_isi_basal_res.name);

%delays
delays = [delays -1];
for p=1:length(quantif_isi_tone_res.path)
    if strcmpi(quantif_isi_tone_res.manipe{p},'RdmTone')
        quantif_isi_tone_res.delay{p} = -1;
    end
end
delays = [delays -quantif_isi_sham_res.delay];

%nb interval : n+1, n+2, n+3 ...
nb_isi = length(quantif_isi_basal_res.isi_basal_delta_substage{1,1});

%triggered or not, induced or not
yes=2;
no=1;


%% Concatenate

for sub=substages_ind
    for d=1:length(delays)
        dltone_delay.delay{d,sub} = delays(d);
        for m=1:length(animals) 
            
            %Basal records
            if delays(d)==0
                for i=1:nb_isi
                    deltas_isi = [];
                    downs_isi = [];
                    for p=1:length(quantif_isi_basal_res.path)
                        if strcmpi(quantif_isi_basal_res.name{p},animals(m))
                            deltas_isi = [deltas_isi quantif_isi_basal_res.isi_basal_delta_substage{p,sub}{i}];
                            downs_isi = [downs_isi quantif_isi_basal_res.isi_basal_down_substage{p,sub}{i}];
                        end
                    end
                    deltas.isi.all{d,sub,m,i,1,1} = deltas_isi;
                    downs.isi.all{d,sub,m,i,1,1} = downs_isi;
                    deltas.isi.median{d,sub,m,i,1,1} = nanmedian(deltas_isi)/10;
                    downs.isi.median{d,sub,m,i,1,1} = nanmedian(downs_isi)/10;
                end
                
            % RandomTone and DeltaTone records
            elseif delays(d)>0 || delays(d)==-1 
                for i=1:nb_isi
                    for trig=[no yes]
                        for indu=[no yes]
                            deltas_isi = [];
                            downs_isi = [];
                            for p=1:length(quantif_isi_tone_res.path)
                                if quantif_isi_tone_res.delay{p}==delays(d) && strcmpi(quantif_isi_tone_res.name{p},animals(m))
                                    deltas_isi = [deltas_isi quantif_isi_tone_res.isi_tone_delta{p,sub}{trig,indu,i}'];
                                    downs_isi  = [downs_isi quantif_isi_tone_res.isi_tone_down{p,sub}{trig,indu,i}'];
                                end
                            end
                            deltas.isi.all{d,sub,m,i,trig,indu} = deltas_isi;
                            downs.isi.all{d,sub,m,i,trig,indu} = downs_isi;
                            deltas.isi.median{d,sub,m,i,trig,indu} = nanmedian(deltas_isi)/10;
                            downs.isi.median{d,sub,m,i,trig,indu}  = nanmedian(downs_isi)/10;
                        end
                    end
                    
                end
                
            % Sham Records, with multiple delay
            elseif delays(d)<0 && delays(d)~=-1
                ind_delay = find(quantif_isi_sham_res.delay==-delays(d));
                for i=1:nb_isi
                    for trig=[no yes]
                        for indu=[no yes]
                            deltas_isi = [];
                            downs_isi = [];
                            for p=1:length(quantif_isi_sham_res.path)
                                if strcmpi(quantif_isi_sham_res.name{p},animals(m)) 
                                    deltas_isi = [deltas_isi quantif_isi_sham_res.isi_sham_delta{p,sub,ind_delay}{trig,indu,i}'];
                                    downs_isi  = [downs_isi quantif_isi_sham_res.isi_sham_down{p,sub,ind_delay}{trig,indu,i}'];
                                end
                            end
                            deltas.isi.all{d,sub,m,i,trig,indu} = deltas_isi;
                            downs.isi.all{d,sub,m,i,trig,indu} = downs_isi;
                            deltas.isi.median{d,sub,m,i,trig,indu} = nanmedian(deltas_isi)/10;
                            downs.isi.median{d,sub,m,i,trig,indu}  = nanmedian(downs_isi)/10;
                        end
                    end
                    
                end
            end
        end
    end
end

save QuantifISIDeltaToneSubstage_bis downs deltas delays yes no animals substages_ind







