% BODY_PART_DISTANCE

[filename,pathname]=uigetfile('*.csv','Select the DeepLabCut tracking file')
DLC=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)
% Extract the body parts coordinates
Nose_X = DLC(:,2);
Nose_Y = DLC(:,3);
REar_X = DLC(:,5);
REar_Y = DLC(:,6);
LEar_X = DLC(:,8);
LEar_Y = DLC(:,9);
Neck_X = DLC(:,11);
Neck_Y = DLC(:,12);
Body_X = DLC(:,14);
Body_Y = DLC(:,15);
TailBase_X = DLC(:,17);
TailBase_Y = DLC(:,18);
TailCenter_X = DLC(:,20);
TailCenter_Y = DLC(:,21);

XVector=[Nose_X,REar_X,LEar_X,Neck_X,Body_X,TailBase_X,TailCenter_X];
n_features=size(XVector,2);
XMatrix=permute(repmat(XVector,[1,1,n_features]),[2,3,1]);
dX=XMatrix-permute(XMatrix,[2,1,3]);
YVector=[Nose_Y,REar_Y,LEar_Y,Neck_Y,Body_Y,TailBase_Y,TailCenter_Y];
YMatrix=permute(repmat(YVector,[1,1,n_features]),[2,3,1]);
dY=YMatrix-permute(YMatrix,[2,1,3]);
Distances=sqrt(dX.*dX+dY.*dY);

%Plot the histograms of duistances
%Between the two ears
hist(squeeze(Distances(3,2,:)),100)
Thresh1=ginput(1)
%Between Nose and Neck
hist(squeeze(Distances(4,1,:)),100)
Thresh2=ginput(1)
%Nose to tail base
hist(squeeze(Distances(1,6,:)),100)
Thresh3=ginput(1)
%Tail base to tail center
hist(squeeze(Distances(6,7,:)),100)
Thresh4=ginput(1)
%Now we plot all these distances and see if unusual values for different
%metrics occur simultaneously (are the signature of a specific behaviour
%such as rearing or risk assessment
NoseBase=squeeze(Distances(1,6,:));%Distance from nose to tailbase indicates body elongation/straightness
REarBody=squeeze(Distances(2,5,:));%Distance from right ear and left ear to body center indicates direction of rotation of head
LEarBody=squeeze(Distances(3,5,:));
REarBase=squeeze(Distances(2,6,:));%Same but with ears and tail base
LEarBase=squeeze(Distances(3,6,:));
X=[NoseBase REarBody LEarBody REarBase LEarBase];


HeadDirection=VectorsAngle((Nose_X*0)+1,Nose_X*0,Nose_X-Neck_X,Nose_Y-Neck_Y); %First vector is (+1,0) as a reference for the head direction angle, we use Neck_X to get same length vectors (in the time/frames dimension)
jet_wrap = vertcat(jet,flipud(jet));
colormap(jet_wrap)


BodyElongationCm = Distance(Nose_X/Ratio_IMAonREAL,Nose_Y/Ratio_IMAonREAL,TailBase_X/Ratio_IMAonREAL,TailBase_Y/Ratio_IMAonREAL);
figure;plot(BodyElongationCm);xlabel('Frame #');ylabel('Body length in cm');title('Evolution of a mouse body length (from nose to tail base)');
MouseSpeed = [0;sqrt(diff(Body_X).*diff(Body_X)+diff(Body_Y).*diff(Body_Y))];

TrackDLCvsOld = Distance(Body_X/Ratio_IMAonREAL,Body_Y/Ratio_IMAonREAL,PosMatInit(:,2),PosMatInit(:,3));
figure,hist(TrackDLCvsOld,100) %Difference in position tracked by DeepLabCut and the old algorithm, in cm
xlabel('Distance between the two tracking algorithms in cm');
title('Distribution of the distance (in cm) for body center tracking using DLC and Centroïd tracking')

figure;plot(PosMatInit(:,2),PosMatInit(:,3),'.');hold on;plot(Body_X/Ratio_IMAonREAL,Body_Y/Ratio_IMAonREAL,'.');legend('Body centroïd location','DeepLabCut body center');
title('Comparison of an example trajectory of body center from DeepLabCut and from the Centroïd tracking')
