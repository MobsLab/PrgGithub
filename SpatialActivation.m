%SpatialActivation


spacePETH = [];

for i=1:length(S)

	spPETH = RasterSpace(S{id(i)},phiG,ts(Start(ArmExtEpoch)),ts(End(ArmExtEpoch)),'SpaceBin',0.1);
	spacePETH = [spacePETH; spPETH'];

end

gw = gausswin(2);
gw = gw/sum(gw);

spacePETHsm = convn(spacePETH',gw,'same');

[mxVal,ix] = max(spacePETHsm);
spacePETHsm = spacePETHsm./(ones(size(spacePETHsm,1),1)*mxVal);

[dummy,actIdx] = sort(ix,'ascend');

figure(1),clf
imagesc(spacePETHsm(:,actIdx)')

figure(2),clf
imagesc(spacePETHsm')