

for a=1:length(neu)

[H1{a},HS1{a},Ph,ModTheta1{a}]=RayleighFreq3(Restrict(LFP,MATEP{1}),Restrict(S{neu(a)},MATEP{1}),0.05,20,1024);
[H2{a},HS2{a},Ph,ModTheta2{a}]=RayleighFreq3(Restrict(LFP,MATEP{2}),Restrict(S{neu(a)},MATEP{2}),0.05,20,1024);
[H3{a},HS3{a},Ph,ModTheta3{a}]=RayleighFreq3(Restrict(LFP,MATEP{3}),Restrict(S{neu(a)},MATEP{3}),0.05,20,1024);
[H4{a},HS4{a},Ph,ModTheta4{a}]=RayleighFreq3(Restrict(LFP,MATEP{4}),Restrict(S{neu(a)},MATEP{4}),0.05,20,1024);
[H5{a},HS5{a},Ph,ModTheta5{a}]=RayleighFreq3(Restrict(LFP,MATEP{5}),Restrict(S{neu(a)},MATEP{5}),0.05,20,1024);
[H6{a},HS6{a},Ph,ModTheta6{a}]=RayleighFreq3(Restrict(LFP,MATEP{8}),Restrict(S{neu(a)},MATEP{8}),0.05,20,1024);

    
close
close
close
close
close
close
end






for i=1:27

figure('color',[1 1 1])
subplot(2,3,1),imagesc(HS1{i}), title('N1'), axis xy
subplot(2,3,2),imagesc(HS2{i}), title('N2'), axis xy
subplot(2,3,3),imagesc(HS3{i}), title('N3'), axis xy
subplot(2,3,4),imagesc(HS4{i}), title('REM'), axis xy
subplot(2,3,5),imagesc(HS5{i}), title('Wake'), axis xy
subplot(2,3,6),imagesc(HS6{i}), title('Slow Bulb'), axis xy

end



