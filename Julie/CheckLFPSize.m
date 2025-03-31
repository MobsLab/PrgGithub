%CheckLFPSize.m
%22.09.2016

Tend=[];
list=dir;
for i=3:length(dir)
    if strcmp(list(i).name(1:3),'LFP')
    temp=load(list(i).name);

    tend=max(Range(temp.LFP))*1E-4;
    Tend=[Tend;tend];
    end
end
save Tend Tend list