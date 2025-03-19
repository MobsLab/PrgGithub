
function OutPutVar=HPC_Autocorrelation_Freezing_SumUp_BM(HPCSpec,OBSpec,Spectro,Mouse,Mouse_names,varargin)

switch(varargin{1})
    case 'SB'
        figure
        n=1; B=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; caxis([1.5e-5 1.85e-5])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC frequency autocorrelation during shock side freezing, SB mice, n=7')
        
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([1.7e-5 1.88e-5])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC frequency autocorrelation during safe side freezing, SB mice, n=7')
        
        %% OB auto-correlation
        % Shock side
        figure
        n=1; B=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; %caxis([25 31])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('OB frequency autocorrelation during shock side freezing, SB mice, n=7')
        
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([1.6e-5 2.25e-5])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('OB frequency autocorrelation during safe side freezing, SB mice, n=7')
        
        %% HPC-OB auto-correlation
        % Shock side
        figure
        n=1; B=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; caxis([1.7e-5 2.1e-5])
        xlabel('OB frequency (Hz)'); ylabel('HPC frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC-OB frequencies correlation during shock side freezing, SB mice, n=7')
        
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=1:length(Mouse)
            subplot(3,3,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([1.8e-5 2e-5])
        xlabel('HPC frequency (Hz)'); ylabel('HPC frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC-OB frequencies correlation during safe side freezing, SB mice, n=7')
        
        
    case 'Dima'
        
        figure
        n=1; B=[];
        for mouse=[2 4 5 12 16 17 18 19 21 23 24]
            subplot(3,4,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; caxis([7.3e-6 8.3e-6])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC frequency autocorrelation during shock side freezing, DIMA mice, n=11')
        
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=[2 4 5 12 16 17 18 19 21 22 23 24]
            subplot(3,4,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([7.3e-6 9e-6])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC frequency autocorrelation during safe side freezing, DIMA mice, n=11')
        
        %% OB auto-correlation
        % Shock side
        figure
        n=1; B=[];
        for mouse=[1 4:6 8 10:11 14:21 23:24]
            subplot(3,6,n)
            clear A; A=log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; caxis([1.2e-5 1.4e-5])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('OB frequency autocorrelation during shock side freezing, DIMA mice, n=11')
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=[1 4:6 8 10:11 14:21 23:24]
            subplot(3,6,n)
            clear A; A=log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([1.2e-5 1.6e-5])
        xlabel('Frequency (Hz)'); ylabel('Frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('OB frequency autocorrelation during safe side freezing, DIMA mice, n=11')
        
        %% HPC-OB auto-correlation
        % Shock side
        figure
        n=1; B=[];
        for mouse=[1 5 15 17 18 21]
            subplot(2,3,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            B(mouse,:,:)=A/sum(sum(A));
        end
        
        B_mean=squeeze(nanmean(B(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , B_mean); axis xy; makepretty; caxis([4e-6 6e-6])
        xlabel('OB frequency (Hz)'); ylabel('HPC frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC-OB frequencies correlation during shock side freezing, DIMA mice, n=11')
        
        
        % Safe side
        figure
        n=1; C=[];
        for mouse=[2 4 5 12 17 18 19 21 22 23 24]
            subplot(3,4,n)
            clear A; A=log(Data(HPCSpec.Cond.Fz_Safe.(Mouse_names{mouse})))'*log(Data(OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})));
            imagesc(Spectro{3} , Spectro{3} , A/sum(sum(A))); axis xy
            title(Mouse_names{mouse})
            n=n+1;
            makepretty
            axis square
            C(mouse,:,:)=A/sum(sum(A));
        end
        
        C_mean=squeeze(nanmean(C(:,:,:),1));
        figure
        imagesc(Spectro{3} , Spectro{3} , C_mean); axis xy; makepretty; caxis([7e-6 9.2e-6])
        xlabel('HPC frequency (Hz)'); ylabel('HPC frequency (Hz)');
        xlim([0 15]); ylim([0 15]); xticks([0:2:14]); yticks([0:2:14])
        title('HPC-OB frequencies correlation during safe side freezing, DIMA mice, n=11  ')
        
end
