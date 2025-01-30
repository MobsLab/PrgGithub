% QuantifISIDeltaToneSubstage6
% 24.11.2016 KJ
%
% bar plot (median, mode) for several conditions and substages.
% Mice are represented with dots, stats are done over mice (use of plotErrorBarN) 
%
% Info
%   In this version of QuantifIsiDeltaToneSubstage:
%       - intervals between down/deltas are collected for basal/random/deltatone
%       - we discriminate tones that induced delta/down or not
%       - we discriminate tones that were triggered by real delta/down or not
%       - sham is included, coming from basal records
%       - data are collected per substage
%
% INPUT :
%   figure_numbers:     int or list - the figures to plot
%
%                       1 : Figure1 - delta-triggered tones
%                       2 : Figure2 - Non delta-triggered tones
%                       3 : Figure3 - delta-triggered tones with sham
%                       4 : Figure4 - non-delta-triggered tones with sham
%                       5 : Figure5 - Success tones
%                       6 : Figure6 - Failed tones
% 
%   show_sig:           string - which stat are displayed
%                       (default 'none') 'none' for no stat, 'ns' for only non significant, 
%                       'sig' for only significant, 'all' for all stat
% 
%   optiontest:         string - which test for the stat
%                       (default ranksum) 'ttest' , 'ranksum'
% 
% See
%   QuantifISIDeltaToneSubstage QuantifISIDeltaToneSubstage_bis
%

function QuantifISIDeltaToneSubstage6(figure_numbers, varargin)

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'show_sig',
            show_sig = varargin{i+1};
            if ~isstring(show_sig, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''show_sig''.');
            end
        case 'optiontest',
            optiontest = varargin{i+1};
            if ~isstring(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
            otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%load
eval(['load ' FolderProjetDelta 'Data/QuantifISIDeltaToneSubstage_bis.mat'])


%params
NameSubstages = {'N1','N2', 'N3','REM','Wake'}; % Sleep substages
NameSessions = {'S1','S2','S3','S4','S5'};
NameConditions = {'Basal','140ms','200ms','320ms','490ms','Random','Sham 140ms','Sham 200ms','Sham 320ms','Sham 490ms'};
if ~exist('show_sig','var')
    show_sig = 'none';
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos_delays = delays(delays>0);
figtypes = {'Median'}; % stats
substages_plot = 2:3;


%% Figure1 - delta-triggered tones
if ismember(1,figure_numbers)

    maintitle = 'ISI for delta-triggered tones';
    labels={'Basal n+1','Basal n+2','Basal n+3','Success Tones n+1','Success Tones n+2','Success Tones n+3','Failed Tones n+1','Failed Tones n+2','Failed Tones n+3'};
    bar_color={'k','k','k','b','b','b','r','r','r'};
    noncolumntest = [1 2;1 3;2 3;4 5;4 6;5 6;7 8;7 9;8 9]; 
    nb_isi = 1:3;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,no)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end


%% Figure2 - Non delta-triggered tones
elseif ismember(2,figure_numbers)

    maintitle = 'ISI for non-delta-triggered tones';
    labels={'Basal n+1','Basal n+2','Basal n+3','Success Tones n+1','Success Tones n+2','Success Tones n+3','Failed Tones n+1','Failed Tones n+2','Failed Tones n+3'};
    bar_color={'k','k','k','b','b','b','r','r','r'};
    noncolumntest = [1 2;1 3;2 3;4 5;4 6;5 6;7 8;7 9;8 9]; 
    nb_isi = 1:3;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,no)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end


%% Figure3 - delta-triggered tones with sham
elseif ismember(3,figure_numbers) 
    
    maintitle = 'ISI for delta-triggered tones';
    labels={'Basal n+1','Basal n+2','Success Tones n+1','Success Tones n+2','Failed Tones n+1','Failed Tones n+2', 'Success Sham n+1','Success Sham n+2','Failed Sham n+1','Failed Sham n+2'};
    bar_color={'k','k','b','b','r','r','b','b','r','r'};
    noncolumntest = [1 2;3 4;5 6;7 8;9 10];
    nb_isi = 1:2;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_sham = delays==-conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,no)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,yes,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,yes,no)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end


%% Figure4 - non-delta-triggered tones with sham
elseif ismember(4,figure_numbers)     
    
    maintitle = 'ISI for non-delta-triggered tones';
    labels={'Basal n+1','Basal n+2','Success Tones n+1','Success Tones n+2','Failed Tones n+1','Failed Tones n+2', 'Success Sham n+1','Success Sham n+2','Failed Sham n+1','Failed Sham n+2'};
    bar_color={'k','k','b','b','r','r','b','b','r','r'};
    noncolumntest = [1 2;3 4;5 6;7 8;9 10];
    nb_isi = 1:2;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_sham = delays==-conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,no)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,no,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,no,no)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end
    
%% Figure5 - Success tones with sham
elseif ismember(5,figure_numbers) 
    
    maintitle = 'ISI for success tones';
    labels={'Basal n+1','Basal n+2','Delta-trig Tones n+1','Delta-trig Tones n+2','Non-delta-trig Tones n+1','Non-delta-trig Tones n+2', 'Delta-trig Sham n+1','Delta-trig Sham n+2','Non-delta-trig Sham n+1','Non-delta-trig Sham n+2'};
    bar_color={'k','k','b','b','r','r','b','b','r','r'};
    noncolumntest = [1 2;3 4;5 6;7 8;9 10];
    nb_isi = 1:2;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_sham = delays==-conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,yes,yes)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,no,yes)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end

    
%% Figure6 - Failed tones with sham
elseif ismember(6,figure_numbers) 
    
    maintitle = 'ISI for failed tones';
    labels={'Basal n+1','Basal n+2','Delta-trig Tones n+1','Delta-trig Tones n+2','Non-delta-trig Tones n+1','Non-delta-trig Tones n+2', 'Delta-trig Sham n+1','Delta-trig Sham n+2','Non-delta-trig Sham n+1','Non-delta-trig Sham n+2'};
    bar_color={'k','k','b','b','r','r','b','b','r','r'};
    noncolumntest = [1 2;3 4;5 6;7 8;9 10];
    nb_isi = 1:2;

    %Delta
    for conditions=pos_delays
        d_tone = delays==conditions;
        d_sham = delays==-conditions;
        d_basal = delays==0;
        figure, hold on
        for sbp=1:length(substages_plot)
            sub=substages_plot(sbp);

            %data
            data=[];
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,no)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,no,no)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,yes,no)))];
            end
            for i=nb_isi
                data=[data squeeze(cell2mat(deltas.isi.median(d_sham,sub,:,i,no,no)))];
            end

            %subplot
            subplot(1,length(substages_plot),sbp), hold on,
                PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
            title([NameSubstages{sub}]), ylabel('ms'), hold on,
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([maintitle ' - ' num2str(conditions*1000) 'ms'],'t');
    end
    
end %end if

end %end function
