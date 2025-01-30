function AnalyzeSims

        baselineFilename = 's2n2000p100baseline';

        ehs = [  0.1 0.2 0.3 ]
        % ehs = [ 0.1 0.2 0.3 0.4 0.5 0.6]

        % get baseline
        N = 2000;
        nPatterns = 100;
        nSim = 2;
        %simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(1)*100) 'pexcenh.mat'];
          simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(1)*100) 'synenh.mat'];
        load(simFilename);
        
        % overlaps 
        load(baselineFilename, 'overlaps');
        nTrials = size(overlaps, 2);
        
        [m, ix] = max(overlaps);
        
        retr(1)  = sum(ix== ptEnh);
        
        %overlaps 
        
        ptNonEnh = setdiff(1:nPatterns, ptEnh);
        rEnhOverlap(1) = mean(overlaps(ptEnh, :));
        rNonEnhOverlap(1) = mean(mean(overlaps(ptNonEnh,:)));
         
        % rates     
        rEnhRate(1) = mean(baselineEnhRate);
        rCompEnhRate(1) = mean(baselineCompEnhRate);
        rUnEnhRate(1) = mean(baselineUnEnhRate);
        rsEnhRate(1) = sem(baselineEnhRate);
        rsCompEnhRate(1) = sem(baselineCompEnhRate);
        rsUnEnhRate(1) = sem(baselineUnEnhRate);
        
        % correlations
        
        rCorrEnh(1) = mean(baselineCorrEnh);
        rsCorrEnh(1) = sem(baselineCorrEnh);
        rCorrCompEnh(1) = mean(baselineCorrCompEnh);
        rsCorrCompEnh(1) = sem(baselineCorrCompEnh);
        rUnEnhRate(1) = mean(baselineUnEnhRate);
        rsUnEnhRate(1) = sem(baselineUnEnhRate);

        nPatterns = size(patterns,2);
        % average intra-patterns correlation for non-enhanced patterns
        
        [A,B] = meshgrid(1:N, 1:N);
        
        nonP = setdiff(1:nPatterns, ptEnh);
        
        %for j = 1:length(nonP)
        for j = 1:5
            pt = find(patterns(:,nonP(j)));
            ix = find(A > B & ismember(A, pt) ...
            & ismember(B, pt));
            q(j) = mean(baselineCorrM(ix));
        end
        
        rCorrNon(1) = mean(q);
        rsCorrNon(1) = sem(1);
        

        for i = 1:length(ehs)
            
            %simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(i)*100) 'pexcenh.mat'];
            simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(i)*100) 'synenh.mat'];
            load(simFilename);
            %overlaps

            rEnhOverlap(i+1) = mean(overlaps(ptEnh, :));
            rNonEnhOverlap(i+1) = mean(mean(overlaps(ptNonEnh,:)));
            % FIRING RATES


            rCompEnhRate(i+1) = mean(reactCompEnhRate);
            rEnhRate(i+1) = mean(reactEnhRate);
            rUnEnhRate(i+1) = mean(reactUnEnhRate);
            rsCompEnhRate(i+1) = sem(reactCompEnhRate);
            rsEnhRate(i+1) = sem(reactEnhRate);
            rsUnEnhRate(i+1) = sem(reactUnEnhRate);


            % correlations

            rCorrEnh(i+1) = mean(reactCorrEnh);
            rsCorrEnh(i+1) = sem(reactCorrEnh);
            rCorrCompEnh(i+1) = mean(reactCorrCompEnh);
            rsCorrCompEnh(i+1) = sem(reactCorrCompEnh);
            rUnEnhRate(i+1) = mean(reactUnEnhRate);
            rsUnEnhRate(i+1) = sem(reactUnEnhRate);


            % average intra-patterns correlation for non-enhanced patterns

            [A,B] = meshgrid(1:N, 1:N);

            nonP = setdiff(1:nPatterns, ptEnh);

            for j = 1:length(nonP)
            %for j = 1:3
                pt = find(patterns(:,nonP(j)));
                ix = find(A > B & ismember(A, pt) ...
                    & ismember(B, pt));
                q(j) = mean(reactCorrM(ix));
            end

            rCorrNon(i+1) = mean(q);
            rsCorrNon(i+1) = sem(q);

            %overlaps
            
            [m, ix] = max(overlaps);
        
        	retr(i)  = sum(ix== ptEnh);
            
        end
        
        
        x = [0 ehs];
        figure(1)
        errorbar(x,rEnhRate, rsEnhRate, 'r');
        hold on 
        errorbar(x, rCompEnhRate, rsCompEnhRate, 'g');
        errorbar(x, rUnEnhRate, rsUnEnhRate, 'k');
        
        figure(2)
        errorbar(x,rCorrEnh, rsCorrEnh,'r');
        hold on 
        errorbar(x, rCorrCompEnh,rsCorrCompEnh, 'g');
        errorbar(x, rCorrNon, rsCorrNon, 'k');
        
        
        keyboard