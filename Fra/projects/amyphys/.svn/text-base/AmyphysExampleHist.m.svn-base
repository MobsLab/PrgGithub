function A = AmyphysExampleHist(A)

do_figures = false;

[A, cn] = getResource(A, 'AmygdalaCellList');
A = getResource(A, 'Experiment');
experiment = experiment{1};

A = getResource(A, 'VisualCountsTotal');

A = getResource(A, 'StimCode');

A = getResource(A, 'FRateBaseline');

A = getResource(A, 'AmygdalaCellList');

load AmyphysLookupTables

for i = 1:15
    stim{i} = [i (i +30)]; % these are the monkeys, merging the rewarded and unrewarded trials
end

for i = 16:20
    stim{i} = i+5; % the humans
end

for i = 21:25
    stim{i} = i - 5;
end

for i = 26:30 
    stim{i} = i;
end


%for phys 1 the order is monkey(neutral, lipsmack, threat), then human,
%then animal, then object
phys1_stim = [1,4,7,10,13,16,19,22,25,28, 2,5,8,11,14,17,20,23,26,29,3,6,9,12,15,18,21,24,27,30];
phys1_stim = [phys1_stim (41:50) (51:60) (31:40)];
                        % monkey        human anim.     obj.

% for phys 2 the order is monkey(fullbody, neutral, lipsmack, mild threat, strong threat) the human then object                        
phys2_stim = [1,6,11,16,21,26,30,35, 3,8,13,18,23,56,32,37,2,7,12,17,22,27,31,36,4,9,15,19,24,28,33,39,5,10,14,20,25,29,34,38];
 %                         (---fullbody---------)(----neutral---------)(----lipsmack------)  (--m. threat--------)  (----s. threat--------)

 phys2_stim = [phys2_stim, 40,41,42,43,44,45,54,55, 46,47,48,49,50,51,52,53];
 %                        (monkey--)   (---human-----------)     (----objects----------)

 
 global FIGURE_DIR;
fig_st = {};

FIGURE_DIR = [getenv('HOME') filesep 'Data' filesep 'amyphys'];


fig_st = {};
if strcmp(experiment, 'amyphys')
    ;
elseif strcmp(experiment, 'phys1')
    stim = phys1_stim;
    for i = 1:length(stim)
        st{i} = stim(i);
    end
    stim = st;
elseif strcmp(experiment, 'phys2')
    stim = phys2_stim;
    for i = 1:length(stim)
        st{i} = stim(i);
    end
    stim = st;
end


    
    
    
 


for i = 1:length(cn)
    
    
    

        fprintf(1, 'doing cell %s\n', cn{i})

        tr = visCountsTotal{i};
        sc = Data(stimCode{i});

        close all
        global N_FIGURE;
        
        for m = 1:length(stim)
            ix = find(ismember(sc, stim{m}));
            mtr(m) = mean(tr(ix));
            str(m) = sem(tr(ix));
        end
        
        fig=[];
        fig.figureType = 'histerror';
        fig.x = (1:length(stim));
        fig.n = mtr';
        fig.e = str';
        fig.figureName = [cn{i} '_total'];
        fig.noXTick = 1;
        fig.eBarsOnTop = 1;
        fig_st = [fig_st {  fig }];

    
end

if ~isempty(fig_st)
    makeFigure(fig_st);
end



