function plot_metacontrast(cfg, data1, data2, data3, data4)
% cfg must contain 
%cfg.chan =  channel number
%cfg.Effect = effect name
% cfg.structure structure of the electrode
lim=5500;
pval=0.05;
Msa = [];
smo = 2;

A =whos('data1','size');
for bloc = 1:A.size(1)
    temp = Data(data1(bloc, cfg.chan))';
    if isempty(Msa)
        Msa = temp(:,1:size(temp,2)-1);
    else 
        Msa = [Msa ; temp(:,1:size(Msa,2))];
    end
end
A =whos('data2','size');
for bloc = 1:A.size(1)
    temp = Data(data2(bloc, cfg.chan))';
    if isempty(Msa)
        Msa = temp(:,1:size(temp,2)-1);
    else 
        Msa = [Msa ; temp(:,1:size(Msa,2))];
    end
end
Msa(Msa>lim)=nan;
Msa(Msa<-lim)=nan;



Msb = [];
B =whos('data3','size'); 
for bloc = 1:B.size(1)
    temp = Data(data3(bloc, cfg.chan))';
    if isempty(Msb)
        Msb = temp(:,1:size(temp,2)-1);
    else 
        Msb = [Msb ; temp(:,1:size(Msb,2))];
    end
end
B =whos('data4','size'); 
for bloc = 1:B.size(1)
    temp = Data(data4(bloc, cfg.chan))';
    if isempty(Msb)
        Msb = temp(:,1:size(temp,2)-1);
    else 
        Msb = [Msb ; temp(:,1:size(Msb,2))];
    end
end
Msb(Msb>lim)=nan;
Msb(Msb<-lim)=nan;

Msa = Msa(:, 1:min(size(Msa, 2), size(Msb,2)));
Msb = Msb(:, 1:min(size(Msa, 2), size(Msb,2)));
 subplot(2,2,1);imagesc(Msa, [-3000 3000]);subplot(2,2,2);imagesc(Msb, [-3000 3000]);

[Ma,Sa,Ea]=MeanDifNan(RemoveNan(Msa));
[Mb,Sb,Eb]=MeanDifNan(RemoveNan(Msb));

[h,p]=ttest2(RemoveNan(Msa),RemoveNan(Msb));
rg=Range(data1(1,1),'ms');
pr=rescale(p,450, 490);

tps=Range(data1(1,1),'ms');

 subplot(2,1,2);plot(tps(1:size(Msa, 2)),SmoothDec((Ma),smo),'k','linewidth',2),
hold on, plot(tps(1:size(Msa, 2)),SmoothDec((Ma+Ea),smo),'k')
hold on, plot(tps(1:size(Msa, 2)),SmoothDec((Ma-Ea),smo),'k')
hold on, plot(tps(1:size(Msa, 2)),SmoothDec((Mb),smo),'r','linewidth',2)
hold on, plot(tps(1:size(Msa, 2)),SmoothDec((Mb+Eb),smo),'r')
hold on, plot(tps(1:size(Msa, 2)),SmoothDec((Mb-Eb),smo),'r')
hold on, plot(rg(p<pval),pr(p<pval),'gx')
ylabel([ cfg.Effect ', channel',num2str(cfg.chan), cfg.structure])
%title([ cfg.Effect ', channel',num2str(cfg.chan), cfg.structure])
hold on, axis([-200 1100 -800 800])
for a=0:150:600
    hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
end