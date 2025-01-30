
function [OutPut] = LowPassFilter_BM(Input)

% Input data in a vector with time in 1e-4s
% to do better with control of band pass frequency ! BM 05/05/2021

tau = 0.5;
freq = 1000;
weight = 2-exp(1./(tau*freq));

samplesize = size(Input,1);
a = [1:samplesize]';
OutPut = NaN(size(a));
OutPut(1) = Input(1);

for i = 2:length(a)
    OutPut(i)  = OutPut(i-1).*weight+Input(i).*(1-weight);
end

end
