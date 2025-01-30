%makeData

SetCurrentSession


%--------------------------------------------------------------------------
%%Spikes-------------------------------------------------------------------
%--------------------------------------------------------------------------
try 
    SpikeData
catch
    
s=GetSpikes('output','full');
a=1;
for i=1:10
for j=1:30
if length(find(s(:,2)==i&s(:,3)==j))>1
S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
a=a+1;
end
end
end
S=tsdArray(S);
save SpikeData S s

end


%--------------------------------------------------------------------------
%%LFP----------------------------------------------------------------------
%--------------------------------------------------------------------------

try 
    LFPData
catch
    
lfp=GetLFP('all');

for i=1:size(lfp,1)-1
LFP{i}=tsd(lfp(:,1)*1E4,lfp(:,i+1));
end
save LFPData LFP lfp

end

%--------------------------------------------------------------------------
%%BehavResources-----------------------------------------------------------
%--------------------------------------------------------------------------

try
    behavResources
catch
        
    
Pos=TrackMouseLight(filename);
Art=40;
[PoC,speed]=RemoveArtifacts(Pos,Art);

tps=Pos(:,1);
tps=rescale(tps,2,lfp(end,1)-2)*1E4;

XS{1}=tsd(tps,PosC(:,2));
YS{1}=tsd(tps,PosC(:,3));
V{1}=tsd(tps,speed);

save behavResources Pos PosC speed XS YS V

end






