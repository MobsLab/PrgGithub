function Dir=PathForExperimentsDeltaToInclude(experiment)

%
% see  PathForExperimentsDeltaSleepSpikes
%
%
% Equivalent to PathForExperimentsDeltaLongSleep,but with just nights to
% include in usual datasets


%% Basal condition
a=0;
if strcmpi(experiment,'BASAL')
    %SB
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/'; % Mouse 508 - Basal 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1 
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/'; % Mouse 509 - Basal 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170203/ProjectEmbReact_M510_20170203_BaselineSleep/'; % Mouse 510 - Basal 1 
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170204/ProjectEmbReact_M510_20170204_BaselineSleep/'; % Mouse 510 - Basal 2
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep/'; % Mouse 512 - Basal 1 
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep/'; % Mouse 512 - Basal 2
    
    %
    
end


%% If ALL experiments
if strcmpi(experiment,'all')
    Dir = PathForExperimentsDeltaToInclude('Basal');
%     for p=1:length(Dir1.path)
%         Dir1.delay{p}=-1;
%     end
%     Dir2=PathForExperimentsDeltaLongSleepNew('RdmTone');
%     Dir3=PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
%     Dir = MergePathForExperiment(Dir2,Dir3);
%     Dir = MergePathForExperiment(Dir1,Dir);
%     
% elseif strcmpi(experiment,'DeltaToneAll')
%     Dir1 = PathForExperimentsDeltaLongSleepNew('DeltaT0');
%     Dir2 = PathForExperimentsDeltaLongSleepNew('DeltaT140');
%     %Dir3 = PathForExperimentsDeltaLongSleepNew('DeltaT200');
%     Dir4 = PathForExperimentsDeltaLongSleepNew('DeltaT320');
%     Dir5 = PathForExperimentsDeltaLongSleepNew('DeltaT490');
%     
%     Dir = MergePathForExperiment(Dir1,Dir2);
%     %Dir = MergePathForExperiment(Dir,Dir3);
%     Dir = MergePathForExperiment(Dir,Dir4);
%     Dir = MergePathForExperiment(Dir,Dir5);
%     
%     for i=1:length(Dir.path)
%        Dir.manipe{i}='DeltaToneAll'; 
%     end
    
else
    %% names
    for i=1:length(Dir.path)
        Dir.manipe{i}=experiment;
        if Dir.path{i}(end-8)=='/'
        Dir.name{i}=Dir.path{i}(end-7:end);
        else
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
        Dir.name{i}(Dir.name{i}=='-')=[];
        Dir.name{i}(Dir.name{i}=='/')=[];
        end

    end

    %% Strain
    for i=1:length(Dir.path)
        Dir.group{i}=nan;
    end

    %% Date
    for i=1:length(Dir.path)
        ind=strfind(Dir.path{i},'2015');
        if isempty(ind)
            ind=strfind(Dir.path{i},'2016');
        end
        if isempty(ind)
            ind=strfind(Dir.path{i},'2017');
        end
        if isempty(ind)
            ind=strfind(Dir.path{i},'2018');
        end
        Dir.date{i} = Dir.path{i}(ind(end)-4:ind(end)+3);
    end

end

end

