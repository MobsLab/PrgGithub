function CompressFrames(FrameFolder,SaveFolder,Options)


%%  CompressFrames(FrameFolder,SaveFolder,Options)
% FrameFolder contains the frames
% SaveFolder is the folder where the frames should be saved
% Options contains the information that the code needs to run
%
% Options.DownSample
    %=1, if you don't want to downsample
    %=n if you want to take every n frames, n should be larger than 2,
    %1 will have the same effect of 0
% Options.RemoveMask
    %=1 if you want only to save the changes in pixels inside the mask
    %=0 if you want to save everything
% Options.Mask
    % You only need to provide this if RemoveMask is set to 1
    % Should contain the mask you want to apply to the frames, needs to
    % be the same size
% Options.Visualization
    % 1 if you want to view the first 100 frames reconstruction
    % 0 otherwise
% If you do not provide any input to this function, you will be asked to
% provide it with a user interface
%
% Example code : 
% FrameFolder='/media/DataMOBsRAIDN/SophieBToProcess/ProjectOBStim/Mouse458/20161114/FEAR-Mouse-458-14112016-01-Baseline/F14112016-0001/';
% SaveFolder='/media/DataMOBsRAIDN/SophieBToProcess/ProjectOBStim/Mouse458/20161114/FEAR-Mouse-458-14112016-01-Baseline/';
% Options.DownSample=2; 
% Options.RemoveMask=1;
% Options.Mask=mask,
% Options.Visualization=0;
% CompressFrames(FrameFolder,SaveFolder,Options)

try,FrameFolder;
catch, FrameFolder=uigetdir('Please click on the folder that contains the frames');
end
if ~(FrameFolder(end)==filesep),FrameFolder=[FrameFolder filesep]; end
try,SaveFolder;
catch, SaveFolder=uigetdir('Please click on the folder in which the compressed file should be saved');
end
if ~(SaveFolder(end)==filesep),SaveFolder=[SaveFolder filesep]; end


% Find the first file that is a frame
cd(FrameFolder)
ls=dir;
cd ..
NotFrameStarted=1;
i=0;
while NotFrameStarted
    i=i+1;
    if findstr(ls(i).name,'frame')
        NotFrameStarted=0;
    end
end
StartFrames=i;


% Estimate the sampling rate
load([FrameFolder,ls(StartFrames).name])
CompressionInfo.OrigTime=datas.time;

for i=StartFrames:1:min(length(ls),StartFrames+100)
    load([FrameFolder,ls(i).name])
    timeEstimate(i-StartFrames+1)=etime(datas.time,CompressionInfo.OrigTime);
end
SRest=median(diff(timeEstimate));
disp(['Sampling rate is around ',num2str(round(1./SRest)),'Hz'])

try, Options;
catch,
    resp=inputdlg({['DownSampling 1:n,actual SR: ',num2str(round(1./SRest)),'Hz'],...
        'RemoveMask 1/0','Visualization 1/0'});
    Options.DownSample=eval(resp{1});
    Options.RemoveMask=eval(resp{2});
    Options.Visualization=eval(resp{3});
    if Options.RemoveMask==1
        MaskFile=uigetfile('Please click on the file containing the mask');
        MaskFileCont=load(MaskFile);
        ListOfFields=fieldnames(MaskFileCont);
        FieldLocation=strfind(ListOfFields,'mask');
        FieldLocation=[find(~cellfun(@isempty,FieldLocation))];
        Options.Mask=eval(['MaskFileCont.',ListOfFields{FieldLocation}]);
    end
end




% Get the frame size
load([FrameFolder,ls(StartFrames).name ])
FrameSize=size(datas.image);


% Options.Mask=uint8(Options.Mask);

% If want to check before downample, calculate framerate

% Main part of code
b=double(zeros(FrameSize));
tic
numFr=1;
for i=StartFrames:Options.DownSample:length(ls)
    load([FrameFolder,ls(i).name])
    a2=double(datas.image.*Options.Mask);
    b2=double(floor(a2/8));
    diffb=(b2-b);
    vals=find(abs(diffb)>0);
    CompressionInfo.Location{numFr}=uint32(vals);
    CompressionInfo.Value{numFr}=int8((diffb(vals)));
    CompressionInfo.Time(numFr)=etime(datas.time,CompressionInfo.OrigTime);
    b=b2;
    numFr=numFr+1;
end
toc

disp('Compression done')

% Visualize to check
if Options.Visualization
    figure;
    b=double(zeros(FrameSize));
    numFr=1;
    for i=StartFrames:Options.DownSample:min([length(ls),100])
        subplot(121)
        load([FrameFolder,ls(i).name])
        imagesc(datas.image)
        title('original')
        subplot(122)
        bnew=b(:);
        bnew(CompressionInfo.Location{numFr})=bnew(CompressionInfo.Location{numFr})+double(CompressionInfo.Value{numFr});
        bnew=reshape(bnew,FrameSize(1),FrameSize(2));
        imagesc(bnew)
        title('reconstructed')
        pause(0.05)
        b=bnew;
        numFr=numFr+1;
    end
end

disp('Saving...')
save([SaveFolder,'CompressedFramesbis.mat'],'Options','CompressionInfo','-v7.3')
disp('Saved')
close all
end