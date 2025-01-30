function A = AmyphysSelectAnovas(A)

signThresh = 0.05;

A = getResource(A, 'AnovasTotal');
[A, c] = getResource(A, 'AnovasMultCompareExpr');
[A, pt] = getResource(A, 'PostHocPvalThreat');
[A, pn] = getResource(A, 'PostHocPvalNeutral');
[A, pl] = getResource(A, 'PostHocPvalLipsmack');
[A, rt] = getResource(A, 'RateThreat');
[A, rl] = getResource(A, 'RateLipsmack');
[A, rn] = getResource(A, 'RateNeutral');


A = registerResource(A, 'IsTwoWay', 'numeric', {'AmygdalaCellList',1}, ...
    'isTwoWay', ...
    ['a boolean telling if the cell was tested with the two way anova']);

 A= registerResource(A, 'ExprSelective', 'numeric', {'AmygdalaCellList',1}, ...
     'exprSelective', ...
     ['a boolean telling whether the cell waws selective for expressions']);
 
 
 A= registerResource(A, 'IdSelective', 'numeric', {'AmygdalaCellList',1}, ...
     'idSelective', ...
     ['a boolean telling whether the cell waws selective for monkey id']);
 
 
 A= registerResource(A, 'InterSelective', 'numeric', {'AmygdalaCellList',1}, ...
     'interSelective', ...
     ['a boolean telling whether the cell waws selective for interactions']);
 
 A= registerResource(A, 'StimKindSelective', 'numeric', {'AmygdalaCellList',1}, ...
     'stimKindSelective', ...
     ['a boolean telling whether the cell waws selective for interactions']);
     
 A = registerResource(A, 'NThreatPlus', 'numeric', {1,1}, ...
     'n_threat_plus', ...
     ['number of up thrat modulated cells']);
 
 A = registerResource(A, 'NThreatMinus', 'numeric', {1,1}, ...
     'n_threat_minus', ...
     ['number of down thrat modulated cells']);
 
  A = registerResource(A, 'NLipsmackPlus', 'numeric', {1,1}, ...
     'n_lipsmack_plus', ...
     ['number of up lipsmack modulated cells']);
 
 A = registerResource(A, 'NLipsmackMinus', 'numeric', {1,1}, ...
     'n_lipsmack_minus', ...
     ['number of down lipsmack modulated cells']);
 
 A = registerResource(A, 'NNeutralPlus', 'numeric', {1,1}, ...
     'n_neutral_plus', ...
     ['number of up neutral modulated cells']);
 
 A = registerResource(A, 'NNeutralMinus', 'numeric', {1,1}, ...
     'n_neutral_minus', ...
     ['number of down neutral modulated cells']);
 
     
     
  nCells = length(anovasTotal);
  
  isTwoWay = zeros(nCells, 1);
  exprSelective= zeros(nCells, 1);
  idSelective= zeros(nCells, 1);
  interSelective= zeros(nCells, 1);
  stimKindSelective= zeros(nCells, 1);

  n_threat_plus = 0;
  n_lipsmack_plus = 0;
  n_neutral_plus = 0;

  n_threat_minus = 0;
  n_lipsmack_minus = 0;
  n_neutral_minus = 0;


  for i = 1:nCells
      aT = anovasTotal{i};
      a = aT{'StimKind'};
      stimKindSelective(i) = a < signThresh;
      if has_key(aT, '2WayExprId')
          isTwoWay(i) = 1;
          a = aT{'2WayExprId'};
          idSelective(i) = a(1) < signThresh;
          exprSelective(i) = a(2) < signThresh;
          interSelective(i) = a(3) < signThresh;
          
         if exprSelective(i)
             if pt(i) < (0.05 /3)  
                 if (rt(i) > (rn(i) +rl(i)) / 2)
                    n_threat_plus = n_threat_plus + 1;
                    else
                    n_threat_minus = n_threat_minus + 1;   
                end
             end    
             if pl(i) < (0.05 /3)  
                 if (rl(i) > (rn(i) +rt(i)) / 2)
                    n_lipsmack_plus = n_lipsmack_plus + 1;
                    else
                    n_lipsmack_minus = n_lipsmack_minus + 1;   
                end
             end    
             if pn(i) < (0.05 /3)  
                 if (rn(i) > (rt(i) +rl(i)) / 2)
                    n_neutral_plus = n_neutral_plus + 1;
                    else
                    n_neutral_minus = n_neutral_minus + 1;   
                end
             end    
         end       
          
      end
  end
  
  
 
     
     
  A = saveAllResources(A);
  
 
