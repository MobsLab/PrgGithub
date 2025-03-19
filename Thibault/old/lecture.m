addpath('tools/');
addpath('../build_kernels');

N=24000; %240 samples is 10ms


mesure=importdata(['/home/mobsjunior/Dropbox/Mobs_member/Thibault/simulation/simulation_1.mat']);
A=mesure(1:N);
D=abs(hilbert(A(1:N)));

% E=D;
% for i = 1:100
%     temp=abs(hilbert(A((i-1)*N/100+1:i*N/100)));
% %     plot(temp);hold on;
%     for j = (i-1)*N/100+1:i*N/100
%         E(j)=D(j)-temp(j-(i-1)*N/100);
%     end
% end
G=A(1:N-2);
for i = 1:N-2
    G(i)=A(i+1)*A(i+1) - A(i+2)*A(i);
end


% cutoff=N;
% start_freq=20;
% stop_freq=6000;
% F=filter(filterCHEBI(start_freq,stop_freq),D(1:cutoff));
% start_freq=20;
% stop_freq=6000;
% FF=abs(hilbert(filter(filterCHEBII(start_freq,stop_freq),A(1:cutoff))));
% FFF=filter(filterBUTT(start_freq,stop_freq),D(1:cutoff));
% DF=abs(hilbert(F(1:N)));
% DFF=abs(hilbert(FF(1:N)));
% specA=fft(D(1:cutoff));
% specF=fft(F(1:cutoff));
% specFF=fft(FF(1:cutoff));

subplot(3,1,1);
% plot(abs(specA(1:cutoff/2+1)));hold on;
% plot(abs(specF(1:cutoff/2+1)));hold on;
% plot(abs(specFF(1:cutoff/2+1)));hold off;
plot(A(1:N));hold off;
% plot(D(1:N));hold off;
subplot(3,1,2);
plot(D(1:N));hold off;
% plot(A(1:N));hold on;
% plot(F(1:N));hold on;
% plot(exp(exp(A(1:N))));hold off;
% plot(E(1:N));
subplot(3,1,3);
plot(G(1:N-2));hold off;


%%

signal=G;

med=median(abs(signal));
stand_dev=med/0.6745;
% threshold=5*stand_dev;
threshold=0.0508;

spike_pos=[];
spike_len=[];
spike_max=[];
spike_cen=[];
spike_val=[];
spike_bool=0;
for i = 1:size(signal,2)
    if (signal(i)>threshold) && (spike_bool==0)
        spike_bool=1;
        spike_pos=[spike_pos i];
        spike_len=[spike_len 1];
    elseif signal(i)>threshold
    	spike_len(end)=spike_len(end)+1;
    elseif spike_bool==1
    	spike_bool=0;
        [val,cen]=max(signal(spike_pos(end):spike_pos(end)+spike_len(end)));
        spike_max=[spike_max val];
        spike_cen=[spike_cen cen];
        spike_val=[spike_val spike_max(end)-min(signal(spike_pos(end):spike_pos(end)+2*spike_len(end)))];
    end
end

%%


% 'building kernel density function'
% Ha=1;
% Hx=1;
% f_gauss=build_all_gauss_kernels(spike_max,spike_val,spike_len,spike_cen,spike_pos,Ha,Hx);
% 'building epanechnikov kernels'
% f_epanech=build_all_epanech_kernels(spike_max,spike_val,spike_len,spike_cen,spike_pos,Ha,Hx);


%%

Ha=threshold/3;
Hx=spike_pos(end)/15;
Nbin_a=100;
Nbin_x=100;
Nevents=size(spike_pos,2);
list_events=[spike_max; spike_val; spike_max; spike_val; spike_pos];

bins_a1=[min(list_events(1,:)):(max(list_events(1,:))-min(list_events(1,:)))/Nbin_a:max(list_events(1,:))];
bins_a2=[min(list_events(2,:)):(max(list_events(2,:))-min(list_events(2,:)))/Nbin_a:max(list_events(2,:))];
bins_a3=[min(list_events(3,:)):(max(list_events(3,:))-min(list_events(3,:)))/Nbin_a:max(list_events(3,:))];
bins_a4=[min(list_events(4,:)):(max(list_events(4,:))-min(list_events(4,:)))/Nbin_a:max(list_events(4,:))];
bins_x=[min(list_events(5,:)):(max(list_events(5,:))-min(list_events(5,:)))/Nbin_x:max(list_events(5,:))];

bin_sizes=[bins_a1(2)-bins_a1(1) bins_a2(2)-bins_a2(1) bins_a3(2)-bins_a3(1) bins_a4(2)-bins_a4(1) bins_x(2)-bins_x(1)];

Kernel=basic_kernel(bin_sizes,Ha,Hx);
% Kernel_proba_matrix=zeros(Nbin_a,Nbin_a,Nbin_a,Nbin_a,Nbin_x);
% Kernel_proba_matrix=build_kernel_proba_matrix(Kernel_density_matrix,list_events,???,Kernel);



%%


% k=1;
% all_spikes=[];
% truth=importdata(['/home/mobsjunior/Dropbox/Mobs_member/Thibault/simulation/ground_truth.mat']);
% truespikes=cell2mat(truth.spike_first_sample(1));
% while truespikes(k)<N
%     k=k+1;
% end

% while size(spike_pos,2)>k-1

%     spike_pos=[];
%     spike_len=[];
%     spike_bool=0;
%     for i = 1:size(signal,2)
%         if (signal(i)>threshold) && (spike_bool==0)
%             spike_bool=1;
%             spike_pos=[spike_pos i];
%             spike_len=[spike_len 1];
%         elseif signal(i)>threshold
%             spike_len(end)=spike_len(end)+1;
%         elseif spike_bool==1
%             spike_bool=0;
%         end
%     end
%     threshold=threshold*1.1;
% end

% k=1;
% while truespikes(k)<N
%     if k<=size(spike_pos,2)
%         all_spikes=[all_spikes [truespikes(k);spike_pos(k)]];
%     else 
%         all_spikes=[all_spikes [truespikes(k); false]];
%     end
%     k=k+1;
% end


