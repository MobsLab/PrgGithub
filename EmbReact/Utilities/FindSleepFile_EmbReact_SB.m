
% FindSleepFile - This function takes a mouse from the EmbReact project and locates the
% baseline sleep folder that was closest in date or the sleep folder during task
% 19.02.2018 SB
%
%
%%  USAGE
% FileName=FindSleepFile(MouseNum,date)
%
%
%%  INFOS
%
% INPUT
%    MouseNum               Number of mouse ex : 805
%    date               	Date of reference experiment ex : 20171228
%
%  OUTPUT
%
%    FileName               FileName.Base = closest baseline day
%                           FileName.Umaze = sleep post umaze

function FileName=FindSleepFile_EmbReact_SB(MouseNum,date)

%% Closest baseline sleep
Files=PathForExperimentsEmbReact('BaselineSleep');

date=num2str(date);
if findstr(date,'201') ==5
    date = [date(5:8) date(3:4) date(1:2)];
end

if length(date)==7
    date = ['0' date];
end

datevector=[str2num(date(1:4)) str2num(date(5:6)) str2num(date(7:8)) 0 0 0];

% Get data for mouse of interest - if there is one
CandidateSleepDays=[];
for mm=1:length(Files.path)
    CandidateSleepDays(mm)=Files.ExpeInfo{mm}{1}.nmouse==MouseNum;
end
MouseNumber=find(CandidateSleepDays);

% if mouse has a baseline sleep day get the one that is closest to
% specified date
if not(isempty(MouseNumber))
    for d=1:length(Files.ExpeInfo{MouseNumber})
        Dates{d}=Files.ExpeInfo{MouseNumber}{d}.date;
    end
    
    for d=1:length(Dates)
        tempdate=num2str(Dates{d});
        if findstr(tempdate,'201') ==5
            tempdate = [tempdate(5:8) tempdate(3:4) tempdate(1:2)];
        end
        
        
        if length(tempdate)==7
            tempdate = ['0' tempdate];
        end
        Candidatedatevector{d}=[str2num(tempdate(1:4)) str2num(tempdate(5:6)) str2num(tempdate(7:8)) 0 0 0];
        TimeDiff(d)=abs(etime(Candidatedatevector{d},datevector));
    end
    [val,ind]=min(TimeDiff);
    FileName.Base=Files.path{MouseNumber}{ind};
else
    FileName.Base=[];
end

%% UMaze day sleep, use post maze sleep because in general this is where the mice sleep the most
SleepPostSessions = {'SleepPostUMaze','SleepPost_EyeShock','SleepPost_PreDrug',...
    'SleepPost_PreDrug_TempProt','SleepPostEPM','SleepPostNight'};

clear Dates CandidateSleepDays
% scan through each kind of session to find mouse of interest
MouseNumber = [];
ss=1;
clear TimeDiff
while isempty(MouseNumber) & ss<= length(SleepPostSessions)
    Files=PathForExperimentsEmbReact(SleepPostSessions{ss});
    
    % Get data for mouse of interest - if there is one
    CandidateSleepDays=[];
    Dates = [];
    for mm=1:length(Files.path)
        CandidateSleepDays(mm)=Files.ExpeInfo{mm}{1}.nmouse==MouseNum;
        if ischar(Files.ExpeInfo{mm}{1}.date)
            Dates(mm)=eval(Files.ExpeInfo{mm}{1}.date);
        else
            Dates(mm)=(Files.ExpeInfo{mm}{1}.date);
        end
    end
    MouseNumber=find(CandidateSleepDays);
    
    ss=ss+1;
end

try
    if not(isempty(MouseNumber))
        Dates=Dates(MouseNumber);
        for d=1:length(Dates)
            tempdate=num2str(Dates(d));
            if findstr(tempdate,'201') ==5
                tempdate = [tempdate(5:8) tempdate(3:4) tempdate(1:2)];
            end
            
            if length(tempdate)==7
                tempdate = ['0' tempdate];
            end
            Candidatedatevector{d}=[str2num(tempdate(1:4)) str2num(tempdate(5:6)) str2num(tempdate(7:8)) 0 0 0];
            TimeDiff(d)=abs(etime(Candidatedatevector{d},datevector));
        end
        [val2,ind2]=min(TimeDiff);
        FileName.UMazeDay=Files.path{MouseNumber}{ind2};
    else
        FileName.UMazeDay=[];
    end
catch
    FileName.UMazeDay=[];
end

end