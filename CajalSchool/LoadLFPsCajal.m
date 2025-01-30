function LFPs=LoadLFPsCajal(voies)

res=pwd;
for a=1:length(voies)
clear LFP
eval(['load(''',res,'','/LFPData/LFP',num2str(voies(a)),'.mat'');'])
LFPs{a}=LFP;
end
