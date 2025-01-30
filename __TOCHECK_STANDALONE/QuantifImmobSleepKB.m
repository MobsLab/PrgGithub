function [Movtsd,Perc,Freeze,Freeze2]=QuantifImmobSleepKB(filename,filenameRef,fac,th,thtps,mask,param,lim)

% filename='BULB-Mouse-47-08112012-19-SleepPOSTdpcqpx-EIB-1.avi';
% filenameRef='BULB-Mouse-47-08112012-Ref-1.avi';
% load('Ref.mat')
% fac=7;
% th=2;
% thtps=2;

%surface mouse = 12000 pixels
%fac = number of frame to identify movment default value 7
%th = threshold freezing default value 2
%thtps = minimum time for freezing periods default valut 2s
%filename = video souris
%filenameref = video de r�ference du contexte sans souris

%% Initialization
% ----------------------
try
    plo=param(1);
    Plethysmographe=param(2);
catch
    plo=0;
    Plethysmographe=0;
end

% ----------------------



OBJ = mmreader(filename);
OBJ2 = mmreader(filenameRef);
numFrames = get(OBJ, 'numberOfFrames');
dur = get(OBJ, 'Duration');
dt=dur/numFrames; 

f=1/dt;

try 
    lim;
catch
    lim=numFrames;
end

% ---------------------------------------------
% checking existence of or creating a .mat file

if strcmp(filename(end-5:end-3),'-1.') || strcmp(filename(end-5:end-3),'-2.')
    filename=filename(1:end-6);
else
    filename=filename(1:end-4);
end


% try
%     load([filename,'.mat'])
%     Pos;
% catch
%     disp(['   Tracking is not done. ',filename,'.mat will contain only the parameters of immobility.'])
%     init=0;
%     save([filename,'.mat'],'init')
% end

% ---------------------------------------------
% -------------- waitbar ----------------------

if plo==0
    h = waitbar(0, 'Immobility...');
else
    figure('color',[1 1 1]), num=gcf;
end

pas=floor(fac/2);
disp(['   pas = ',num2str(pas),'      Begin immobility ...'])

a=1;
t=[1:pas:lim-fac]*dt;


% ---------------------------------------------
%% Freezing mesurement

for ind=1:pas:lim-fac
    
    %keyboard
    % ---------------------------------------------
    %differenciel entre la vid�o et la video reference sans souris, 
    vidFramesRef = read(OBJ2,1);
    if Plethysmographe==0, vidFramesRef(vidFramesRef>50)=50; end
    vidFramesA = read(OBJ,ind);
    vidFrames1 = vidFramesRef-vidFramesA;
    vidFrames1 (vidFrames1>80)=200;
    vidFramesB = read(OBJ,ind+fac);
    vidFrames2 = vidFramesRef-vidFramesB;
    vidFrames2 (vidFrames2>80)=200;
    
    Mov1=vidFrames1(:,:,3,1);
    Mov2=vidFrames2(:,:,3,1);
    
    Im1=single(Mov1);
    Im2=single(Mov2);
    Im1(mask==0)=0;
    Im2(mask==0)=0;
    Im1(Im1>65)=65;
    Im2(Im2>65)=65;
    A(a)=sqrt(sum(sum(((Im2-Im1).*(Im2-Im1)))))/12000/2*100;


    % --------------------------------------------
    %image et graphique en % de difference
    if plo
        figure(num), clf
        subplot(2,3,1),imagesc(vidFramesRef(:,:,:,1))
        subplot(2,3,2),imagesc(vidFrames1(:,:,:,1))
        subplot(2,3,3),imagesc(vidFrames2(:,:,:,1))
        subplot(2,3,4),imagesc(Im2-Im1), caxis([-50 50])
        subplot(2,3,5:6),plot(t(1:a),(A),'k','linewidth',2), title([num2str(t(floor(a))),'s'])
        try
            xlim([t(a)-15 t(a)]);
        end
        ylim([0 50]);
        
    else
        waitbar(ind/numFrames, h);
    end
    a=a+1;    
end

if plo==0, close(h);end

%% Final computation and Save

Movtsd=tsd(t*1E4',SmoothDec(A',1));
Freeze=thresholdIntervals(Movtsd,th,'Direction','Below');
Freeze2=dropShortIntervals(Freeze,thtps*1E4);

Perc=sum(End(Freeze2,'s')-Start(Freeze2,'s'))/dur*100;


%save([filename,'.mat'],'Movtsd','Perc','Freeze','Freeze2','-append');


%calcul du pourcentage de freezing minute par minute
%for i=(1:9);
%min(i)=((i*1800):(((i+1)*1800)-fac))*dt;


%Movtsd(i)=tsd(min(i)*1E4',SmoothDec(A',1));
%FreezeMin(i)=thresholdIntervals(Movtsd(i),th,'Direction','Below');
%Freeze2Min(i)=dropShortIntervals(FreezeMin(i),thtps*1E4);

%PercMin(i)=sum(End(Freeze2Min(i),'s')-Start(Freeze2Min(i),'s'))/dur*100;
%end
%Perc=(PercMin(0):PercMin(9)       

%keyboard

