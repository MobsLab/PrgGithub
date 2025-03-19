%clear all

load behavResources

evt

b=1;
for i=1:length(evt)/2
    textt=evt(i);
    if ~isempty(strfind(evt{i},'Delta'))
        DeltaSession(b)=i;
        b=b+1;
    end
end

if exist('DeltaSession','var')
    
    if length(DeltaSession)==2
        EpochToAnalyse{1}=intervalSet(tpsdeb{1}*1E4,tpsdeb{DeltaSession(1)}*1E4);
        EpochToAnalyse{2}=intervalSet(tpsdeb{DeltaSession(1)}*1E4,tpsfin{DeltaSession(1)}*1E4);
        EpochToAnalyse{3}=intervalSet(tpsfin{DeltaSession(1)}*1E4,tpsdeb{DeltaSession(2)}*1E4);
        EpochToAnalyse{4}=intervalSet(tpsdeb{DeltaSession(2)}*1E4,tpsfin{DeltaSession(2)}*1E4);
        EpochToAnalyse{5}=intervalSet(tpsfin{DeltaSession(2)}*1E4,tpsfin{end}*1E4);
    end
    if length(DeltaSession)==3 % for mice 243-244 during the 16-04-2015 (delta session #2,3,5
        EpochToAnalyse{1}=intervalSet(tpsdeb{1}*1E4,tpsdeb{DeltaSession(1)}*1E4);
        EpochToAnalyse{2}=intervalSet(tpsdeb{DeltaSession(1)}*1E4,tpsfin{DeltaSession(2)}*1E4);
        EpochToAnalyse{3}=intervalSet(tpsfin{DeltaSession(2)}*1E4,tpsdeb{DeltaSession(3)}*1E4);
        EpochToAnalyse{4}=intervalSet(tpsdeb{DeltaSession(3)}*1E4,tpsfin{DeltaSession(3)}*1E4);
        EpochToAnalyse{5}=intervalSet(tpsfin{DeltaSession(3)}*1E4,tpsfin{end}*1E4);
        disp (' 3 delta sessions ok')
    end
    
    nameEpochToAnalyse{1}='Pre';
    nameEpochToAnalyse{2}='Delta1';
    nameEpochToAnalyse{3}='Post1-Pre2';
    nameEpochToAnalyse{4}='Delta2';
    nameEpochToAnalyse{5}='Post';
    
    disp('Delta Day EpochToAnalyse OK')
    
elseif ~exist('DeltaSession','var')
    
    START=tpsdeb{1}*1E4;
    END=tpsfin{length(evt)/2}*1E4;
    DURATION=END/5;
    EpochToAnalyse{1}=intervalSet(START,START+DURATION);
    EpochToAnalyse{2}=intervalSet(START+DURATION,START+DURATION*2);
    EpochToAnalyse{3}=intervalSet(START+DURATION*2,START+DURATION*3);
    EpochToAnalyse{4}=intervalSet(START+DURATION*3,START+DURATION*4);
    EpochToAnalyse{5}=intervalSet(START+DURATION*4,START+DURATION*5);
    
    
    nameEpochToAnalyse{1}='Basal1';
    nameEpochToAnalyse{2}='Basal2';
    nameEpochToAnalyse{3}='Basal3';
    nameEpochToAnalyse{4}='Basal4';
    nameEpochToAnalyse{5}='Basal5';
    
    disp('Basal Day EpochToAnalyse OK')
end


save EpochToAnalyse EpochToAnalyse nameEpochToAnalyse

