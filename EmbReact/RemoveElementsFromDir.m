function Dir=RemoveElementsFromDir(Dir,ElementsName,Value)

% This function checks a value against ExpeInfo and ecludes parts of Dir
% that match
% Ex : Dir=RemoveElementsFromDir(Dir,'StimElecs','EyeShock') excludes all
% experiments using the eyeshock
% Ex : Dir=RemoveElementsFromDir(Dir,'nmouse',431) exludes mouse 431

% Check if number of string
ValueClass=whos('Value');ValueClass=ValueClass.class;
if not(strcmp(ValueClass,'string') | (strcmp(ValueClass,'char')))
    NumOrStr=1;
else
    NumOrStr=0;
end

% Get level of nestedness of cell array (generally 1 or 2)
a=Dir.ExpeInfo{1};
AClass=whos('a'); AClass=AClass.class;
if strcmp(AClass,'struct')
    depth=1;
else
    a=Dir.ExpeInfo{1}{1};
    AClass=whos('a'); AClass=AClass.class;
    if strcmp(AClass,'struct')
        depth=2;
    end
end

if depth==1
% depth 1 structures 
GetRid=[];
for mm=1:length(Dir.path)
        if NumOrStr
            if any(eval(['Value==Dir.ExpeInfo{mm}.',ElementsName]))
                Dir.ExpeInfo{mm}=[];
                Dir.path{mm}=[];
            end
        else
            if any(eval(['ismember(Value,Dir.ExpeInfo{mm}.',ElementsName,')']))
                Dir.ExpeInfo{mm}=[];
                Dir.path{mm}=[];
            end
        end
end
Dir.path=Dir.path(~cellfun('isempty',Dir.path));
Dir.ExpeInfo=Dir.ExpeInfo(~cellfun('isempty',Dir.ExpeInfo));

else
% depth 2 structures 
GetRid=[];
for mm=1:length(Dir.path)
    for c=1:length(Dir.path{mm})
        if NumOrStr

    if any(eval(['Value==Dir.ExpeInfo{mm}{c}.',ElementsName]))
                Dir.ExpeInfo{mm}{c}=[];
                Dir.path{mm}{c}=[];
    end
        else
            if any(eval(['ismember(Value,Dir.ExpeInfo{mm}{c}.',ElementsName,')']))
                Dir.ExpeInfo{mm}{c}=[];
                Dir.path{mm}{c}=[];
            end
        end
    end
end

for mm=1:length(Dir.path)
    tmp= Dir.path{mm};
    tmp=tmp(~cellfun('isempty',tmp));
    Dir.path{mm}=tmp;
    tmp= Dir.ExpeInfo{mm};
    tmp= tmp(~cellfun('isempty',tmp));
    Dir.ExpeInfo{mm}=tmp;
end
Dir.path=Dir.path(~cellfun('isempty',Dir.path));
Dir.ExpeInfo=Dir.ExpeInfo(~cellfun('isempty',Dir.ExpeInfo));
end

end