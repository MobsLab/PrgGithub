function [rms,dist,coeff,cf1,cf2]=BimodParams(smooth_ghi_hil)
                [Y,X]=hist(log(Data(smooth_ghi_hil)),700);  

                [cf2,goodness2]=createFit2gauss(X,Y/sum(Y),[]);
                [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
                
                % goodness of fits
                rms(1,1)=goodness1.sse;
                rms(1,2)=goodness2.sse;
                rms(1,3)=goodness1.rsquare;
                rms(1,4)=goodness2.rsquare;
                rms(1,5)=goodness1.adjrsquare;
                rms(1,6)=goodness2.adjrsquare;
                rms(1,7)=goodness1.rmse;
                rms(1,8)=goodness2.rmse;
                
                % distance between peaks
                a= coeffvalues(cf2);
                dist(1,1)=abs(a(2)-a(5));
                b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
                dist(1,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
                
                % overlap
                d=([min(X):max(X)/1000:max(X)]);
                Y1=normpdf(d,a(2),a(3));
                Y2=normpdf(d,a(5),a(6));
                dist(1,3)=sum(min(Y1,Y2)/sum(Y2));
                dist(1,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
                coeff(1,1:6)=a;
                coeff(1,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));


end