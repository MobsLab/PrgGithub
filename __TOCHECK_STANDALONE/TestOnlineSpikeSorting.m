function TestOnlineSpikeSorting

%% Test the degree to which spike sorting on multiple channels with multiple thresholds allows for correct spike sorting
close all, clear all
chan=input('Please specify channel names');
chref=input('Please specify ref channel');
chnoise=input('Please specify noise channel');
SetCurrentSession;

[datanoise,indices] = GetFilData(chnoise,'intervals',[0 500]);
DtsdN=tsd(datanoise(:,1)*1E4, datanoise(:,2));
TotalEpoch=intervalSet(0,(datanoise(end,1)*1e4));
[dataref,indices] = GetFilData(chref,'intervals',[0 500]);
DtsdR=tsd(dataref(:,1)*1E4,dataref(:,2));

noisefig=figure, plot(Range(DtsdN,'s'),Data(DtsdN))
% [noisx,noisy]=ginput(2)
noisy=[-940;472];
NoiseEp=thresholdIntervals(DtsdN,noisy(1),'Direction','Below');
NoiseEp=mergeCloseIntervals(NoiseEp,1e4);
NoiseEp1=thresholdIntervals(DtsdN,noisy(2),'Direction','Above');
NoiseEp1=mergeCloseIntervals(NoiseEp1,1e4);
NoiseEp=Or(NoiseEp,NoiseEp1);
NoiseEp=CleanUpEpoch(NoiseEp);
hold on
plot(Range(Restrict(DtsdN,NoiseEp),'s'),Data(Restrict(DtsdN,NoiseEp)),'g')
pause(3)
% delete(noisefig)
UltEnd=datanoise(end,1)*1e4;
channum=length(chan);
SpkEp=[];
spk=[];        tps=[]; a=1;
BE=[];BEtot=[]; id=[]; rg=[];
fintps=[];
clear Dtsd
keyboard
for i=1:channum
    [data,indices] = GetFilData(chan(i),'intervals',[0 500]);
    Dtsd{i}=tsd(data(:,1)*1E4, data(:,2)-Data(DtsdR));
    Dtsd{i}=tsd(Range(Restrict(Dtsd{i},TotalEpoch-NoiseEp)),Data(Restrict(Dtsd{i},TotalEpoch-NoiseEp)));
end

Sort(1)=figure('units','normalized',...
    'position',[0.05 0.1 0.9 0.8],...
    'numbertitle','off', 'units','normalized',......
    'name','Menu',...
    'menubar','none',...
    'tag','fenetre depart');

Sort(2)=uicontrol('style','Pushbutton',...
    'String','Refresh', 'units','normalized','position',[0.05 0.01 0.1 0.05],...
    'Callback',@RefreshDat);


Sort(3)=uicontrol('style','Pushbutton',...
    'String','Accumulate', 'units','normalized','position',[0.25 0.01 0.1 0.05],...
    'Callback',@AccumulateSpikes);





UorD=zeros(1,4); %all down
InorEx=ones(1,4); %all incl
actsub=1;
thrmain=zeros(1,channum);
actual=0;
newend=60;
refreshlength=60;
SubEp=intervalSet(actual*1e4,newend*1e4);

for k=1:4
    dat(k)=subplot(4,2,1+(k-1)*2);
    spik(k)=subplot(4,6,4+(k-1)*6);
    spik(k+4)=subplot(4,6,5+(k-1)*6);
    spik(k+8)=subplot(4,6,6+(k-1)*6);
    butup(k)=uicontrol(Sort(1),'style','RadioButton',...
        'units','normalized',...
        'position',[0.5 0.85-0.22*(k-1) 0.02 0.03],...
        'String','Upper','Callback',@UpDown);
    butin(k)=uicontrol(Sort(1),'style','RadioButton',...
        'units','normalized',...
        'position',[0.5 0.8-0.22*(k-1) 0.02 0.03],...
        'String','Inclus','Callback', @InEx);
    dothreshsub(k)=uicontrol(Sort(1),'Style','Pushbutton',...
        'String','Threshold','Callback',@DoThreshsub,...
        'units','normalized',...
        'position',[0.92 0.82-0.22*(k-1) 0.05 0.05]);
    dothreshmain(k)=uicontrol(Sort(1),'Style','Pushbutton',...
        'units','normalized',...
        'position',[0.05 0.82-0.22*(k-1) 0.05 0.05],...
        'String','Threshold','Callback',@DoThreshmain);
end


    function UpDown(hObject, ~)
        UorD(find(butup==hObject))=mod(UorD(find(butup==hObject))+1,2);
    end

    function InEx(hObject, ~)
        InorEx(find(butin==hObject))=mod(InorEx(find(butin==hObject))+1,2);
    end

    function DoThreshmain(hObject, ~)
        subplot(dat(find(dat(find(dothreshmain==hObject)))));
        [x,y]=ginput(1);
        thrmain(find(dothreshmain==hObject),1)=y;
    end

    function AccumulateSpikes(~,~)
        addend=input('How much data should I process? in sec');
        if (newend+addend)*1e4<UltEnd
            SubEp=intervalSet(actual*1e4,(newend+addend)*1e4);
        else
            actual=0;
            newend=60;
            SubEp=intervalSet(actual*1e4,(addend)*1e4);
        end
        DisplaySpikes;
        
    end

    function RefreshDat(~,~)
        if (newend+refreshlength)*1e4<UltEnd
           actual=actual+refreshlength;
            newend=newend+refreshlength;
            SubEp=intervalSet((actual)*1e4,(newend)*1e4);
        else
            actual=0;
            newend=60;
            SubEp=intervalSet((actual+refreshlength)*1e4,(newend+refreshlength)*1e4);
        end
        DisplaySpikes;
    end

    function DisplaySpikes
        disp('calculating spikes')
        spk=[];
        tps{1}=[];tps{2}=[];tps{3}=[];
        a=1;
        for k=1:channum
            subplot(dat(k))
            hold off
            plot(Range(Restrict(Dtsd{k},SubEp),'s'),Data(Restrict(Dtsd{k},SubEp)),'k');
            hold on
            if thrmain(k)~=0
                line([Start(SubEp)/1e4 Stop(SubEp)/1e4],[thrmain(k) thrmain(k)],'color','r');
                SpkEp{k}=thresholdIntervals(Restrict(Dtsd{k},SubEp),thrmain(k),'Direction','Below');
                SpkEp{k}=mergeCloseIntervals(SpkEp{k},1);
                SpkEp{k}=SpkEp{k}-NoiseEp;
                SpkEp{k}=CleanUpEpoch(SpkEp{k});
                for i=1:length(Start(SpkEp{k}))
                    try
                        
                        [BE,id]=min(Data(Restrict(Dtsd{k},subset(SpkEp{k},i))));
                        rg=Range(Restrict(Dtsd{k},subset(SpkEp{k},i)));
                        tps{k}(a)=rg(id);
                        spk{k}(a,:)=Data(Restrict(Dtsd{k},intervalSet(tps{k}(a)-6,tps{k}(a)+10.5)));
                        
                        a=a+1;
                    end
                end
                subplot(spik(k))
                try
                    hold off
                    plot(spk{k}','color',[0.6 0.6 0.6]), xlim([1 32])
                    hold on, line([0 32],[thrmain(k) thrmain(k)],'color','k')
                end
                
            else
                line([Start(SubEp)/1e4 Stop(SubEp)/1e4],[0 0],'color','c')
                SpkEp{k}=SubEp;
                tps{k}=[];
                spk{k}=[];
            end
        end
            
                 BEtot=[];
                for i=1:length(tps{1})
                    BE=[];
                    for k=2:channum
                        if size(tps{k},1)~=0
                        if size(min(find((abs(tps{1}(i)-tps{k})<0.002*1e4)==1)),2)==0
                            BE(k-1)=0;
                        else
                        BE(k-1)=min(find((abs(tps{1}(i)-tps{k})<0.002*1e4)==1));
                        end
                        else
                            BE(k-1)=1;
                        end
                    end
                    
                    if sum(ismember(BE,0))==0
                        BEtot=[BEtot;[i,BE]];
                    end
                end
                
                
            
        
        
        for k=1:channum
            subplot(spik(k+4))
            try
                plot(spk{k}((BEtot(:,k)),:)','color',[0.6 0.6 0.6]), xlim([1 32])
            end
        end
        
        
        
        
        disp('Done')
    end
end