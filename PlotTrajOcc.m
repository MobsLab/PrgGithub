function [x,y,A,x1,x2,Sig,ID1,ID2]=PlotTrajOcc(X,Y,Scalee,smo,loga,Ext,plo,LMatrix)


try
    LMatrix;
catch
    LMatrix=0;
end


try
    plo;
catch
    plo=1;
end

%Scalee=62;
%Scalee=22; fac=1.15;
%Scalee=32; fac=1.15;
%Scalee=42; fac=0.75;
% 
% if Scalee<15
%     fac=2;
% elseif Scalee<35
%     fac=1.15;
% else
%     fac=0.75;
% end
% 
% 
% if Scalee<15
%     fac=-0.5;
% elseif Scalee<35&Scalee>15
%     fac=-0.1;
% else
%     fac=-0.5;
% end

try
    Ext;
    if length(Ext)<3
        Ext(3)=Ext(1);
        Ext(4)=Ext(2);
    end
    try
      x=rescale([Ext(1) X Ext(2)],0,Scalee);x=x(2:end-1);
      y=rescale([Ext(3) Y Ext(4)],0,Scalee);y=y(2:end-1);
    catch
      x=rescale([Ext(1); X ;Ext(2)],0,Scalee);x=x(2:end-1);
      y=rescale([Ext(3) ;Y; Ext(4)],0,Scalee);y=y(2:end-1);  
    end
catch
    x=rescale(X,0,Scalee);
    y=rescale(Y,0,Scalee);
end


lim=[0 Scalee];
%[occH, x1, x2] = hist2d([lim(1) ;x ;lim(2)], [lim(1) ;y ;lim(2)], Scalee, Scalee);
%[occH, x1, x2] = hist2d([lim(1) ;x ;lim(2)], [lim(1) ;y ;lim(2)], 0:Scalee/10:Scalee, 0:Scalee/10:Scalee);
%[occH, x1, x2] = hist2d([lim(1) ;x ;lim(2)], [lim(1) ;y ;lim(2)], -Scalee/10:Scalee+Scalee/10, -Scalee/10:Scalee+Scalee/10);

[occH, x1, x2] = hist2d(x,y, -1/Scalee:1+1/Scalee:Scalee+1/Scalee, -1/Scalee:1+1/Scalee:Scalee+1/Scalee);
% 
% occH(1,1)=0;
% occH(end,1)=0;
% occH(1,end)=0;
% occH(end,end)=0;

occH=occH'/sum(sum(occH'));

    if LMatrix
        largerMatrix = zeros(Scalee+floor(Scalee/4),Scalee+floor(Scalee/4));
        largerMatrix(1+floor(Scalee/8):Scalee+floor(Scalee/8),1+floor(Scalee/8):Scalee+floor(Scalee/8)) = occH;
        % largerMatrix = zeros(250,250);
        % largerMatrix(26:225,26:225) = pf;
        occH = largerMatrix;

    end
    
    
    
if loga
    A=log(occH+eps);
    A(isinf(A))=log(eps);
    A(isnan(A))=log(eps);
else
    A=(occH);
    A(isinf(A))=0;
    A(isnan(A))=0;
end


if smo>0
    A=SmoothDec(A,[smo smo]);
end

%     A(1:smo,:)=nan;
%     A(end-smo+1:end,:)=nan;
%     A(:,1:smo)=nan;
%     A(:,end-smo+1:end)=nan; 
    
[id1,id2]=find(A>nanmean(A(:))+3*nanstd(A(:)));

% if loga
%     A(1:smo,:)=log(eps);
%     A(end-smo+1:end,:)=log(eps);
%     A(:,1:smo)=log(eps);
%     A(:,end-smo+1:end)=log(eps); 
% else
%     A(1:smo,:)=0;
%     A(end-smo+1:end,:)=0;
%     A(:,1:smo)=0;
%     A(:,end-smo+1:end)=0;   
% end

load('MyColormaps','mycmap')



   if LMatrix
       
        ID2=id2-floor(Scalee/8);
        ID2(ID2>length(x2))=length(x2);
        ID2(ID2<1)=1;

        ID1=id1-floor(Scalee/8);
        ID1(ID1>length(x1))=length(x1);
        ID1(ID1<1)=1;
       
        x=x+floor(Scalee/8)+1;
        y=y+floor(Scalee/8)+1;


   else
       
   ID2=id2;
   ID1=id1;
       
   end
   


if plo
    
    figure('color',[1 1 1]),
    subplot(1,2,1), imagesc(A), axis xy, hold on, plot(x,y,'w')
    %subplot(2,2,2), imagesc(A), axis xy, hold on, plot(Scalee/(Scalee-fac)+x*Scalee/(Scalee-fac),Scalee/(Scalee-fac)+y*Scalee/(Scalee-fac),'w')
    set(gcf,'Colormap',mycmap)
    yl=ylim;
    xl=xlim;
   if LMatrix
    subplot(1,2,2), hold on, plot(x,y,'k'),plot(x2(ID2)+floor(Scalee/8)+1,x1(ID1)+floor(Scalee/8)+1,'ro','markerfacecolor','r')
   else
    subplot(1,2,2), hold on, plot(x,y,'k'),plot(x2(ID2)+1,x1(ID1)+1,'ro','markerfacecolor','r')
       
   end
   
    xlim(xl)
    ylim(yl)

end

%x=x*Scalee/(Scalee-fac)+Scalee/(Scalee-fac)/2;
%y=y*Scalee/(Scalee-fac)+Scalee/(Scalee-fac)/2;

   
   
%subplot(1,3,3), hold on, plot(x,y),plot(x2(id2),x1(id1),'ro','markerfacecolor','r')
% subplot(2,2,3), hold on, plot(X,Y,'k'),plot(id2,id1,'ro','markerfacecolor','r')
%subplot(2,2,4), hold on, plot(x,y),plot(id2,id1,'ro','markerfacecolor','r')

Sig=[x2(ID2)' x1(ID1)'];


