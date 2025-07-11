
%---------------------------------------------------

res=pwd;

%---------------------------------------------------
%                   load Intan Event Signal
%---------------------------------------------------
load([res,'/LFPData/LFP',num2str(0)]);

Tone=Data(LFP);
Time=Range(LFP);
figure, plot(Time,Tone)

%---------------------------------------------------
% selection of Digital Input
%---------------------------------------------------
disp(' ')
value2=input(' what value for Event 2 detection ? (value below mean signal)  ')
disp(' ')
B=find(Tone==value2);

Event2=[];
a=1;
for i=1:length(B)-1
    if Time(B(i+1))-Time(B(i))>1000
        Event2(a)=Time(B(i));
        a=a+1;
    end
end
Tone=Event2';
hold on, plot(Event2,value2,'go','markerfacecolor','r')

disp(' ')
TOTO=input('was it single or sequence tone paradigm ? ');
disp(' ')

if strcmp('Single', TOTO)
    SingleTone=Tone;
    save ToneEvent SingleTone
elseif strcmp('Seq', TOTO)
    SeqTone=Tone; 
    save ToneEvent SeqTone 
end

%---------------------------------------------------
% selection of Digital Input 1
%---------------------------------------------------
% a=1;
% disp(' ')
% value1=input(' what value for Event 1 detection ? (value below mean signal) ')
% disp(' ')
% B=find(Tone<value1);
% for i=1:length(B)-1
%     if B(i+1)-B(i)<1.1
%         C(a,1)=B(i);
%         a=a+1;
%     end
% end
% Event1=Time(C);
% 
% Event1a=[Event1(find(Event1<Event2(1)-1));Event1(find(Event1>Event2(2999)+1))];
% Event1b=[];
% 
% a=1;
% for i=1:length(Event1a)-1
%     if Event1a(i+1)-Event1a(i)>50000
%         Event1b(a)=Event1a(i);
%         a=a+1;
%     end
% end
% SingleTone=Event1b';
% hold on, plot(Event1b,value1,'ro','markerfacecolor','g')

%---------------------------------------------------



