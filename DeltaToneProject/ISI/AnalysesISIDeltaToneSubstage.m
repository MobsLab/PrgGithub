% AnalysesISIDeltaToneSubstage
% 18.02.2017 KJ
%
% Transform data from QuantifISIDeltaToneSubstageNew to be used in plot
%
% Info
%   In this version of QuantifIsiDeltaToneSubstage:
%       - intervals between down/deltas are collected for different conditions
%       - we discriminate tones that induced delta/down or not
%       - we discriminate tones that were triggered by real delta/down or not
%       - sham is included, coming from basal records
%       - data are collected per substage
%
% See
%   QuantifISIDeltaToneSubstageNew FigureISIDeltaToneNREM
%


%load
clear 
% load(fullfile(FolderDeltaDataKJ,'QuantifISIDeltaToneSubstage_all2.mat'))
load(fullfile(FolderDeltaDataKJ,'IsiDeltaCloseLoopDelay.mat'))


%% Params

%nb interval : n+1, n+2, n+3 ...
nb_isi = length(isi_basal_res.isi_basal_delta_substage{1,1});
list_isi = {1,2,3,[2 1],[3 1],[3 2]};

%triggered or not, induced or not
yes=2;
no=1;

%condition 
isi_basal_res.condition=isi_basal_res.manipe;
isi_tone_res.condition=isi_tone_res.manipe;
for p=1:length(isi_tone_res.path)
    if strcmpi(isi_tone_res.manipe{p},'DeltaToneAll')
        isi_tone_res.condition{p} = ['Tone ' num2str(isi_tone_res.delay{p}*1000) 'ms'];
    end
end

conditions = unique([isi_basal_res.condition isi_tone_res.condition]);
animals = unique(isi_basal_res.name);


%% Per nights
for sub=substages_ind
    for cond=1:length(conditions)            
        %Basal records
        if strcmpi(conditions(cond),'Basal')
            for i=1:length(list_isi)
                if length(list_isi{i})==1
                    for p=1:length(isi_basal_res.path)
                        deltas_isi = isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}};
                        nights.isi.all{cond,sub,p,i,1,1} = deltas_isi;
                        nights.isi.median{cond,sub,p,i,1,1} = nanmedian(deltas_isi)/10;
                    end
                else
                    for p=1:length(isi_basal_res.path)
                        deltas_isi1 = isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}(1)};
                        deltas_isi2 = isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}(2)};
                        nights.isi.all{cond,sub,p,i,1,1} = deltas_isi1 - deltas_isi2;
                        nights.isi.median{cond,sub,p,i,1,1} = nanmedian(deltas_isi1 - deltas_isi2)/10;
                    end
                end
                
            end

        % RandomTone and DeltaTone records
        else
            for i=1:length(list_isi)
                if length(list_isi{i})==1
                    for trig=[no yes]
                        for indu=[no yes]
                            for p=1:length(isi_tone_res.path)
                                if strcmpi(isi_tone_res.condition{p},conditions(cond))
                                    deltas_isi = isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}}';
                                    nights.isi.all{cond,sub,p,i,trig,indu} = deltas_isi;
                                    nights.isi.median{cond,sub,p,i,trig,indu} = nanmedian(deltas_isi)/10;
                                end
                            end
                        end
                    end
                else
                    for trig=[no yes]
                        for indu=[no yes]
                            for p=1:length(isi_tone_res.path)
                                if strcmpi(isi_tone_res.condition{p},conditions(cond))
                                    d1 = isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}(1)}';
                                    d2 = isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}(2)}';
                                    nights.isi.all{cond,sub,p,i,trig,indu} = d1 - d2;
                                    nights.isi.median{cond,sub,p,i,trig,indu} = nanmedian(d1 - d2)/10;
                                end
                            end
                        end
                    end
                end
            end

        end
        %
            
    end
end


%% Per mouse
for sub=substages_ind
    for cond=1:length(conditions)
        for m=1:length(animals) 
            
            %Basal records
            if strcmpi(conditions(cond),'Basal')
                for i=1:length(list_isi)
                    if length(list_isi{i})==1
                        deltas_isi = [];
                        for p=1:length(isi_basal_res.path)
                            if strcmpi(isi_basal_res.name{p},animals(m))
                                deltas_isi = [deltas_isi isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}}];
                            end
                        end
                        mouse.isi.all{cond,sub,m,i,1,1} = deltas_isi;
                        mouse.isi.median{cond,sub,m,i,1,1} = nanmedian(deltas_isi)/10;
                    else
                        deltas_isi = [];
                        for p=1:length(isi_basal_res.path)
                            if strcmpi(isi_basal_res.name{p},animals(m))
                                d1 = isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}(1)};
                                d2 = isi_basal_res.isi_basal_delta_substage{p,sub}{list_isi{i}(2)}; 
                                deltas_isi = [deltas_isi d1-d2];
                            end
                        end
                        mouse.isi.all{cond,sub,m,i,1,1} = deltas_isi;
                        mouse.isi.median{cond,sub,m,i,1,1} = nanmedian(deltas_isi)/10;
                    end
                end
                
            % RandomTone and DeltaTone records
            else
                for i=1:length(list_isi)
                    if length(list_isi{i})==1
                        for trig=[no yes]
                            for indu=[no yes]
                                deltas_isi = [];
                                for p=1:length(isi_tone_res.path)
                                    if strcmpi(isi_tone_res.name{p},animals(m)) && strcmpi(isi_tone_res.condition{p},conditions(cond))
                                        deltas_isi = [deltas_isi isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}}'];
                                    end
                                end
                                mouse.isi.all{cond,sub,m,i,trig,indu} = deltas_isi;
                                mouse.isi.median{cond,sub,m,i,trig,indu} = nanmedian(deltas_isi)/10;
                            end
                        end
                    else
                        for trig=[no yes]
                            for indu=[no yes]
                                deltas_isi = [];
                                for p=1:length(isi_tone_res.path)
                                    if strcmpi(isi_tone_res.name{p},animals(m)) && strcmpi(isi_tone_res.condition{p},conditions(cond))
                                        d1 = isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}(1)}';
                                        d2 = isi_tone_res.isi_tone_delta{p,sub}{trig,indu,list_isi{i}(2)}';
                                        deltas_isi = [deltas_isi d1-d2];
                                    end
                                end
                                mouse.isi.all{cond,sub,m,i,trig,indu} = deltas_isi;
                                mouse.isi.median{cond,sub,m,i,trig,indu} = nanmedian(deltas_isi)/10;
                            end
                        end
                    end
                    
                end
                
            end
            %
            
        end
    end
end


%% saving data
cd(FolderDeltaDataKJ)
save AnalysesISIDeltaToneSubstage mouse nights yes no animals conditions substages_ind list_isi




