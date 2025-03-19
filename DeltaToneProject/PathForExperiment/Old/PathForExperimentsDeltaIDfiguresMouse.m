function Dir=PathForExperimentsDeltaIDfiguresMouse(mouse,spikes)

    try
        spikes;
    catch
        spikes=1;
    end
    
    if mouse==243
        %Basal
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse243 - 29032015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse243 - 31032015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243'; % Mouse 243 - Day 4 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse243 - 01042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse243 - 09042015';  
        %Random
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';  % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
        Dir.delay{a}=0.2; Dir.condition{a}='Random';
        Dir.title{a}='Mouse243 - 16042015';
        %Delta Tone
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
        Dir.delay{a}=0.2; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse243 - 17042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015';               % 21-04-2015 > delay 140ms - Mouse 243
        Dir.delay{a}=0.14; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse243 - 21042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
        Dir.delay{a}=0.32; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse243 - 23042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 480ms - Mouse 243
        Dir.delay{a}=0.48; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse243 - 25042015';
    end
    
    if mouse==244
        %Basal
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse244 - 29032015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244'; % Mouse 244 - Day 3 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse244 - 31032015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244'; % Mouse 244 - Day 4 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse244 - 01042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse244 - 09042015';
        %Random
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
        Dir.delay{a}=0.2; Dir.condition{a}='Random';
        Dir.title{a}='Mouse244 - 17042015';
        %Delta Tone
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
        Dir.delay{a}=0.2; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse244 - 16042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150422/Breath-Mouse-244-22042015';               % 22-04-2015 > delay 140ms - Mouse 244
        Dir.delay{a}=0.14; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse244 - 22042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
        Dir.delay{a}=0.32; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse244 - 24042015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 480ms - Mouse 244
        Dir.delay{a}=0.48; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse244 - 26042015';
    end

    if mouse==251
        %Basal
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse251 - 18052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse251 - 19052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse251 - 20052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse251 - 21052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse251 - 22052015';    
        %Random
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251';  % 03-06-2015 > random tone effect  - Mouse 251 (delay 140ms!! of M252 detection)
        Dir.delay{a}=0.14; Dir.condition{a}='Random';
        Dir.title{a}='Mouse251 - 03062015';
        %Delta Tone
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150614/Breath-Mouse-251-14062015';               % 14-06-2015 > delay 140ms - Mouse 251
        Dir.delay{a}=0.14; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse251 - 14062015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
        Dir.delay{a}=0.32; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse251 - 17062015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 09-06-2015 > delay 480ms - Mouse 251
        Dir.delay{a}=0.48; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse251 - 19062015';  
    end

    if mouse==252
        %Basal
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse252 - 18052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse252 - 19052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse252 - 21052015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5 - Basal
        Dir.delay{a}=0; Dir.condition{a}='Basal';
        Dir.title{a}='Mouse252 - 22052015';
        %Random
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252';  % 02-06-2015 > random tone effect  - Mouse 252 (delay 140ms!! of M251 detection)
        Dir.delay{a}=0.14; Dir.condition{a}='Random';
        Dir.title{a}='Mouse252 - 02062015';
        %Delta Tone
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse252';  % 03-06-2015 > delay 140ms - Mouse 252
        Dir.delay{a}=0.14; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse252 - 03062015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';               % 05-06-2015 > delay 320ms - Mouse 252
        Dir.delay{a}=0.32; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse252 - 05062015';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 08-06-2015 > delay 480ms - Mouse 252
        Dir.delay{a}=0.48; Dir.condition{a}='DeltaTone';
        Dir.title{a}='Mouse252 - 08062015'; 
    end
    
    
end