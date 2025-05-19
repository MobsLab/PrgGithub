function [s,stor,trialLEN,reward]=get_frelist(exptevents,runclass,exptparams)
%function [s,stor,trialLEN]=get_frelist(exptevents,runclass);
%
s=[];stor=[];trialLEN=[];NOTAR=[];reward=[];
STIMULATION=0; dbAtten=[];
if strcmpi(runclass,'rts')
    runclass_sub=exptparams.TrialObject.ReferenceHandle.Type; else
    runclass_sub=''; end
for i=1:length(exptevents);
    tem=exptevents(i);
    if strfind(lower(exptevents(i).Note),'stimulation')
        STIMULATION=1;
    elseif strcmpi(exptevents(i).Note,'STIM,OFF')   %turn the target off
        NOTAR=[NOTAR;exptevents(i)];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && strcmpi(runclass_sub,'3stream')
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        tem1=textscan(tem.Note,'%s','delimiter',',');
        tem1{1}{2}=strrep(tem1{1}{2},'Note','');
        tem.Note=str2num(tem1{1}{2});
        if length(tem.Note)==1
            tem.Note(2)=NaN; end
        s=[s;tem];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && ~isempty(strfind(lower(exptevents(i).Note),'note'))
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        if strcmpi(runclass,'vbn')
            tem1=textscan(tem.Note,'%s','delimiter',',');
            tem.Note=str2num(strrep(tem1{1}{2},'Note','')); %remove character 'Note'
        else
            tem1=textscan(tem.Note,'%s');
            if strcmpi(runclass,'rts')
                tem.Note=textscan(tem1{1}{4},'%f','delimiter','_');
            else
                tem.Note=str2num(strrep(tem1{1}{4},'$',''));  %remove the '$' sign if existing
            end
        end
        s=[s;tem];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && any(strcmpi(runclass,{'ftc','mrd'}))
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        tem1=textscan(tem.Note,'%s','delimiter',',');
        tem.Note=str2num(tem1{1}{2});  %Frequency
        if strcmpi(runclass,'mrd')
            if length(tem1{1})==4
                dbAtten=[dbAtten;str2num(tem1{1}{4})]; else
                dbAtten=[dbAtten;0];
            end
        end
        s=[s;tem];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && any(strcmpi(runclass,{'ptd','tst','cch','fms','fmd','clt','clk'})) ...
            && isempty(strfind(exptevents(i).Note,'TORC'))
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        tem1=textscan(tem.Note,'%s','delimiter',',');
        if ~isempty(strfind(tem1{1}{2},'FM'))   %for FM set  add 05/26/2010
            [fs,fe]=textscan(tem1{1}{2}(3:end),'%d %d','delimiter','-');  %start and ending frequency
            tem.Note=[fs fe];
        elseif any(strcmpi(runclass,{'fms','fmd'})) && isempty(strfind(tem1{1}{2},'Silence'))
            tem1{1}{2}=strrep(tem1{1}{2},'$',''); %remove '$' sign
            [fs,fe]=textscan(tem1{1}{2},'%d %d','delimiter','-');
            tem.Note=[fs fe];
        else
            tem1{1}{2}=strrep(tem1{1}{2},'$',''); %remove '$' sign
            if strfind(tem1{1}{2},'Silence')   %for silence
                F_tem=NaN;
            else
                F_tem=str2num(tem1{1}{2});         %Frequency
            end
            if strcmpi(runclass,'fmd')
                tem.Note=[F_tem(1) NaN];
            else
                tem.Note=F_tem(1);
                if length(F_tem)==2, tem.Atten=F_tem(2);
                else tem.Atten=NaN; end
            end
        end
        s=[s;tem];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && any(strcmpi(runclass,{'pfs','srv','rts','mvc','voc','nse','sp1','wrd','abx'}))
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        tem1=textscan(tem.Note,'%s','delimiter',',');
        tem.Note=tem1{1}{2};  %sound file name
        s=[s;tem];
    elseif strcmpi(exptevents(i).Note(1:4),'stim') && ...
            (~isempty(strfind(exptevents(i).Note,'TORC')) || ~isempty(strfind(exptevents(i).Note,'ferret')))
        tem.target=length(strfind(lower(exptevents(i).Note),'target'));
        tem1=textscan(tem.Note,'%s','delimiter',',');
        if strfind(tem.Note,'.wav')    %used as distractor
            tem.Note=str2num(tem1{1}{4}); else
            tem.Note=str2num(tem1{1}{2}(10:11));  %reference TORC#1-30
        end
        if strcmpi(tem1{1}{3},'target')
            tem.Note=tem.Note+30;          %taget: shift 30.
        end
        stor=[stor;tem];
    elseif strcmpi(exptevents(i).Note,'TRIALSTOP')
        trialLEN=[trialLEN;exptevents(i)];
    elseif strcmpi(exptevents(i).Note,'BEHAVIOR,PUMPOFF')
        reward=[reward;exptevents(i).Trial exptevents(i).StartTime exptevents(i).StopTime];
    end
end
if STIMULATION
    if ~isempty(dbAtten)
        dbAtten(find([s.target]))=[];
    end
    s(find([s.target]))=[];  %remove target paired with stimulation, added by py 5/13/08
end

trialLEN=[trialLEN.Trial;trialLEN.StartTime]';
if strcmpi(runclass,'rts')
    if strcmpi(exptparams.TrialObject.ReferenceHandle.Type,'New_Daniel')
        stiname=exptparams.TrialObject.ReferenceHandle.Names;
        for i=1:length(s)
            [a1,a2,a3]=textscan(s(i).Note,'%s%d%d','delimiter','-');
            a1=strmatch(lower(a1),lower(stiname),'exact');
            ss(i,1:6)=[s(i).Trial a1 s(i).StartTime s(i).StopTime a2 a3];  %tr#, tr-name, on and off, note-id (5:6)
        end
        s=ss;
        s(:,3:4)=round(s(:,3:4)*1000);   %converting timing into msec.
        return;
    elseif strcmpi(exptparams.TrialObject.ReferenceHandle.Type,'rshepard')
        for i=1:length(s)
            ss=deblank(s(i).Note);
            s(i).Note=str2num(ss(end-1:end));
        end
    elseif strcmpi(exptparams.TrialObject.ReferenceHandle.Type,'oddball2')
        ss(:,1)=[s.Trial]';
        ss(:,3)=[s.StartTime]';
        ss(:,4)=[s.StopTime]';
        ss(:,5:7)=cat(2,s.Note)';  %attenuation, freq, duration (ratio)
        ss(:,7)=ss(:,7)*exptparams.TrialObject.ReferenceHandle.NoteDur;   %duration in sec
        ss(:,5)=ss(:,5)+exptparams.TrialObject.OveralldB;  % dB level
        s=ss;
        s(:,3:4)=round(s(:,3:4)*1000);   %converting timing into msec.
        return;
    end
end

if any(strcmpi(runclass,{'PFS','mvc','voc','nse','sp1','wrd','abx','srv'})) ||...
        (strcmpi(runclass,'rts') && strcmpi(exptparams.TrialObject.ReferenceHandle.Type,'Seq_Daniel'))    %for Prefontal screen sound set
    if strcmpi(runclass,'srv')
        fn=char(exptparams.TrialObject.ReferenceHandle.Names);
    else
        fn=unique(char(exptparams.TrialObject.ReferenceHandle.Names),'rows');
    end
    for i=1:length(s)
        s(i).Note=strmatch(deblank(s(i).Note),fn);
    end
end
if ~isempty(s)
    for i=1:length(s)
        note_len(i)=length(s(i).Note);
    end
    if min(note_len)<max(note_len) %in MRD task with use probe option
        for i=1:length(s)
            if note_len(i)<max(note_len)
                s(i).Note(max(note_len))=0;  %padded with zero if no value.
            end
        end
    end
end
if ~isempty(s)
    FM=0;
    if isfield(s,'Atten')
        if all(isnan([s.Atten]))
            for ji = 1:length(s)
                s(ji).Atten = exptparams.TrialObject.OveralldB;
            end
        end
        s=[s.Trial;s.Note;s.StartTime;s.StopTime;s.target;s.Atten]';
        s(:,3:4)=round(s(:,3:4)*1000);   %converting timing into msec.
    elseif length(s(1).Note)>=2   %for FM set
        if ~strcmpi(runclass,'mrd'), FM=1; end
        fm=cat(1,s.Note);   %FM frequency
        s=[s.Trial;s.Trial;s.Trial;s.StartTime;s.StopTime;s.target]';
        s(:,2:3)=fm(:,1:2);
        s(:,4:5)=round(s(:,4:5)*1000);   %converting timing into msec..
    else
        s=[s.Trial;s.Note;s.StartTime;s.StopTime;s.target]';
        s(:,3:4)=round(s(:,3:4)*1000);   %converting timing into msec.
    end
end
if ~isempty(stor)
    stor=[stor.Trial;stor.Note;stor.StartTime;stor.StopTime;stor.target]';
    stor(:,3:4)=round(stor(:,3:4)*1000);   %converting timing into msec.
end

if ~isempty(NOTAR)
    for i=1:length(NOTAR)
        trialLEN(trialLEN(:,1)==NOTAR(i).Trial,2)=NOTAR(i).StartTime;
        s(s(:,1)==NOTAR(i).Trial & s(:,5)==1,:)=[];    %delete the target form the trial turn off before it appears
        if ~isempty(stor)
            stor(stor(:,1)==NOTAR(i).Trial & stor(:,5)==1,:)=[];
        end
    end
end

if isempty(s), return; end
if strcmpi(runclass,'tst') && (FM==0)
    s=s(:,[1:4 6]);
elseif ~strcmpi(runclass,'ptd') && (FM==0)
    s(:,end)=[];
elseif ~any(isnan(s(:,2))) && strcmpi(runclass,'ptd')   %return the reference only
    %s=s(s(:,5)==0,[1:4 6]);
end
if strcmpi(runclass,'mrd') && ~isempty(dbAtten)
    if size(s,2)==4
        s(:,5)=0; else
        s=s(:,[1 2 4 5 3]);  %move 2nd feature to c5
    end
    s(:,6)=dbAtten;
end
