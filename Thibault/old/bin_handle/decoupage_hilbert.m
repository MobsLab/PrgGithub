addpath('tools/');

N=240000; %240 samples is 10ms
bin_size=80;

truth=importdata(['/home/mobsjunior/Dropbox/Mobs_member/Thibault/simulation/ground_truth.mat']);
spike_pos=cell2mat(truth.spike_first_sample(1));
mesure=importdata(['/home/mobsjunior/Dropbox/Mobs_member/Thibault/simulation/simulation_1.mat']);
signal=mesure(1:N);


bin_size=N/floor(N/bin_size);
if bin_size == 0
    bin_size=1;
end

images=smart_decoupage(abs(hilbert(signal)), spike_pos, bin_size);
images2=smart_decoupage(signal, spike_pos, bin_size);

subplot(2,1,1);
plot(normalise(images(16,2:end)));hold off;
subplot(2,1,2);
plot(normalise(abs(images2(16,2:end))));hold off;
