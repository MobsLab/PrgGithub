%% nwalign_revisited test, for more informations cf nwalign

load('behavResources_SB')
%Extract the body parts coordinates
file=dir('*.csv'); filename=file.name;
pathname=pwd;
DLC=csvread(fullfile(pathname,filename),3); 
Body_X = abs(DLC(:,14));
Body_Y = abs(DLC(:,15));
fact=15; % all data must be in '15 range' --> normalisation of the two coordinates
BehavX(:,1)=Data(Behav.Xtsd);
min_BehavX=min(Data(Behav.Xtsd)); BehavX(:,2)=BehavX(:,1)-min_BehavX;
max_BehavX=max(BehavX(:,2));
BehavX(:,2)=(BehavX(:,2))./max_BehavX;
BehavX(:,3)=round((BehavX(:,2).*fact)); % Behav.Xtsd in range fact
BehavX(:,4)=round((BehavX(:,2).*100)); %Behav.Xtsd in range 100
BehavY(:,1)=Data(Behav.Ytsd);
min_BehavY=min(Data(Behav.Ytsd)); BehavY(:,2)=BehavY(:,1)-min_BehavY;
max_BehavY=max(BehavY(:,2));
BehavY(:,2)=(BehavY(:,2))./max_BehavY;
BehavY(:,3)=round((BehavY(:,2).*fact)); % Behav.Xtsd in range fact
BehavY(:,4)=round((BehavY(:,2).*100)); %Behav.Xtsd in range 100
RangeX(:,1)=Range(Behav.Xtsd); 
 
min_BodyX=min(Body_X(:,1)); Body_X(:,2)=Body_X(:,1)-min_BodyX; max_BodyX=max(Body_X(:,2));
Body_X(:,2)=(Body_X(:,2))./max_BodyX; 
Body_X(:,3)=round((Body_X(:,2)).*fact); Body_X(:,4)=round((Body_X(:,2)).*100); 
min_BodyY=min(Body_Y(:,1)); Body_Y(:,2)=Body_Y(:,1)-min_BodyY; max_BodyY=max(Body_Y(:,2));
Body_Y(:,2)=(Body_Y(:,2))./max_BodyY; 
Body_Y(:,3)=round((Body_Y(:,2)).*fact); Body_Y(:,4)=round((Body_Y(:,2)).*100); 
 
XY_tsd=((BehavX(:,3).*(fact+1)+BehavY(:,3)));
BodyXY=(Body_X(:,3).*(fact+1)+Body_Y(:,3));

seq1=XY_tsd; seq2=BodyXY;
%Data must be converted in bits
intseq1 = uint8(seq1)';
intseq2 = uint8(seq2)';
 
% Generate homology matrix
X=[]; Y=[];
for i=1:16
X=[ones(1,16).*(i-1) X];
Y=[Y 0:15];
end
X=fliplr(X);
XY=max(max(squareform(pdist([X;Y]')))) - squareform(pdist([X;Y]'));
XY=XY-19;

%Use this matrix for the code 
ScoringMatrix = XY;
%others parameters (gapopen is the value for the penality to open the alignment 
%(must increase if path is not the right length)
algorithm = 1;
gapopen = -80;
gapextend = -80;

clear path
[score, path(:,2), path(:,1)] = bioinfoprivate.affinegapmex(intseq2, intseq1, ...
gapopen, gapextend, ScoringMatrix, algorithm);
 
path = path(sum(path,2)>0,:);
path = flipud(path);

%plotting GotFrame compared to prediction by the algorithm
figure
path(:,3)=path(:,2)>0;
imagesc(path(:,3))

Xtsd_real=BehavX(path(:,3)~=0,4); Ytsd_real=BehavY(path(:,3)~=0,4);
Xtsd_real(:,2)=(Xtsd_real(:,1)-Body_X(:,4));
Ytsd_real(:,2)=(Ytsd_real(:,1)-Body_Y(:,4));
Xtsd_real(:,2)=(Xtsd_real(:,2).*Xtsd_real(:,2));
Ytsd_real(:,2)=(Ytsd_real(:,2).*Ytsd_real(:,2));
XYtsd_real=sqrt(Xtsd_real(:,2)+Ytsd_real(:,2));
p1=sum(XYtsd_real); % total distance between behav/dlc

% interpolation of missing data 
Xtsd_real2=BehavX(:,4).*path(:,3);
Xtsd_real2(Xtsd_real2==0)=NaN;
nanx = isnan(Xtsd_real2);
t = 1:numel(Xtsd_real2);
Xtsd_real3=Xtsd_real2;
Xtsd_real3(nanx) = interp1(t(~nanx), Xtsd_real2(~nanx), t(nanx));

Ytsd_real2=BehavY(:,4).*path(:,3);
Ytsd_real2(Ytsd_real2==0)=NaN;
Ytsd_real3=Ytsd_real2;
Ytsd_real3(nanx) = interp1(t(~nanx), Ytsd_real2(~nanx), t(nanx));

%mean error by missed frame
distance=sqrt((Xtsd_real3(nanx)-BehavX(nanx,4)).^2+(Ytsd_real3(nanx)-BehavY(nanx,4)).^2);
lost_values=length(BehavX)-length(Body_X);
final_score=nansum(distance)./lost_values
figure
subplot(2,1,1)
plot(Xtsd_real3); hold on; plot(BehavX(:,4))
subplot(2,1,2)
plot(Xtsd_real3); hold on; plot(BehavX(:,4)+80)

%choose = input('interpolate data ? (y/n)','s');
choose='y';
if choose=='y'
    Video.Body_tXY(:,1)=RangeX(:,1);
    Video.Body_tXY(:,2)=Xtsd_real3;
    Video.Body_tXY(:,2)=Ytsd_real3;
elseif choose=='n'
    Video.Body_tXY(:,1)=RangeX(:,1);
    Video.Body_tXY(:,2)=Xtsd_real2;
    Video.Body_tXY(:,3)=Ytsd_real2;
else 
    disp('error')
end

load('Temperature.mat')
VideoTimes=RangeX(path(:,3)~=0,1);
    for ind =1:length(names_MF)
        Video.(names_MF{ind}).time=VideoTimes;
        Video.(names_MF{ind}).values=TemperatureCurve_corrected(ind,:)';
        %Video.(names_MF{ind}).values(end+1)=NaN; % if something is not
        %working
        Video.(names_MF{ind}).time(end+1:end+lost_values)=RangeX(path(:,3)==0,1);
        Video.(names_MF{ind}).values(end+1:end+lost_values)=NaN;
        [Video.(names_MF{ind}).sorted_times,Video.(names_MF{ind}).sorted_values]=sort(Video.(names_MF{ind}).time);
        Video.(names_MF{ind}).sorted_values=Video.(names_MF{ind}).values(Video.(names_MF{ind}).sorted_values);
    end
    
    
 

    