%SpaceInterneuron

for i=1:length(list)

SP=[];

%for i=1:1

	N{i}=listIntPyr(find(listIntPyr(:,1)==list(i)),2);
	
	
	
	
	spacePETH1 = RasterSpace(S{list(i)},phiG,ts(Start(ArmExtEpoch)),ts(End(ArmExtEpoch)),'SpaceBin',0.05);
	spacePETH1(isnan(spacePETH1))=0;
%	figure('Color',[1 1 1])
%	hold on, plot3([1:41],zscore(spacePETH1),zeros(1,41),'k','linewidth',3)

SP=[SP, spacePETH1];
	
	for n=1:length(N{i})
	
		spacePETH2 = RasterSpace(S{N{i}(n)},phiG,ts(Start(ArmExtEpoch)),ts(End(ArmExtEpoch)),'SpaceBin',0.05);
		spacePETH2(isnan(spacePETH2))=0;
%		hold on, plot3([1:41],zscore(spacePETH2),n*ones(41,1),'Color',[0,0,i/length(N{i})])
SP=[SP, spacePETH2];
	
	end

figure('Color',[1 1 1])
imagesc(zscore(SP)')

figure('Color',[1 1 1])
imagesc(SP')

end
