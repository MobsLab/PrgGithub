% Procedure:
% 1- Merge all files, wideband & accelero
% 2- RefSubtraction_multi for those files
% 3- Create one folder per mouse, and rename unique file
% 4- Inside, create subfolders: 
%       - NREM-Mouse-294-24062016 where you put the dat files just created
%       - NREM-Mouse-294-24062016-wideband where you link!!! -wideband.dat files
%       - NREM-Mouse-294-24062016-accelero where you link!!! -accelero.dat files
% 5- copy old 

% RefSubtraction_multi(filename, nChannels,nSouris,
%                         'souris1', chs_to_treat, ref, chs_to_keep,
%                         'souris2', chs_to_treat, ref, chs_to_keep,
%                         ...)


% 2 souris 330-294 DaySleep
cd /media/DataMOBs41-ML/Data-NREM-Marie/Mouse-294-330/20160623/ORandDaySleep/NREM-Mouse-294-330-23062016/
RefSubtraction_multi('NREM-Mouse-294-330-23062016.dat',70,2,...
    '330',[0:31],24,[32:34],'294',[35:66],58,[67:69]);

% 2 souris 330-294 nocturnal sleep
RefSubtraction_multi('NREM-Mouse-294-330-21062016.dat',16,2,...
    '330',[0:4],3,[10:12],'294',[5:9],7,[13:15]);
RefSubtraction_multi('NREM-Mouse-294-330-23062016.dat',16,2,...
    '330',[0:4],2,[10:12],'294',[5:9],7,[13:15]);

% 4 souris 393-394-330-294 DaySleep
RefSubtraction_multi('NREM-Mouse-393-394-330-294-29062016.dat',140,4,...
    '393',[0:31],8,[32:34],'394',[35:66],43,[67:69],...
    '330',[70:101],94,[102:104],'294',[105:136],128,[137:139]);

% 4 souris 393-394-330-294 nocturnal sleep
RefSubtraction_multi('NREM-Mouse-393-394-330-294-30062016.dat',34,4,...
    '393',[0:5],2,[22:24],'394',[6:11],6,[25:27],...
    '330',[12:16],15,[28:30],'294',[17:21],19,[31:33]);

% 2 souris 393-394
RefSubtraction_multi('NREM-Mouse-393-394-03072016.dat',70,2,...
    '393',[0:31],8,[32:34],'394',[35:66],43,[67:69]);

% 2 souris 393-394 nocturnal sleep
RefSubtraction_multi('NREM-Mouse-393-394-NocturnalSleep.dat',18,2,...
    '393',[0:5],2,[6:8],'394',[9:14],9,[15:17]);

RefSubtraction_multi('NREM-Mouse-393-394-04072016.dat',18,2,...
    '393',[0:5],2,[12:14],'394',[6:11],6,[15:17]);

% 4 souris 395-400-393-394 DaySleep
RefSubtraction_multi('NREM-Mouse-395-400-393-394-08072016.dat',140,4,...
    '395',[0:31],8,[32:34],'400',[35:66],43,[67:69],...
    '393',[70:101],78,[102:104],'394',[105:136],113,[137:139]);

% 4 souris 395-400-393-394 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-395-400-393-394-18072016.dat',36,4,...
    '395',[0:5],1,[6:8],'400',[9:14],9,[15:17],...
    '393',[18:23],20,[24:26],'394',[27:32],29,[33:35]);

% 2 souris 395-400 DaySleep
RefSubtraction_multi('NREM-Mouse-395-400-18072016.dat',70,2,...
    '395',[0:31],8,[32:34],'400',[35:66],43,[67:69]);

% 2 souris 395-400 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-395-400-NocturnalSleep.dat',18,2,...
    '395',[0:5],1,[6:8],'400',[9:14],9,[15:17]);

% 2 souris 402-403
RefSubtraction_multi('NREM-Mouse-402-403-15082016.dat',70,2,...
    '402',[0:31],8,[32:34],'403',[35:66],59,[67:69]);

% 2 souris 402-403 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-402-403-23082016.dat',18,2,...
    '402',[0:5],1,[12:14],'403',[6:11],8,[15:17]);

% 4 souris 450-451-402-403 DaySleep
RefSubtraction_multi('NREM-Mouse-450-451-402-403-31082016.dat',140,4,...
    '450',[0:31],8,[32:34],'451',[35:66],59,[67:69],...
    '402',[70:101],78,[102:104],'403',[105:136],129,[137:139]);

% 4 souris 450-451-402-403 DaySleep 1 missing channel
RefSubtraction_multi('NREM-Mouse-450-451-402-403-30082016.dat',139,4,...
    '450',[0:31],8,[128:130],'451',[32:63],56,[131:133],...
    '402',[64:95],72,[134:135],'403',[96:127],120,[136:138]);

% 4 souris 450-451-402-403 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-450-451-402-403-30082016.dat',36,4,...
    '450',[0:5],0,[24:26],'451',[6:11],8,[27:29],...
    '402',[12:17],12,[30:32],'403',[18:23],20,[33:35]);

% 4 souris 395-394-294-330 DaySleep
RefSubtraction_multi('NREM-Mouse-395-394-294-330-06092016.dat',140,4,...
    '395',[0:31],8,[32:34],'394',[35:66],43,[67:69],...
    '294',[70:101],93,[102:104],'330',[105:136],129,[137:139]);

% 4 souris 395-394-294-330 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-395-394-294-330-06092016.dat',34,4,...
    '395',[0:5],1,[22:24],'394',[6:11],8,[25:27],...
    '294',[12:16],14,[28:30],'330',[17:21],20,[31:33]);

% 4 souris 400-451-403-450 DaySleep
RefSubtraction_multi('NREM-Mouse-400-451-403-450-13092016.dat',140,4,...
    '400',[0:31],8,[32:34],'451',[35:66],59,[67:69],...
    '403',[70:101],94,[102:104],'450',[105:136],113,[137:139]);

% 4 souris 400-451-403-450 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-400-451-403-450-13092016.dat',36,4,...
    '400',[0:5],0,[24:26],'451',[6:11],8,[27:29],...
    '403',[12:17],14,[30:32],'450',[18:23],18,[33:35]);

% 2 souris 450-451
RefSubtraction_multi('NREM-Mouse-450-451-10102016.dat',70,2,...
    '450',[0:31],8,[32:34],'451',[35:66],59,[67:69]);

% 2 souris 450-451 NocturnalSleep
RefSubtraction_multi('NREM-Mouse-450-451-10102016.dat',18,2,...
    '450',[0:5],1,[12:14],'451',[6:11],9,[15:17]);


%% Redo Substages
a=0;
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';%ok 24-27
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';%ok
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';%ok
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';%ok
for a=1:length(Dir)
    cd(Dir{a})
    channel=29; save ChannelsToAnalyse/PFCx_deep.mat channel
    channel=31; save ChannelsToAnalyse/PFCx_sup.mat channel
    delete AllDeltaPFCx.mat NREMepochsML.mat SleepStagesMLPFCxdeep.mat SleepStagesMLPFCxsup.mat StateEpochSubStages.mat;
    %RunSubstages;
end
%%
a=0;
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';%28-30 ou 30-31
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160719';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160720';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160725';%28-30 ou 30-31
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';%28-30
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160727';%28-30
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728';%
for a=1:length(Dir)
    cd(Dir{a})
    channel=28; save ChannelsToAnalyse/PFCx_deep.mat channel
    channel=30; save ChannelsToAnalyse/PFCx_sup.mat channel
    delete AllDeltaPFCx.mat NREMepochsML.mat SleepStagesMLPFCxdeep.mat SleepStagesMLPFCxsup.mat StateEpochSubStages.mat;
    %RunSubstages;
end
%%
a=0;
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160719';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160720';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160725';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160727';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160728';
for a=1:length(Dir)
    cd(Dir{a})
    channel=29; save ChannelsToAnalyse/PFCx_deep.mat channel
    channel=6; save ChannelsToAnalyse/PFCx_sup.mat channel
    % ou channel = 19 et channel=16
    delete AllDeltaPFCx.mat NREMepochsML.mat SleepStagesMLPFCxdeep.mat SleepStagesMLPFCxsup.mat StateEpochSubStages.mat;
    RunSubstages;
end


%% split nocturnal sleep

%res=('/media/DataMOBs41-ML/Data-NREM-Marie/NREM-Mouse-393-394-294-330-NocturnalSleep/Mouse-294/NREM-Mouse-294-NocturnalSleep');
%res=('/media/DataMOBs41-ML/Data-NREM-Marie/NREM-Mouse-393-394-294-330-NocturnalSleep/Mouse-330/NREM-Mouse-330-NocturnalSleep');
%realDur=cumsum(60*[0 702 469 743 753]);

%res=('/media/mobsyoda/DataMOBs41-ML/Data-NREM-Marie/NREM-Mouse-395-400-NocturnalSleep/Mouse-400/NREM-Mouse-400-NocturnalSleep');
res=('/media/mobsyoda/DataMOBs41-ML/Data-NREM-Marie/NREM-Mouse-395-400-NocturnalSleep/Mouse-395/NREM-Mouse-395-NocturnalSleep');
realDur=cumsum([0 60*713+28 60*728+6 60*714 60*721+14]);

temp=load([res,'/behavResourcesSAV.mat']);

for i=1:length(temp.tpsdeb)
    cd(res)
    disp(sprintf('Creating night%d and dispatching behavResources',i))
    if ~exist(sprintf('night%d',i),'dir'), mkdir(sprintf('night%d',i)); end
    cd(sprintf('night%d',i));
    evt=temp.evt([i,length(temp.evt)/2+i]);
%     tpsdeb=temp.tpsdeb(i);
%     tpsfin=temp.tpsfin(i);
    tpsdeb=realDur(i);
    tpsfin=realDur(i+1);
    useMovAcctsd=1;
    I=intervalSet(tpsdeb*1E4,tpsfin*1E4);
    rg=Range(Restrict(temp.MovAcctsd,I));
    MovAcctsd=tsd(rg-rg(1),Data(Restrict(temp.MovAcctsd,I)));
    TimeEndRec=temp.TimeEndRec(i,:);
    DateRec=temp.DateRec;
    save behavResources evt tpsdeb tpsfin useMovAcctsd TimeEndRec DateRec MovAcctsd
end
%
load([res,'/LFPDataSAV/InfoLFP.mat'])
for c=1:length(InfoLFP.channel)
    disp(sprintf('Spliting LFP%d.mat into :',InfoLFP.channel(c)))
    clear tempL LFP
    tempL=load(sprintf([res,'/LFPDataSAV/LFP%d.mat'],InfoLFP.channel(c)));
    for i=1:length(temp.tpsdeb)
        cd(sprintf([res,'/night%d'],i));
        disp(sprintf('         night%d',i));
        if ~exist(sprintf([res,'/night%d/LFPData'],i),'dir')
            mkdir('LFPData'); save('LFPData/InfoLFP.mat')
        end
        if ~exist(sprintf('LFPData/LFP%d.mat',InfoLFP.channel(c)),'file')
            I=intervalSet(realDur(i)*1E4,realDur(i+1)*1E4);
            rg=Range(Restrict(tempL.LFP,I));
            LFP=tsd(rg-rg(1),Data(Restrict(tempL.LFP,I)));
            save(sprintf('LFPData/LFP%d.mat',InfoLFP.channel(c)),'LFP');
        end
    end
end


