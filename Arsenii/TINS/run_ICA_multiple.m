

%variables
numtemplates = 9;   %number of templates for PCA and to run ICA on; check they explain more than 50%variance
nmice=[1162]; % 1199 vs 1168 vs 1161 vs 1162
experiment = "PAG";
TemplatePeriod = {'cond'}; % 'wake' 'cond', 'condFree', 'postRip', 'condRip'
binsize = 250;  %0.1*1e4 = 100 ms
issavefig = 1;    %to save fig put 1
multiU = 'D'; % 'D' for delete or 'K' for keep    /!\MultiUNeurons are not the same for all mice
interN = 'D';
n_ICA = 4; %number of times to run ICA
issaveweight = 0;

close all;

%allocation
ICAtemplates = cell(1, 1); % ICA weight matrix (1/ iteration)
correl_mat = cell(1,1);  % correlation matrix between ICA weights matrix between iterations
similar_IC = cell(1,1);

PCAtemplates = cell(1, 1);

%code
row = strings([1, numtemplates]);
row_P  = strings([1, numtemplates]);
for nPC_ICA = 1:numtemplates
    row(nPC_ICA) = strjoin({'ICA' num2str(nPC_ICA)});
    row_P(nPC_ICA) = strjoin({'PCA' num2str(nPC_ICA)});
end

for i=1:n_ICA
    [PCAtemp, s_PCA] = react_pca_ica_MM(nmice, experiment, TemplatePeriod{1}, numtemplates, multiU, "PCA", interN, issaveweight,  'binsize', binsize, 'issavefig', issavefig);
    PCAtemp = [PCAtemp{:}];
    PCAtemplates{1}{i} = PCAtemp(:,1:numtemplates);

    %run ICA and keep same number of templates
    [ICAtemp, s_ICA] = react_pca_ica_MM(nmice, experiment, TemplatePeriod{1}, numtemplates, multiU, "ICA", interN, issaveweight, 'binsize', binsize, 'issavefig', issavefig);
    ICAtemp = [ICAtemp{:}];
    ICAtemplates{1}{i} = ICAtemp;

    %Calculates correlations between ICA and PCA compnents
    PC_correl = zeros(numtemplates);

    for nPC_PCA = 1:numtemplates
        for nPC_ICA = 1:numtemplates
            A = corrcoef(PCAtemp(:,nPC_PCA), ICAtemp(:, nPC_ICA));
            PC_correl(nPC_PCA, nPC_ICA) = A(1,2);
        end
    end

    figure
    imagesc(PC_correl)
    set(gca,'Xtick',1:numtemplates,'XTickLabel',row);
    set(gca, 'Ytick', 1:numtemplates, 'YtickLabel', row_P);
    caxis([-1 1]);
    colormap jet;
    colorbar('XTick', -1:0.1:1);
    textStrings = num2str(PC_correl(:), '%0.2f');       % Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));
    [x, y] = meshgrid(1:numtemplates);  % Create x and y coordinates for the strings
    hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                    'HorizontalAlignment', 'center');
    title("Correlation between ICA and PCA components");
    
    if issavefig == 1
         saveas(gcf, ['It' num2str(i) '_PCA_ICA_Correlations' nmice(1) '_templateEpoch_' TemplatePeriod{1} '.png']);
         saveas(gcf, ['It' num2str(i) '_PCA_ICA_Correlations' nmice(1) '_templateEpoch_' TemplatePeriod{1}  '.svg']);
    end

end

rb = [];
somme = (n_ICA-1)*(n_ICA)/2;
if mod(somme,3) == 0
    sb = somme/3;
else
    sb= floor(somme/3) +1;
end

index = 0; 

figure
for i=1:n_ICA      % go over ICA iteration
    for j=(i+1):n_ICA  % only use upper ICA iteration matrix for correlations 
        index = index + 1;
        A = corr(ICAtemplates{1}{i}, ICAtemplates{1}{j});    % calc correlations
        correl_mat{i,j} = A;     % stock correlation matrix
        
        subplot(sb, 3, index)
        imagesc(A)
        set(gca,'Xtick',1:numtemplates,'XTickLabel',row);
        set(gca, 'Ytick', 1:numtemplates, 'YtickLabel', row);
        caxis([-1 1]);
        colormap jet;
        colorbar;
        title(['Correlation between It' num2str(i) 'and It' num2str(j)]);
        hold on

        for elem = 1:numtemplates      % go over number of templates - size of A
            [~, idx_col] = max(abs(A(elem,:)));     %check what element of j-iteration has highest correlatio with elem of i-iteration
            [~, idx_row] = max(abs(A(:,idx_col)));      % check what element of i-iteration has highest correlation with previsously identified element of j-iteration         
            if idx_row == elem      % if they are rbh
                val = A(idx_row , idx_col);       % get correlation value
                name = ['It' num2str(i) '-IC' num2str(elem) ' & It' num2str(j) '-IC' num2str(idx_col)];   
                first = num2str(i) +  "-" + num2str(elem);
                second = num2str(j) +  "-" + num2str(idx_col);
                rb = [rb; {name, first, second, val}];   % add charactertistics of this to rbh file
            end
        end

    end
end

    if issavefig == 1
         saveas(gcf, ['Correlation between ICA iteration_mice_' nmice(1) '_templateEpoch_' TemplatePeriod{1} '.png']);
         saveas(gcf, ['Correlation between ICA iteration_mice_' nmice(1) '_templateEpoch_' TemplatePeriod{1} '.svg']);
    end


index = 0; 
t_mat = cell(1,1);

figure
for i=1:n_ICA      % go over ICA iteration
    C = corr(PCAtemplates{1}{i}, ICAtemplates{1}{i});
    t_mat{1}{i} = C;
    for j=(i+1):n_ICA  % only use upper ICA iteration matrix for correlations 
        index = index + 1;

        B = corr(PCAtemplates{1}{i}, PCAtemplates{1}{j});    % calc correlations
        
        subplot(sb, 3, index)
        imagesc(B)
        set(gca,'Xtick',1:numtemplates,'XTickLabel',row_P);
        set(gca, 'Ytick', 1:numtemplates, 'YtickLabel', row_P);
        caxis([-1 1]);
        colormap jet;
        colorbar;
        title(['PCA - Correlation between It' num2str(i) 'and It' num2str(j)]);
        hold on
    end
end

%{

for i=1:numtemplates
    target = "1-" +  num2str(i);   %for all components of the first iteration
    [r, c] = find(strcmp(target, rb));      %look for all its appearance in the rbh file
    tp = rb(r,3);   %get all associated PCs
    tp = [target ; tp];
    if size(tp) ~= n_ICA
        disp('Error identifying 1 rbh in all iterations');
    else
        for element=2:size(tp,1)    %for all associated PCs
            [r_bis, c_bis] = find(strcmp(tp(element), rb));     %check what they are associated to 
            tp_bis =  rb(r_bis,3);
            if sum(ismember(tp_bis,tp)) ~= size(tp_bis)     %check if they are all already identified as associated with component of first iteration to create a closed loop of components
                disp("Error in identififcation of similar vectors");            
            end
        end
    end
    similar_IC{1}{i} = tp;    %create an array containing all associated neurons
end

n_Neurons = size(ICAtemplates{1}{1},1);   %number of neurons
m_W = zeros(n_Neurons, numtemplates);   %allocate space for mean of each IC community

for group=1:size(similar_IC{1})
    mean_W = zeros(n_Neurons,1) ;
    for compo=1:size(similar_IC{1}{group})
        It = split(similar_IC{1}{group}(compo), '-');
        IC_compo = str2double(It(2));
        It = str2double(It(1));
        mean_W = mean_W + ICAtemplates{1}{It}(:,IC_compo)
    end
    mean_W = mean_W/n_IC;
    disp(size(mean_W))
    m_W(:,compo) = mean_W;  
end

close all;


%}


%{
ICAtemp = array2table(ICAtemp, 'VariableNames', col, 'RowNames',row );

    filename = ['Weights_iteration' num2str(i) '_S.xls'];
    writetable(ICAtemp,filename,'Sheet',1,'Range','A1', 'WriteRowNames',true, 'WriteMode', 'overwrite');
    row = strseq('n',[1:1:size(ICAtemp, 1)]);
%}