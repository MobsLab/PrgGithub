load('TimeRec.mat')
load('LFPData/LFP0.mat')
totdur = max(Range(LFP,'s'))
    EndTime = TimeEndRec*3600';
BeginTime = EndTime - totdur;
BeginTime [3600 60 1]
MakeData_RealTime


%%% a trier

load('TimeRec.mat')
load('/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3/LFPData/LFP0.mat')
totdur = max(Range(LFP,'s'))
totdur =
                31912.7032
etime(TimEndRec,[0,0,31912]
 etime(TimEndRec,[0,0,31912]
                            ↑
Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
 
Did you mean:
etime(TimEndRec,[0,0,31912]
 etime(TimEndRec,[0,0,31912]
                            ↑
Error: Expression or statement is incorrect--possibly unbalanced (, {, or [.
 
Did you mean:
etime(TimeEndRec,[0,0,31912])
Index exceeds matrix dimensions.
Error in etime (line 41)
    (t1(:,4:6) - t0(:,4:6))*[3600; 60; 1]; 
etime(TimeEndRec,[0,0,31912]))
 etime(TimeEndRec,[0,0,31912]))
                              ↑
Error: Unbalanced or unexpected parenthesis or bracket.
 
etime(TimeEndRec,[0,0,31912])
Index exceeds matrix dimensions.
Error in etime (line 41)
    (t1(:,4:6) - t0(:,4:6))*[3600; 60; 1]; 
BeginTime = totdur*[3600 60 1]';
BeginTime
BeginTime =
              114885731.52
               1914762.192
                31912.7032
totdur = max(Range(LFP,'s'))
totdur =
                31912.7032
totdur
totdur =
                31912.7032
BeginTime = TimEndRec*[3600 60 1]';
Undefined function or variable 'TimEndRec'. 
Did you mean:
TimEndRec
Undefined function or variable 'TimEndRec'. 
Did you mean:
load('TimeRec.mat')
BeginTime = TimEndRec*[3600 60 1]';
Undefined function or variable 'TimEndRec'. 
Did you mean:
BeginTime = TimeEndRec*[3600 60 1]';
BeginTime
BeginTime =
       65138
BeginTime = EndTime - totdur;
Undefined function or variable 'EndTime'. 
EndTime = TimeEndRec*[3600 60 1]';
BeginTime = EndTime - totdur;
BeginTime
BeginTime =
                33225.2968
BeginTime / [3600 60 1]