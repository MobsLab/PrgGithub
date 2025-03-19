function [M,T]=ReadPM100ALogDataFiles(filename)

C=importdata(filename);
C(1,:)=[];
M=nan(size(C));
T=nan(size(C));
for i=1:length(C)
    ind=findstr(C{i},',');
    C{i}(ind)='.';
    M(i)=str2num(C{i}(25:end-1));
    T(i)=datenum(C{i}(1:24));
end
    
td=diff(T);
td_date=datevec(td);
td_date=td_date(:,6);

vectorTime=[0]; 
for i=1:length(td_date)
    vectorTime=[vectorTime; sum(td_date(1:i))];
end

figure, plot(vectorTime,M)
ylabel('light power (watts)')
xlabel('time (sec)')
saveas(gcf,[filename(1:end-3) 'fig'])
saveas(gcf,[filename(1:end-3) 'png'])

