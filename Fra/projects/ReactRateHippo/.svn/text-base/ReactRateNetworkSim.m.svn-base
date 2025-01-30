function ReactRateNetworkSim(synMatrixType, eh)


baselineFilename = 's2n2000p100baseline';
nSim = 2;

% number of neurons 
N = 2000;

%gain 
G = 4 *ones(N,1);
Hnorm = 0.3;
fixAct = 2;
threshold = 1 * ones(N,1);
crit = 0.01;
maxIter = 300;
nTrials = 500;
plotTimeCourse = false;
doSparse = true;
dT = 1;
enh = 0.1;
GEnh = 0.2;
thrEnh = 0.4;
tau = 10;
Ci = exp(-dT/tau);
CiM = 1 - Ci;
ptEnh = 0;
patternCompEnh = [];
baselineCompEnhRate = [];
baselineCompEnhRateStd = [];
baselineCorrCompEnh = [];

%synMatrixType = 'PartExcEnhance';
%synMatrixType = 'Hopfield';



% prepare the matrix of synaptic connections 


switch synMatrixType

    case 'SynEnhance'
        enh= eh;
        
        load(baselineFilename);

        N = size(patterns,1);
        nPatterns = size(patterns,2);
        
 
        
        
        % find a pattern that was ranking in the middle, not the most retrieved
        % nor the least

        [mxo, mxpt] = (max(overlaps));
        h = hist(mxpt, 1:nPatterns);
        [h, ix] = sort(h);
        ptEnh   = ix(ceil(nPatterns *  0.6));
        patternEnh = patterns(:,ptEnh);
        patternEnh = find(patternEnh);
        
        
        % compute measures for react "sleep 1" situtation
        unEnh = setdiff(1:N, patternEnh); % the "non=enhanced" units
        baselineEnhRate = mean(vFinal(patternEnh,:), 2);
        baselineEnhRateStd = std(vFinal(patternEnh,:), [], 2);
        baselineUnEnhRate = mean(vFinal(unEnh,:), 2);
        baselineUnEnhRateStd = std(vFinal(unEnh,:), [], 2);
        % get the correlation between cells that are "enhanced" and "not
        % enhanced"
                
        [A,B] = meshgrid(1:N, 1:N);
        ixEnh = find(A > B & ismember(A, patternEnh) ...
            & ismember(B, patternEnh));
        ixUnEnh = find(A > B & ismember(A, unEnh) ...
            & ismember(B, unEnh));
        clear A B
        cc = corrcoef(vFinal');
        baselineCorrEnh = cc(ixEnh);
        baselineCorrUnEnh = cc(ixUnEnh);
        clear cc ixEnh ixUnEnh
        
        
        
        
        
        nActive = length(patternEnh);
        sparseness = nActive/N;
        
        jI = zeros(nActive*nActive, 1);
        jJ = zeros(nActive*nActive, 1);
        jS = (enh/ (sparseness ^ 2 * nPatterns * N)) * ones(nActive * nActive, 1);

        offset = 0;
        patt = patternEnh;
        ptI = repmat(patt, nActive, 1);
        ptI = ptI(:);
        jI((offset+1): (offset+length(ptI))) = ptI;
        ptJ = repmat(patt, 1, nActive);
        ptJ =ptJ';
        jJ((offset+1): (offset+length(ptI))) = ptJ;
        Jenh = sparse(jI, jJ, jS, N, N);
        fprintf('synaptically enhancing patten %d\n', ptEnh);
        Jij = Jij + Jenh;
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(enh*100) 'synenh.mat'];
        % compute measures for react "sleep 1" situtation
        unEnh = setdiff(1:N, patternEnh); % the "non=enhanced" units
        baselineEnhRate = mean(vFinal(patternEnh,:), 2);
        baselineEnhRateStd = std(vFinal(patternEnh,:), [], 2);
        baselineUnEnhRate = mean(vFinal(unEnh,:), 2);
        baselineUnEnhRateStd = std(vFinal(unEnh,:), [], 2);
        % get the correlation between cells that are "enhanced" and "not
        % enhanced"
                
        [A,B] = meshgrid(1:N, 1:N);
        ixEnh = find(A > B & ismember(A, patternEnh) ...
            & ismember(B, patternEnh));
        ixUnEnh = find(A > B & ismember(A, unEnh) ...
            & ismember(B, unEnh));
        clear A B
        cc = corrcoef(vFinal');
        baselineCorrEnh = cc(ixEnh);
        baselineCorrUnEnh = cc(ixUnEnh);
        baselineCorrM = cc;
        
     case 'ExcEnhance'
         thrEnh = eh;
        load(baselineFilename);

        N = size(patterns,1);
        nPatterns = size(patterns,2);
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(thrEnh*100) 'excenh.mat'];

 
        
        
        % find a pattern that was ranking in the middle, not the most retrieved
        % nor the least

        [mxo, mxpt] = (max(overlaps));
        h = hist(mxpt, 1:nPatterns);
        [h, ix] = sort(h);
        ptEnh   = ix(ceil(nPatterns *  0.6));
        patternEnh = patterns(:,ptEnh);
        patternEnh = find(patternEnh);
        fprintf('excitability enhancing patten %d\n', ptEnh);

        
        % compute measures for react "sleep 1" situtation
        unEnh = setdiff(1:N, patternEnh); % the "non=enhanced" units
        baselineEnhRate = mean(vFinal(patternEnh,:), 2);
        baselineEnhRateStd = std(vFinal(patternEnh,:), [], 2);
        baselineUnEnhRate = mean(vFinal(unEnh,:), 2);
        baselineUnEnhRateStd = std(vFinal(unEnh,:), [], 2);
        % get the correlation between cells that are "enhanced" and "not
        % enhanced"
                
        [A,B] = meshgrid(1:N, 1:N);
        ixEnh = find(A > B & ismember(A, patternEnh) ...
            & ismember(B, patternEnh));
        ixUnEnh = find(A > B & ismember(A, unEnh) ...
            & ismember(B, unEnh));
        clear A B
        cc = corrcoef(vFinal');
        baselineCorrEnh = cc(ixEnh);
        baselineCorrUnEnh = cc(ixUnEnh);
        baselineCorrM = cc;
        
        clear cc ixEnh ixUnEnh
        
        %G(patternEnh) = G(patternEnh) * (1+GEnh);
        threshold(patternEnh) = threshold(patternEnh) * (1-thrEnh);
        
        
        nActive = length(patternEnh);
        sparseness = nActive/N;   
        
        
      case 'PartExcEnhance'
          
        thrEnh = eh;  
        load(baselineFilename);

        N = size(patterns,1);
        nPatterns = size(patterns,2);
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(thrEnh*100) 'pexcenh.mat'];

 
        
        
        % find a pattern that was ranking in the middle, not the most retrieved
        % nor the least

        [mxo, mxpt] = (max(overlaps));
        h = hist(mxpt, 1:nPatterns);
        [h, ix] = sort(h);
        ptEnh   = ix(ceil(nPatterns *  0.6));
        patternEnh = patterns(:,ptEnh);
        patternEnh = find(patternEnh);
        fprintf('excitability enhancing patten %d\n', ptEnh);

        
        
        % compute measures for react "sleep 1" situtation
        
        unEnh = setdiff(1:N, patternEnh); % the "non=enhanced" units
        lx = floor(length(patternEnh)/2);
        patternCompEnh = patternEnh(lx+1:end);
        patternEnh = patternEnh(1:lx);
        
        
        
        
        baselineEnhRate = mean(vFinal(patternEnh,:), 2);
        baselineEnhRateStd = std(vFinal(patternEnh,:), [], 2);
        baselineCompEnhRate = mean(vFinal(patternCompEnh,:), 2);
        baselineCompEnhRateStd = std(vFinal(patternCompEnh,:), [], 2);
        baselineUnEnhRate = mean(vFinal(unEnh,:), 2);
        baselineUnEnhRateStd = std(vFinal(unEnh,:), [], 2);
        % get the correlation between cells that are "enhanced" and "not
        % enhanced"
                
        [A,B] = meshgrid(1:N, 1:N);
        ixEnh = find(A > B & ismember(A, patternEnh) ...
            & ismember(B, patternEnh));
        ixCompEnh = find(A > B & ismember(A, patternCompEnh) ...
            & ismember(B, patternCompEnh));
        ixUnEnh = find(A > B & ismember(A, unEnh) ...
            & ismember(B, unEnh));
        clear A B
        cc = corrcoef(vFinal');
        baselineCorrEnh = cc(ixEnh);
        baselineCorrCompEnh = cc(ixCompEnh);
        baselineCorrUnEnh = cc(ixUnEnh);
        baselineCorrM = cc;
        clear cc ixEnh ixCompEnh ixUnEnh
        
        %G(patternEnh) = G(patternEnh) * (1+GEnh);
        threshold(patternEnh) = threshold(patternEnh) * (1-thrEnh);
        
        
        
        
        

        
    case 'Load'

        
    
    
        nActive = floor(sparseness * N);
        load Synapse
    
    case 'Hopfield'
        nPatterns = 100;
        sparseness = 0.05;
        patterns = zeros(N, nPatterns);
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'baseline.mat'];

        nActive = floor(sparseness * N);
        jI = zeros(nPatterns *nActive*nActive, 1);
        jJ = zeros(nPatterns *nActive*nActive, 1);
        jS = (1 / (sparseness ^ 2 * nPatterns * N)) * ones(nPatterns * nActive * nActive, 1);

        offset = 0;

        if doSparse
            for i = 1:nPatterns
                patt = randperm(N);
                patt = patt(1:nActive);
                patt = (sort(patt));
                ptI = repmat(patt, nActive, 1);
                ptI = ptI(:);
                jI((offset+1): (offset+length(ptI))) = ptI;
                ptJ = repmat(patt, 1, nActive);
                ptJ =ptJ';
                jJ((offset+1): (offset+length(ptI))) = ptJ;
                offset = offset + length(ptI);
                patt = patt';
                zp = zeros(N,1);
                zp(patt) = 1;
                patterns(:,i) = zp;
            end
            Jij = sparse(jI, jJ, jS, N, N);
        else
            Jij = zeros(N,N);
            for i = 1:nPatterns
                patt = randperm(N);
                patt = patt(1:nActive);
                patt = (sort(patt));
                patt = patt';
                zp = zeros(N,1);
                zp(patt) = 1;
                patterns(:,i) = zp;
                Jij = Jij + zp * zp';
            end
            for i = 1:N
                Jij(i,i) = 0;
            end
            Jij = Jij * (1 / (sparseness ^ 2 * nPatterns * N));
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'baseline.mat'];

        end

        save Synapse Jij patterns
    case 'RandomExp' 
        C = 0.1;
        nSyn = N * N * C;
        
        jI = floor(N * rand(nSyn, 1));
        jJ = floor(N * rand(nSyn, 1));  
        jS = (1 / (N * C)) * ones(nSyn, 1);
        
        Jij = sparse(jI, jJ, jS, N, N);
        save Synapse Jij
end


% put the diagonal terms to zero
for i = 1:N
    Jij(i, i) = 0;
end



nPatterns = size(patterns,2);


Vi = zeros(N, 1);
Viold = zeros(N, 1);

overlaps = zeros(nPatterns, nTrials);
vFinal = zeros(N, nTrials);

for nt = 1:nTrials
    nt
    tic;
    % the dynamics:  draw a random "input" pattern according to an expenential
    % distribution 
     H = - Hnorm * log(rand(N,1));
     %pt = ceil(nPatterns * rand(1,1));
     %H=  Hnorm*patterns(:,pt);
    
    done = 0;

    for i = 1:N
        Vi(i)= 0;
    end
    t = 0;
    Vconf = zeros(N, maxIter);
    while ~done
        Viold = Vi;
        F = Jij * Vi + Ht(t) * H;

        % use substarctive inhibition that implements a hard maximum for the
        % total activity N*fixAct
        Vi = CiM * max(G.*(F-threshold), 0) + Ci * Viold;
        Vs = sort(Vi);
        Vs = Vs(end:-1:1);
        Q = cumsum(Vs) - ((1:N)') .* Vi;
        Qix = min(find(Q > N*fixAct));
        if isempty(Qix)
            inhib = 0;
        else    
            inhib = Vs(Qix)/ (mean(G)*CiM);
        end


        F = F - inhib;
        Vi = CiM * max(G.*(F-threshold), 0) + Ci * Viold;
        t = t+dT;
        
        abs(round(t)-t);
        if abs(round(t)-t) < 1e-4
            Vconf(:,round(t)) = Vi;
            Vtot(round(t)) = sum(Vi)/N;
        end
        
        done = sum(abs(Vi-Viold)) < crit | t > maxIter;
    end

    
    GG = [Vi patterns];
    cc = corrcoef(GG);
    cc = cc(2:end,1);
    overlaps(:,nt) = cc;
    vFinal(:,nt) = Vi;
    
    if plotTimeCourse
        figure(1);
        plot(Vtot);
        figure(2);
        imagesc(Vconf);
        figure(3);
        bar(cc);
        toc
        keyboard
    end
    
    
end


save(simFilename, 'Jij',  'patterns', 'overlaps', 'vFinal', 'ptEnh');

if strcmp(synMatrixType, 'SynEnhance') | strcmp(synMatrixType, 'ExcEnhance') | strcmp(synMatrixType, 'PartExcEnhance')
        % compute measures for react "sleep 1" situtation
        unEnh = setdiff(1:N, patternEnh); % the "non=enhanced" units
        reactEnhRate = mean(vFinal(patternEnh,:), 2);
        reactEnhRateStd = std(vFinal(patternEnh,:), [], 2);
        reactCompEnhRate = mean(vFinal(patternCompEnh,:), 2);
        reactCompEnhRateStd = std(vFinal(patternCompEnh,:), [], 2);
        reactUnEnhRate = mean(vFinal(unEnh,:), 2);
        reactUnEnhRateStd = std(vFinal(unEnh,:), [], 2);
        % get the correlation between cells that are "enhanced" and "not
        % enhanced"
                
        [A,B] = meshgrid(1:N, 1:N);
        ixEnh = find(A > B & ismember(A, patternEnh) ...
            & ismember(B, patternEnh));
        ixCompEnh = find(A > B & ismember(A, patternCompEnh) ...
            & ismember(B, patternCompEnh));
        ixUnEnh = find(A > B & ismember(A, unEnh) ...
            & ismember(B, unEnh));
        clear A B
        cc = corrcoef(vFinal');
        reactCorrEnh = cc(ixEnh);
        reactCorrCompEnh = cc(ixCompEnh);
        reactCorrUnEnh = cc(ixUnEnh);
        reactCorrM = cc;
        clear cc ixEnh ixUnEnh
        
        save(simFilename, 'baselineEnhRate', 'baselineEnhRateStd',...
            'baselineUnEnhRate', 'baselineUnEnhRateStd', ...
            'baselineCompEnhRate', 'baselineCompEnhRateStd', ...
            'baselineCorrEnh', 'baselineCorrUnEnh', ...
            'baselineCorrCompEnh', ...
            'reactEnhRate', 'reactEnhRateStd',...
            'reactCompEnhRate', 'reactCompEnhRateStd',...
        'reactUnEnhRate', 'reactUnEnhRateStd', ...
            'reactCorrEnh', 'reactCorrCompEnh', 'reactCorrUnEnh', 'baselineCorrM', 'reactCorrM', '-append' );
        
end    

[mxo, mxpt] = (max(overlaps));
[xx, ix] = sort(mxpt);
imagesc(vFinal(:,ix))

%keyboard;


function y = Ht(x)

y = 0.2;
if x < 1000
    y = 2;
end












    

