function AnalyzeSims

        baselineFilename = 's3n2000p100baseline';

        epsilon = 1e-4;
        ehs = [(0:0.02:0.08) (0.1:0.1:0.5)];
        
        % get baseline
        N = 2000;
        nPatterns = 40;
        nSim = 3;
        %simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(1)*100) 'pexcenh.mat'];
        
          
          load(baselineFilename, 'patterns', 'pattEnhance', 'vFinal');
          N = size(patterns, 1);
          nPatterns = size(patterns, 2);
          f_M = sum(patterns * diag(pattEnhance), 2)+epsilon;
          f_S1_1 = sum(vFinal(:,1:(floor(size(vFinal,2))/2)), 2);
          f_S1_2 = sum(vFinal(:,(floor(size(vFinal,2))/2):end), 2);
          f_S1 = sum(vFinal, 2);
          X_MS1 = log10(f_M ./ f_S1_1);
          
          normP = sum(pattEnhance);
          sxy = patterns * diag(pattEnhance) * patterns' / normP;
          mx = sum(patterns * diag(pattEnhance), 2)/normP;
          vx = sum((patterns.* patterns ) * diag(pattEnhance),2 ) / normP - mx .* mx;
          
          [A, B] = meshgrid(1:N, 1:N);
          
          ix = find(A>B);
          clear A B
          C_m = (sxy - mx * mx') ./ sqrt(vx*vx');
          C_m = C_m(ix);
          C_s1 = corrcoef(vFinal');
          C_s1 = C_s1(ix);
          
          
          
%           keyboard
          
          
          
          for i = 1:length(ehs)
              simFilename = ['s' num2str(nSim) 'n' num2str(N) 'p' num2str(nPatterns) 'e' num2str(ehs(i)*100) 'excenh.mat'];
              load(simFilename, 'vFinal');
              f_S2 = sum(vFinal, 2);
              f_S2_1 = sum(vFinal(:,1:(floor(size(vFinal,2))/2)), 2);
              f_S2_2 = sum(vFinal(:,(floor(size(vFinal,2))/2):end), 2);
              X_S2S1= log10(f_S2 ./ f_S1_2);
              X_MS2 = log10(f_M ./ f_S2_1);
              X_S1S2 = log10(f_S1 ./ f_S2_2);
              C_s2 = corrcoef(vFinal');
              C_s2 = C_s2(ix);
              [EV(i), EVr(i)] = ReactEV(C_s1, C_s2, C_m);
              r  = nancorrcoef(X_MS1, X_S2S1);
              Rx(i) = r(1,2);
              
              r = nancorrcoef(X_MS2, X_S1S2);
              Rr(i) = r(1,2);
              
              plot(X_MS1, X_S2S1, '.');
              
              keyboard
          end
          keyboard
        