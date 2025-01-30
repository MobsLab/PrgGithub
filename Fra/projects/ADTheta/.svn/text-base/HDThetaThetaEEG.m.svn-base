function  A= HDThetaPositionMeasures(A)


do_fig = false;
vThresh = 1e-5;

A = getResource(A, 'Eeg');
eeg = eeg{1};

A = registerResource(A, 'ThetaEEG', 'tsdArray', {1,1}, ...
    'thetaEEG', ...
    ['tsd with the EEG filtered for Theta']);


thetaEEG = Filter_7hz(eeg);

if  do_fig
    clf;
    plot(Range(eeg, 's'), Data(eeg));
    hold on 
    plot(Range(thetaEEG, 's'), Data(thetaEEG) ,'r')
    keyboard
end

    

A = saveAllResources(A);