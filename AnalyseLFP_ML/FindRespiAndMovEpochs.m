% FindRespiAndMovEpochs.m


Dir=PathForExperimentsML('PLETHYSMO');
SniffFreq=[4.5 10];
BasalBrethFreq=[2 4];

for man=1:length(Dir.path)
    clear Frequency SniffEpoch BasalBreathEpoch Freqffinf Freqffsup
    
    disp(' '); disp(Dir.path{man});
    
    try
        error
        warning off
        load([Dir.path{man},'/StateEpoch.mat'],'SniffEpoch','BasalBreathEpoch')
        warning on
        Start(SniffEpoch);
    catch
        load([Dir.path{man},'/LFPData.mat'],'Frequency')
       
        % Sniff
        Freqffinf=thresholdIntervals(Frequency,SniffFreq(1),'Direction','Above');
        Freqffsup=thresholdIntervals(Frequency,SniffFreq(2),'Direction','Below');
        
        SniffEpoch=and(Freqffinf,Freqffsup);
        
        % Basal
        Freqffinf=thresholdIntervals(Frequency,BasalBrethFreq(1),'Direction','Above');
        Freqffsup=thresholdIntervals(Frequency,BasalBrethFreq(2),'Direction','Below');
        
        BasalBreathEpoch=and(Freqffinf,Freqffsup);
        
        % saving
        save([Dir.path{man},'/StateEpoch.mat'],'-append','SniffEpoch','BasalBreathEpoch','SniffFreq','BasalBrethFreq')
    end
    
    disp(['          Time in sniff ([',num2str(SniffFreq(1)),'-',num2str(SniffFreq(2)),']Hz): ',...
        num2str(floor(sum(Stop(SniffEpoch,'s')-Start(SniffEpoch,'s')))),' s'])
    disp(['          Time in basal ([',num2str(BasalBrethFreq(1)),'-',num2str(BasalBrethFreq(2)),']Hz): ',...
        num2str(floor(sum(Stop(BasalBreathEpoch,'s')-Start(BasalBreathEpoch,'s')))),' s'])
end

