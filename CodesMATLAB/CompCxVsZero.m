load AllDataMeanPetit


figure, imagesc(petitCX30m)

for i=1:45
[h(i),p(i)]=ztest(petitCX30m(:,i),0,std(petitCX30m(:,i)));
end

% p'
    
% figure,plot(p)

figure, imagesc(petitCX30m),axis xy, hold on, plot(50*p+10,'k','linewidth',3)

 num=gcf;

        set(num,'paperPositionMode','auto')

        eval(['print -f',num2str(num),' -dpng ','Cx30vsZero','.png'])

        eval(['print -f',num2str(num),' -painters',' -depsc2 ','Cx30vsZero','.eps'])
        
% --------------------------------------------------------------------

% Enregistrement de P:

fid = fopen('P_Cx30.txt','w');

for j=1:length(p)
    
    fprintf(fid,'%s\r\n',num2str(p(j)));

end

fclose(fid);

% Enregistrement de H:

fid = fopen('H_Cx30.txt','w');

for k=1:length(h)
    
    fprintf(fid,'%s\r\n',num2str(h(k)));

end

fclose(fid);
% --------------------------------------------------------------------
save Cx30vsZero h p 
        
 clear
 close all
 
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% Cx43
 
 load AllDataMeanPetit
 
 figure, imagesc(petitCX43m)

for i=1:45
[h(i),p(i)]=ztest(petitCX43m(:,i),0,std(petitCX43m(:,i)));
end

p'


    
figure,plot(p)

figure, imagesc(petitCX43m),axis xy, hold on, plot(50*p+10,'k','linewidth',3)

 num=gcf;

        set(num,'paperPositionMode','auto')

        eval(['print -f',num2str(num),' -dpng ','Cx43vsZero','.png'])

        eval(['print -f',num2str(num),' -painters',' -depsc2 ','Cx43vsZero','.eps'])
        
% --------------------------------------------------------------------

% Enregistrement de P:

fid = fopen('P_Cx43.txt','w');

for j=1:length(p)
    
    fprintf(fid,'%s\r\n',num2str(p(j)));

end

fclose(fid);

% Enregistrement de H:

fid = fopen('H_Cx43.txt','w');

for k=1:length(h)
    
    fprintf(fid,'%s\r\n',num2str(h(k)));

end

fclose(fid);
% --------------------------------------------------------------------

save Cx43vsZero h p 