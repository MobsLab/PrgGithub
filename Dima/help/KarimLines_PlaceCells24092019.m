

for a=1:length(S)
try
[map{a},mapS{a},stat{a}]=PlaceField(Restrict(S{a},SessionEpoch.Hab),Restrict(Xtsd,SessionEpoch.Hab),Restrict(Ytsd,SessionEpoch.Hab));close
specificity(a)=stat{a}.specificity;
sparsity(a)=stat{a}.sparsity;
spatialInfo(a)=stat{a}.spatialInfo;
PF{a}=stat{a}.field;
end
end

figure, subplot(1,3,1), plot(specificity,'ko-'), subplot(1,3,2), plot(sparsity,'ko-'), subplot(1,3,3), plot(spatialInfo,'ko-')

PFlist=find(spatialInfo>0.8);

for a=PFlist
    PlaceField(Restrict(S{a},SessionEpoch.Hab),Restrict(Xtsd,SessionEpoch.Hab),Restrict(Ytsd,SessionEpoch.Hab));

end