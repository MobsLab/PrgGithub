% Moyenne NPDUR par souris

% NPDURall{1}(length(NPDURall{1})+1:length(NPDURall{3})) = NaN;
% NPDURall{2}(length(NPDURall{2})+1:length(NPDURall{3})) = NaN;
% NPDURall{4}(length(NPDURall{4})+1:length(NPDURall{5})) = NaN;
% 
% NPDUR_253 =  nanmean([NPDURall{1};NPDURall{2};NPDURall{3}],1);
% NPDUR_254 =  nanmean([NPDURall{4};NPDURall{5};NPDURall{6}],1);

NPDUR_MFB254 = NPDURallMFB{2}(2:end);

%NPDUR

% X_253=[0:0.5:4];
X_MFB = [5,4,3,2,1,0]
% Fit sigmoid
%cf_253=createFitSig(X_253,NPDUR_254), hold on;
%cf_253=createFitSig(X_MFB,NPDUR_MFB254), hold on;
cf_=createFitMFB(X_MFB,NPDUR_MFB254), hold on;
Valeurs=coeffvalues(cf_);
PlotSlope(0,Valeurs(1),0,100,'g'),hold on;
PlotSlope(0,Valeurs(1)/2,0,100,'g'), hold on;

% 
% x = sym('x');
% find(cf_253(x)==Valeurs(1)/2;% x réel
% 
             
a = Valeurs(1);
c = Valeurs(2);
d = Valeurs(3);
x=d;
deriv = -a*c/4;
Slope=(a/2)-deriv*d+deriv.*X_MFB;
Value=((a/2)+deriv*d)/deriv;
plot(Value,a,'*k')
plot(X_MFB,Slope,'k')
title(num2str(Value))
ylim([-0.1 a*1.1])


