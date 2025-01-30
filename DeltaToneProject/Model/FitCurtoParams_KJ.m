%%FitCurtoParams_KJ
% 01.04.2018 KJ
%
% Find model parameters that fit the data
%
% [a1, a2, a3, I, b] = FitCurtoParams_KJ(V, W, Vdt,varargin)
%
% INPUT:
% - V                   = tsd - excitation or smoothed MUA
% - W                   = tsd - adaptation
% - Vdt                 = tsd - time derivation of V 
% - Epoch (optional)    = Epcoh onto restrict signals                           
%                         (default no restrict)
%
%
% OUTPUT:
% - a1, a2, a3, I, b    = parameters of Curto model
%
%   see 
%       
%


function [a1, a2, a3, I, b] = FitCurtoParams_KJ(V, W, Vdt, varargin)


%% CHECK INPUTS

if nargin < 3 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

%% Initiation
% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'epoch'
            Epoch = varargin{i+1};
            try 
                Start(Epoch);
            catch
                error('Incorrect value for property ''Epoch''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist epoch and restrict
if exist('Epoch','var')
    if tot_length(Epoch)==0
        disp('Epoch is empty')
        return
    end
    V   = Restrict(V,Epoch);
    W   = Restrict(W,Epoch);
    Vdt = Restrict(Vdt,Epoch);
end

%data
v_data  = Data(V);
w_data  = Data(W);
v_deriv = Data(Vdt);


%fit options
options = optimset('MaxFunEvals',1e6, 'maxiter',1e6);


%% Fit


%func
f = @(x, v, w, vd)(vd - x(3).*v.^3 - x(2).*v.^2 - x(1).*v - x(5).*w - x(4).*ones(length(v),1) );
fun = @(x)sum(abs(f(x, v_data, w_data, v_deriv)));

x0 = [-0.02 0.4 -1 -0.03 0.002]; %a1, a2, a3, b, I
[xparams, fval]= fminsearch(fun,x0,options);

A = [1 0 0 0 0]';
b = [0 1 1 1 1];
[xparams, fval]= fmincon(fun,x0,[],[],[],[],[-10 -10 -10 -10 -10 -10], [10 10 -0.1 10 10],[], options);


a1 = xparams(1);
a2 = xparams(2);
a3 = xparams(3);
I  = xparams(4);
b  = xparams(5);

% 
% %a3 is fixed during optimization to avoid overfitting
% list_a3 = -50:0.1:50;
% 
% for i=1:length(list_a3)
%     %func
%     f = @(x, v, w, vd, a3)(vd - a3.*v.^3 - x(2).*v.^2 - x(1).*v - x(3).*w - x(4).*ones(length(v),1) );
%     a3 = list_a3(i);
%     fun = @(x)sum(abs(f(x, v_data, w_data, v_deriv, a3)));
%     
%     
%     x0 = [-0.02 0.4 -0.03 0.002]; %a1, a2, b, I
%     [xparams{i}, fval(i)]= fminsearch(fun,x0,options);
%     
% end
% 
% [~,u]=min(fval);
% a1 = xparams(1);
% a2 = xparams(2);
% a3 = list_a3(u);
% I  = xparams(4);
% b  = xparams(3);

end





