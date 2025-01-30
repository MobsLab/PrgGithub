function A = Analyze(A)

A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};

A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};

A = getResource(A,'ReactTimeCourseS1');
reacttimeCourseS1 = reacttimeCourseS1{1};

A = getResource(A,'ReactTimeCourseS2');
reacttimeCourseS2 = reacttimeCourseS2{1};
A = getResource(A,'PosXS',dset);
XS = XS{1};
A = getResource(A,'PosYS',dset)
YS=YS{1};



Figures_dir = [dataDir filesep 'ReactTimeCourse' filssep 'ReactThetaMvt'];

dset = current_dataset(A);
[dummy1,dataset,dummy2] = fileparts(current_dir(A));

eegfname = [dset filesep dataset 'eeg5.mat'];
if exist([eegfname '.gz'])
    display(['unzipping file ' eegfname]);
    eval(['!gunzip ' eegfname '.gz']);
end
load(eegfname)
display(['zipping file ' eegfname]);
eval(['!gzip ' eegfname]);

eegS1 = Restrict(EEG5,sleep1Epoch);
eegS2 = Restrict(EEG5,sleep2Epoch);

b = fir1(96,[0.005 0.01]);

deegS1 = Data(eegS1);
deegS1Filt = filtfilt(b,1,deegS1);
eegS1std = std(deegS1Filt);
eegS1Filt = tsd(Range(eegS1),deegS1Filt);
deegS2 = Data(eegS2);
deegS2Filt = filtfilt(b,1,deegS2);
eegS2std = std(deegS2Filt);
eegS2Filt = tsd(Range(eegS2),deegS2Filt);

[thSt1 thEnd1] = findTheta(eegS1Filt,0.5*eegS1std,0.5*eegS1std,'CloseThreshold',200000,'MinThetaDuration','100000');
[thSt2 thEnd2] = findTheta(eegS2Filt,0.5*eegS2std,0.5*eegS2std,'CloseThreshold',200000,'MinThetaDuration','100000');
clear EEG5 eegS1 eegS2 eegS1Filt eegS2Filt

XS1 = Restrict(XS,sleep2Epoch);
YS1 = Restrict(YS,sleep2Epoch);

XS2 = Restrict(XS,sleep2Epoch);
YS2 = Restrict(YS,sleep2Epoch);

x1 = Data(XS1) - mean(Data(XS1));
y1 = Data(YS1) - mean(Data(YS1));
x2 = Data(XS2) - mean(Data(XS2));
y2 = Data(YS2) - mean(Data(YS2));

d1 = sqrt(x1.*x1 + y1.*y1);
d2 = sqrt(x2.*x2 + y2.*y2);


fh = figure(1),clf

subplot(1,2,1)
	
	times = Range(reactTimeCourseS1);
	rg = [1:10:length(times)];
	times = times(rg)/10000;
	thSt1 = Range(thSt1)/10000 - times(1);
	thEnd1 = Range(thEnd1)/10000 - times(1);
	if length(thEnd1)>length(thSt1); thEnd1(end)=[];end;

	Rsmooth = conv(Data(reactTimeCourseS1),gausswin(1200))/sum(gausswin(1200));
	Rsmooth = Rsmooth(600:end-600);
	RsmF = Rsmooth(rg);
	maxY = max(RsmF)+0.05;
	minY = min(RsmF)-0.05;
	
	
	hold on
	fill([thSt1';thSt1';thEnd1';thEnd1'],[minY maxY maxY minY]'*ones(1,length(thSt1)),'r')
	plot(times - times(1),RsmF,'LineWidth',3,'Color','k')
	plot(Range(XS1)/10000-times(1),maxY*d1/max(d1))


subplot(1,2,2)
	
	times = Range(reactTimeCourseS2);
	rg = [1:10:length(times)];
	times = times(rg)/10000;
	
	thSt2 = Range(thSt2)/10000 - times(1);
	thEnd2 = Range(thEnd2)/10000 - times(1);
	if length(thEnd2)>length(thSt2); thEnd2(end)=[];end;
	
	Rsmooth = conv(Data(reactTimeCourseS1),gausswin(1200))/sum(gausswin(1200));
	Rsmooth = Rsmooth(600:end-600);
	RsmF = Rsmooth(rg);
	maxY = max(RsmF)+0.05;
	minY = min(RsmF)-0.05;
	
	hold on
	fill([thSt2';thSt2';thEnd2';thEnd2'],[minY maxY maxY minY]'*ones(1,length(thSt2)),'r')
	plot(times - times(1),RsmF,'LineWidth',3,'Color','k')
	plot(Range(XS2)/10000-times(1),maxY*d2/max(d2))
	

saveas(fh,[Figures_dir filesep dataset 'ReactTimeCourse100msBins2minGW'],'png');
