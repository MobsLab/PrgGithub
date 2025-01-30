function ReactRateNetworkSim(synMatrixType, eh)



nSim = 4;

% number of neurons 
N = 2000;
nPatterns = 40;
sparseness = 0.05;
nTrials = 500;
pe = 0.05;
ne = 5;
baselineFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'baseline.mat'];


%gain 
G = 4 *ones(N,1);
Hnorm = 0.3;
fixAct = 2;
threshold = 1 * ones(N,1);
crit = 0.01;
maxIter = 300;

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




% prepare the matrix of synaptic connections 


switch synMatrixType

    case 'SynEnhance'
        enh= eh;
        
        load(baselineFilename, 'patterns', 'pattEnhance', 'sparseness');

        N = size(patterns,1);
        nPatterns = size(patterns,2);
        
      nActive = floor(sparseness * N);
        jI = zeros(nPatterns *nActive*nActive, 1);
        jJ = zeros(nPatterns *nActive*nActive, 1);
        [A, B] = meshgrid(pattEnhance, 1:(nActive*nActive));
        jS = (1 / (sparseness ^ 2 * nPatterns * N)) * (1+enh * A(:));
        

        offset = 0;
        pattEnhance = ExpVariate(1, 1, nPatterns);

        for i = 1:nPatterns
            patt = find(patterns(:,i));

            ptI = repmat(patt, nActive, 1);
            ptI = ptI(:);
            jI((offset+1): (offset+length(ptI))) = ptI;
            ptJ = repmat(patt, 1, nActive);
            ptJ =ptJ';
            jJ((offset+1): (offset+length(ptI))) = ptJ;
            offset = offset + length(ptI);

        end
        Jij = sparse(jI, jJ, jS, N, N);


        for i = 1:N
            Jij(i,i) = 0;
        end
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(enh*100) 'synenh.mat'];

    case 'ExcEnhance'
         thrEnh = eh;
        load(baselineFilename, 'patterns', 'pattEnhance', 'sparseness', 'Jij');

        N = size(patterns,1);
        nPatterns = size(patterns,2);        
        nActive = floor(sparseness * N);
        threshold = ones(N,1);
        
        pt = sum(patterns * diag(pattEnhance), 2);
        threshold = threshold - thrEnh * pt;
             
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(thrEnh*100) 'excenh.mat'];
    
    case 'Hopfield'
        
        patterns = zeros(N, nPatterns);
        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'baseline.mat'];

        nActive = floor(sparseness * N);
        jI = zeros(nPatterns *nActive*nActive, 1);
        jJ = zeros(nPatterns *nActive*nActive, 1);
        
        jS = (1 / (sparseness ^ 2 * nPatterns * N)) * ones(nPatterns * nActive * nActive, 1);

        offset = 0;
        pattEnhance = (ExpVariate(pe, 1, nPatterns));
        q = randperm(nPatterns);
        q = q(1:ne);
        pattEnhance(q) = pattEnhance(q) + 1;


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
        for i = 1:N
            Jij(i,i) = 0;
        end

        simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'baseline.mat'];



    
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

display(['starting '  simFilename]); 

for nt = 1:nTrials
    
    tic;
    % the dynamics:  draw a random "input" pattern according to an expenential
    % distribution 
     H = - Hnorm * log(rand(N,1));
     
    
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


save(simFilename, 'Jij',  'patterns', 'pattEnhance', 'sparseness', 'overlaps', 'vFinal');



[mxo, mxpt] = (max(overlaps));
[xx, ix] = sort(mxpt);
imagesc(vFinal(:,ix))

%keyboard;


function y = Ht(x)

y = 0.2;
if x < 1000
    y = 2;
end












    

