addpath('tools/');

N=24000; %240 samples is 10ms
bin_size=80;

truth=importdata(['C:\Users\Thibault\Google Drive\Officiels\espci\simulation\ground_truth.mat']);
spike_pos=cell2mat(truth.spike_first_sample(1));
mesure=importdata(['C:\Users\Thibault\Google Drive\Officiels\espci\simulation\simulation_1.mat']);
A=mesure(1:N);

spk_num=1;
images=[];
bins=[];
bin_size=N/floor(N/bin_size);
if bin_size == 0
    bin_size=1;
end
for i = 1:(N/bin_size-1)
    is_spk=0;
    while (bin_size*(i-1)+1<=spike_pos(spk_num)) && (bin_size*i>=spike_pos(spk_num))
        is_spk=is_spk+1;
        spk_num=spk_num+1;
    end
    bins=[bins; bin_size*(i-1)+1 bin_size*(1+i)];
    images=[images; is_spk A(bin_size*(i-1)+1:bin_size*(i+1))];
end

plot(normalise(images(16,2:end)));