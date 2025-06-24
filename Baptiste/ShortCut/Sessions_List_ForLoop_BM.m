
if convertCharsToStrings(Session_type{sess})=='Fear'
    FolderList=FearSess;
elseif convertCharsToStrings(Session_type{sess})=='Cond'
    FolderList=CondSess;
elseif convertCharsToStrings(Session_type{sess})=='Ext'
    FolderList=ExtSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPre'
    FolderList=CondPreSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPost'
    FolderList=CondPostSess;
elseif convertCharsToStrings(Session_type{sess})=='TestPre'
    FolderList=TestPreSess;
elseif convertCharsToStrings(Session_type{sess})=='TestPost'
    FolderList=TestPostSess;
elseif convertCharsToStrings(Session_type{sess})=='CondBlockedShock'
    FolderList=CondBlockedShockSess;
elseif convertCharsToStrings(Session_type{sess})=='CondBlockedSafe'
    FolderList=CondBlockedSafeSess;
elseif convertCharsToStrings(Session_type{sess})=='ExtShock'
    FolderList=ExtShockSess;
elseif convertCharsToStrings(Session_type{sess})=='ExtSafe'
    FolderList=ExtSafeSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPreShock'
    FolderList=CondPreShockSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPreSafe'
    FolderList=CondPreSafeSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPostShock'
    FolderList=CondPostShockSess;
elseif convertCharsToStrings(Session_type{sess})=='CondPostSafe'
    FolderList=CondPostSafeSess;
elseif convertCharsToStrings(Session_type{sess})=='Habituation'
    FolderList=HabSess;
elseif convertCharsToStrings(Session_type{sess})=='Calib'
    FolderList=CalibSess;
elseif convertCharsToStrings(Session_type{sess})=='FirstExtSess'
    FolderList=FirstExtSess;
elseif convertCharsToStrings(Session_type{sess})=='TestPostPre'
    FolderList=TestPostPreSess;
elseif convertCharsToStrings(Session_type{sess})=='TestPostPost'
    FolderList=TestPostPostSess;
elseif convertCharsToStrings(Session_type{sess})=='ExtPre'
    FolderList=ExtPreSess;
elseif convertCharsToStrings(Session_type{sess})=='ExtPost'
    FolderList=ExtPostSess;
elseif convertCharsToStrings(Session_type{sess})=='LastCondPre'
    FolderList=LastCondPreSess;
    elseif convertCharsToStrings(Session_type{sess})=='FirstCondPre'
FolderList=FirstCondPreSess;
elseif convertCharsToStrings(Session_type{sess})=='LastCondPost'
    FolderList=LastCondPostSess;
    elseif convertCharsToStrings(Session_type{sess})=='FirstCondPost'
FolderList=FirstCondPostSess;
elseif convertCharsToStrings(Session_type{sess})=='FirstExtPre'
    FolderList=FirstExtPreSess;
    
    % elseif convertCharsToStrings(Session_type{sess})=='sleep_pre'
%     FolderList=SleepSess(1);
% elseif convertCharsToStrings(Session_type{sess})=='sleep_post'
%     FolderList=SleepPostSess;
end




