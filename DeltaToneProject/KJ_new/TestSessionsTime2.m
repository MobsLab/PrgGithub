% TestSessionsTime2
% 10.02.2017 KJ
%
% for each night, look at the time of each sessions
%
% see
%  


clear
load([FolderProjetDelta 'Data/TestSessionsTime.mat']) 

basal_sessions = cell(0);
deltatone_session = cell(0);
random_session = cell(0);

for p=1:length(session_res.name)
    if strcmpi(session_res.manipe{p},'Basal')  
        basal_sessions{end+1,1} = session_res.sessions{p}/(3600E4);
        basal_sessions{end,2} = p;
        
    elseif strcmpi(session_res.manipe{p},'DeltaToneAll')  
        deltatone_session{end+1,1} = session_res.sessions{p}/(3600E4);
        deltatone_session{end,2} = p;
        
    else
        random_session{end+1,1} = session_res.sessions{p}/(3600E4);
        random_session{end,2} = p;
    end
end













