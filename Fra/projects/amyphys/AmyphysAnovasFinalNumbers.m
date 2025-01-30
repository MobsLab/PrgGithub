m = getenv('HOME');

signThresh = 0.05;
parent_dir =  [hm filesep 'Data/amyphys'];
cd(parent_dir);


datasets = List2Cell([ parent_dir filesep 'datasets_2way.list' ] );

%

A = Analysis(parent_dir);


[A, ntp] = getResource(A, 'NThreatPlus', datasets);
[A, ntm] = getResource(A, 'NThreatMinus', datasets);
[A, nlp] = getResource(A, 'NLipsmackPlus', datasets);
[A, nlm] = getResource(A, 'NLipsmackMinus', datasets);
[A, nnp] = getResource(A, 'NNeutralPlus', datasets);
[A, nnm] = getResource(A, 'NNeutralMinus', datasets);
A = getResource(A, 'ExprSelective', datasets);
A = getResource(A, 'IdSelective', datasets);
A = getResource(A, 'InterSelective', datasets);




n_threat_plus = sum(ntp);
n_threat_minus = sum(ntm);
n_lipsmack_plus = sum(nlp);
n_lipsmack_minus = sum(nlm);
n_neutral_plus = sum(nnp);
n_neutral_minus = sum(nnm);



 fprintf(1, 'at significance level %g\n', signThresh);
  
  fprintf(1, 'expression selective cells = %d; identitiy selective = %d; interaction selective cells = %d\n', ...
    sum(exprSelective), sum(idSelective), sum(interSelective));
    
    fprintf(1, 'of the expression selective cells:\n');
    fprintf(1, 'cells modulated\tupwards\tdownwards\n');
    fprintf(1, 'threat\t%d\t%d\n', n_threat_plus, n_threat_minus);
    fprintf(1, 'lipsmack\t%d\t%d\n', n_lipsmack_plus, n_lipsmack_minus);
    fprintf(1, 'neutral\t%d\t%d\n', n_neutral_plus, n_neutral_minus);
    keyboard