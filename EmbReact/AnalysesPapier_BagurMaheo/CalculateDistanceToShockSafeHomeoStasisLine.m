function residual_test = CalculateDistanceToShockSafeHomeoStasisLine(Length_shock_test,Length_safe_test)

% Provide as input the time spent above 4.5Hz and below 4.5Hz
plo = 0;

% Fit the model to reference data
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat')
Length_shock_log = log10(Length_shock)'; Length_shock_log(Length_shock_log==-Inf)=NaN;
Length_safe_log = log10(Length_safe)';Length_safe_log(Length_safe_log==-Inf)=NaN;

mdl = fit(Length_shock_log,Length_safe_log,'poly1');
for mouse=1:length(Length_safe_log)
    residual_eyelid(mouse) = Length_safe_log(mouse)-(Length_shock_log(mouse)* mdl.p1 + mdl.p2);
end

% calculate the residuals for the test animals
Length_shock_test_log = log10(Length_shock_test)'; Length_shock_test_log(Length_shock_test_log==-Inf)=NaN;
Length_safe_test_log = log10(Length_safe_test)'; Length_safe_test_log(Length_safe_test_log==-Inf)=NaN;
for mouse=1:length(Length_safe_test_log)
    residual_test(mouse) = Length_safe_test_log(mouse)-(Length_shock_test_log(mouse)* mdl.p1 + mdl.p2);
end

if plo
    [R,P] = PlotCorrelations_BM(Length_shock_log , Length_safe_log , 'conf_bound',1);
    makepretty
    xlabel('Duration fast breath freezingg (log scale)'), ylabel('Duration slow breath freezgin (log scale)')
    axis square
    plot(Length_shock_test_log,Length_safe_test_log,'.b')
end
   
end
