function VecTimeDay = GetTimeOfTheDay_MC(vecTime, sav)


%INPUT:


% disp('GetTimeOfTheDay_MC')
res=pwd;

%% check inputs
if ~exist('sav','var')
    sav=1;
end

%% get start time of the recording

    filename=pwd;
    filedate=filename(end-5:end);
    TimeBeginRecording=str2num(filedate)/1e4;


%       infos = load('behavResources.mat', 'TimeDebRec');
%     
%         day= infos.TimeDebRec;
        
%%
%convert in hours of the day
t=vecTime./3600;
t2=t./1e4;

VecTimeDay=[];
for i=1:length(t2)
%     VecTimeDay=[VecTimeDay;str2num(TimeBeginRecording)+t2(i)];
    VecTimeDay=[VecTimeDay;TimeBeginRecording+t2(i)];

end


%% save

if sav
    save behavResources -append VecTimeDay
end

cd(res)



