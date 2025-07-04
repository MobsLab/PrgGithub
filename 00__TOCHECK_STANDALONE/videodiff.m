try
cd('/media/MOBS6/ProjetBulbe/LPS/Mouse051/20130221/BULB-Mouse-51-21022013-wideband')

jump(1)=0;
time=[];
vals=[];
dur=[];
for n=1:9
names{n}=strcat('BULB-Mouse-51-21022013-0',num2str(n),'-RestSleep-wideband-1.avi');
end
names{10}=strcat('BULB-Mouse-51-21022013-',num2str(10),'-RestSleep-wideband-1.avi');

for n=11:19
names{n}=strcat('BULB-Mouse-51-21022013-',num2str(n),'-RestSleepLPS-wideband-1.avi');
end

for k=1:19
mov=mmreader(names{k});
dur = get(mov, 'Duration');
num=get(mov,'numberOfFrames');
dt=dur/num;
clear val
ima=read(mov,1);
for i=2:num
val(i)=sum(sum(sum(abs(ima-read(mov,i)))));
ima=read(mov,i);
end

time=[time ([dt:dt:num*dt]+jump(k))*1e4];
vals=[vals val(:)'];
jump(k+1)=jump(k)+dur;

end

mvmttsd=tsd(time'*1e4,vals');
save('FrameDiff.mat','mvmttsd')
end

try
cd('/media/MOBS6/ProjetBulbe/LPS/Mouse051/20130220/BULB-Mouse-51-20022013-wideband')

jump(1)=0;
time=[];
vals=[];
dur=[];
for n=1:9
names{n}=strcat('BULB-Mouse-51-20022013-0',num2str(n),'-Sleep-wideband-1.avi');
end
names{10}=strcat('BULB-Mouse-51-20022013-',num2str(10),'-Sleep-wideband-1.avi');

for n=11:19
names{n}=strcat('BULB-Mouse-51-20022013-',num2str(n),'-SleepVEH-wideband-1.avi');
end

for k=1:19
mov=mmreader(names{k});
dur = get(mov, 'Duration');
num=get(mov,'numberOfFrames');
dt=dur/num;
clear val
ima=read(mov,1);
for i=2:num
val(i)=sum(sum(sum(abs(ima-read(mov,i)))));
ima=read(mov,i);
end

time=[time ([dt:dt:num*dt]+jump(k))*1e4];
vals=[vals val(:)'];
jump(k+1)=jump(k)+dur;

end

mvmttsd=tsd(time'*1e4,vals');
save('FrameDiff.mat','mvmttsd')
end


try
cd('/media/MOBS6/ProjetBulbe/LPS/Mouse051/20130223/BULB-Mouse-51-23022013-wideband')

jump(1)=0;
time=[];
vals=[];
dur=[];
for n=2:9
names{n}=strcat('BULB-Mouse-51-23022013-0',num2str(n),'-Wake48H-wideband-1.avi');
end


for k=1:19
mov=mmreader(names{k});
dur = get(mov, 'Duration');
num=get(mov,'numberOfFrames');
dt=dur/num;
clear val
ima=read(mov,1);
for i=2:num
val(i)=sum(sum(sum(abs(ima-read(mov,i)))));
ima=read(mov,i);
end

time=[time ([dt:dt:num*dt]+jump(k))*1e4];
vals=[vals val(:)'];
jump(k+1)=jump(k)+dur;

end

mvmttsd=tsd(time'*1e4,vals');
save('FrameDiff.mat','mvmttsd')
end