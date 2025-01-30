datasets = List2Cell([ parent_dir filesep 'datasets_general2.list' ] );
nbDays = length(datasets);

%  A = getResource(A,'ReactTimeCourseS1PCA',datasets)
%  A = getResource(A,'ReactTimeCourseS2PCA',datasets)

binSize = 1000;
maxTime = 20*60*10^4;

for i=1:nbDays

	display(datasets{i})
	rg = Range(reactTimeCourseS1PCA{i});
	if rg(end)-rg(1) > maxTime
		dat = Data(Restrict(reactTimeCourseS1PCA{i},rg(1),rg(1)+maxTime));
		dat = dat(:,2);
		if length(dat) == maxTime/binSize
			r1(i,:) = dat;
			setS1{i} = datasets{i};
		else
			display([datasets{i} ' sleep1 data do not fit'])
		end
	else
		display([datasets{i} ' sleep1 range do not fit'])
	end

	rg = Range(reactTimeCourseS2PCA{i});
	if rg(end)-rg(1) > maxTime
		dat = Data(Restrict(reactTimeCourseS2PCA{i},rg(1),rg(1)+maxTime));
		dat = dat(:,2);
		if length(dat) == maxTime/binSize
			r2(i,:) = dat;
			setS1{i} = datasets{i};
		else
			display([datasets{i} ' sleep2 data do not fit'])
		end
	else
		display([datasets{i} ' sleep2 range do not fit'])
	end

end


r1c = convn(r1',gausswin(1200))/sum(gausswin(1200));
r1c = r1c(600:end-600,:)';

r2c = convn(r2',gausswin(1200))/sum(gausswin(1200));
r2c = r2c(600:end-600,:)';

rg = [1:100:maxTime/binSize];

r1cSm = r1c(:,rg);
r2cSm = r2c(:,rg);

cM1 = nancorrcoef(r1cSm);
cM1(isnan(cM1)) = 0;
[PCACoef1 PCAvar1 PCAexp1] = pcacov(cM1);

cM2 = nancorrcoef(r2cSm);
cM2(isnan(cM2)) = 0;
[PCACoef2 PCAvar2 PCAexp2] = pcacov(cM2);

figure(1),clf

yMax = max(max(mean(r1cSm)),max(mean(r2cSm)))
yMin = min(min(mean(r1cSm)),min(mean(r2cSm)))

subplot(1,2,1)

%  	stdR = std(r1c);
	plot(mean(r1cSm))
%  	errorbar([1:binSize:maxTime]/10000,mean(r1c),stdR,-stdR)
	set(gca,'YLim',[yMin yMax])

subplot(1,2,2)

%  	stdR = std(r2c);
	plot(mean(r2cSm))
%  	errorbar([1:binSize:maxTime]/10000,mean(r2c),stdR,-stdR)
	set(gca,'YLim',[yMin yMax])


figure(2),clf
plot(PCACoef2(:,1))

figure(3),clf
plot(PCACoef2(:,2))

figure(4),clf
plot(PCACoef2(:,3))

