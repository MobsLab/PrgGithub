%--------------------------------------------------------------------------------------------------------------------------------------

res=pwd;
load SpikeData
load DeltaSleepEvent

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

load([res,'/SpikesToAnalyse/PFCx_Neurons']);
PFCx_Neurons=PoolNeurons(S,number);
clear SS
SS{1}=PFCx_Neurons;
SS=tsdArray(SS);
Qspk = MakeQfromS(SS,200);

figure, [fh, rasterAx, histAx, matVal_Spk_TONEtime1] = ImagePETH(Qspk, ts(DeltaDetect_SWS), -10000, +15000,'BinSize',500);
hold on, title('PFCx spikes - DeltaDetect')


m_Spk=Data(matVal_Spk_TONEtime1)';

figure, subplot(1,2,1)
hold on,imagesc(MUA_t1)
a=size(MUA_t1);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 1')
hold on, subplot(1,2,2)
hold on,imagesc(Spk_t1)
a=size(Spk_t1);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)
hold on, title('Spk time 1')


clear a
for i=1:4421
    k=1;
    for j=1:120
        if m_Spk(i,j:j+6)==0 
            a{i,k}=j;
            k=k+1;
        end
    end
end
a=m_Spk(2,:);
b=find(m_Spk(2,:)==0);
c=diff



%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

figure, imagesc(m_Spk)
hold on, title('PFCx spikes')
siz=size(m_Spk);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)


disp(' ')
Fwindow=input('what windows for tone sorting ? (std=[46:50])    ');
disp(' ')
[BE,id]=sort(mean(m_Spk(:,Fwindow),2));
close all

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, imagesc(m_Spk(id,:)), axis xy, 



siz=size(m_Spk);
for i=1:siz(1)
    for j=1:5:120
        meanFirRate{i,j}=mean(m_Spk(i,j:j+5));
    end
end


















