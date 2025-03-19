

for k=1:length(Stsd)
% [map{k},mapS,stats]=PlaceField(Stsd{k},X,Y);
SI(k)=stats.spatialInfo;
end

id=find(SI>10);
m=map{id(1)}.rate/max(max(map{id(1)}.rate));
for k=id
 m=m+map{k}.rate/max(max(map{k}.rate));
 end
 figure, imagesc(m), axis xy    