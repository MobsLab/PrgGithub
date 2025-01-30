
datasets = List2Cell([ parent_dir(A) filesep 'datasets_rat18.list' ] );
nbDays = length(datasets);

A = getResource(A,'ReactTimeCourseS1',datasets)
A = getResource(A,'ReactTimeCourseS2',datasets)
A = getResource(A,'ReactTimeCourseMaze',datasets)



binSize = 1000;
maxTime = 20*60*10^4;
sleep2delay = 0;
excludedDays = [];

offset = 0; %in case of a problem for sleep1, rows for sleep2 have to be shifted
setKept = {};
clear r1 r2 mrMaze

for i=1:nbDays

	ok=0;

	display(datasets{i})
	rg = Range(reactTimeCourseS1{i});
	if rg(end)-rg(1) > maxTime
		dat1 = Data(Restrict(reactTimeCourseS1{i},rg(1),rg(1)+maxTime));

		if length(dat) == maxTime/binSize
			ok=1;
		else
			display([datasets{i} ' sleep1 data do not fit'])
			excludedDays = [excludedDays;i];
		end
	else
		display([datasets{i} ' sleep1 range do not fit'])
		excludedDays = [excludedDays;i];
	end

	if ok==1
		ok=0;
		rg = Range(reactTimeCourseS2{i});
		if rg(end)-(rg(1)) > maxTime
			dat2 = Data(Restrict(reactTimeCourseS2{i},rg(1),rg(1)+maxTime));
	
			if length(dat) == maxTime/binSize
				ok=1;
			else
				display([datasets{i} ' sleep2 data do not fit'])
				excludedDays = [excludedDays;i];
			end
	
		else
			display([datasets{i} ' sleep2 range do not fit'])
			excludedDays = [excludedDays;i];
	
		end
		
		if ok==1
			r1(i-offset,:) = dat1;
			r2(i-offset,:) = dat2;
			mrMaze(i-offset) = mean(Data(reactTimeCourseMaze{i}));
			setKept = [setKept ; {datasets{i}}];
		else
			offset = offset + 1;
		end

	else
		offset = offset + 1;
	end

end

r1c = convn(r1',gausswin(1200))/sum(gausswin(1200));
r1c = r1c(1800:end-600,:)';

r2c = convn(r2',gausswin(1200))/sum(gausswin(1200));
r2c = r2c(1800:end-600,:)';

rg = [1:100:maxTime/binSize-1200];

r1cSm = r1c(:,rg);
r2cSm = r2c(:,rg);

mr1 = mean(r1');
mr2 = mean(r2');
p1 = polyfit(mrMaze,mr1,1);
p2 = polyfit(mrMaze,mr2,1);

figure(1),clf

yMax = max(max(mean(r1cSm)),max(mean(r2cSm)))
yMin = min(min(mean(r1cSm)),min(mean(r2cSm)))

subplot(1,2,1)

%  	stdR = std(r1c);
	plot([1:maxTime/(100*binSize)-12]*10,mean(r1cSm))
%  	errorbar([1:binSize:maxTime]/10000,mean(r1c),stdR,-stdR)
	set(gca,'YLim',[yMin yMax])

subplot(1,2,2)

%  	stdR = std(r2c);
	plot([1:maxTime/(100*binSize)-12]*10,mean(r2cSm))
%  	errorbar([1:binSize:maxTime]/10000,mean(r2c),stdR,-stdR)
	set(gca,'YLim',[yMin yMax])

figure(2),clf
hold on
plot(mrMaze,mr1,'go')
plot([min(mrMaze) max(mrMaze)],p1(1)*[min(mrMaze) max(mrMaze)] + p1(2),'g')
plot(mrMaze,mr2,'ro')
plot([min(mrMaze) max(mrMaze)],p2(1)*[min(mrMaze) max(mrMaze)] + p2(2),'r')

