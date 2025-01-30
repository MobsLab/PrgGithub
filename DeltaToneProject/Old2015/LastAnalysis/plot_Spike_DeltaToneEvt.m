
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load Spk_PFCx_Delta_SWS
MUA_t1=Data(matVal_MUA_TONEtime1)';
MUA_t2=Data(matVal_MUA_TONEtime2)';
Spk_t1=Data(matVal_Spk_TONEtime1)';
Spk_t2=Data(matVal_Spk_TONEtime2)';

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

figure, subplot(1,2,1)
hold on,imagesc(MUA_t2)
a=size(MUA_t2);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([60 60], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 2')
hold on, subplot(1,2,2)
hold on,imagesc(Spk_t2)
a=size(Spk_t2);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([60 60], [0 a(1)],'color','w','linewidth',2)
hold on, title('Spk time 2')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load Spk_NRT_Delta
MUA_t1=Data(matVal_MUA_TONEtime1)';
MUA_t2=Data(matVal_MUA_TONEtime2)';

figure, subplot(1,1,1)
hold on,imagesc(MUA_t1)
a=size(MUA_t1);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 1')

figure, subplot(1,1,1)
hold on,imagesc(MUA_t2)
a=size(MUA_t2);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([60 60], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 2')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load Spk_MoCx_Delta
MUA_t1=Data(matVal_MUA_TONEtime1)';
MUA_t2=Data(matVal_MUA_TONEtime2)';

figure, subplot(1,1,1)
hold on,imagesc(MUA_t1)
a=size(MUA_t1);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 1')

figure, subplot(1,1,1)
hold on,imagesc(MUA_t2)
a=size(MUA_t2);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([60 60], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 2')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load Spk_Bulb_Delta
MUA_t1=Data(matVal_MUA_TONEtime1)';
MUA_t2=Data(matVal_MUA_TONEtime2)';

figure, subplot(1,1,1)
hold on,imagesc(MUA_t1)
a=size(MUA_t1);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([50 50], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 1')

figure, subplot(1,1,1)
hold on,imagesc(MUA_t2)
a=size(MUA_t2);
hold on, axis([0 a(2) 0 a(1)])
hold on, line([60 60], [0 a(1)],'color','w','linewidth',2)
hold on, title('MUA time 2')
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>