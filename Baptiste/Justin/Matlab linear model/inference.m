function Y = inference(w,w0,x)
%INFERENCE Calcul de l'inference
K = exp(-(w0 + w*x));
        Y = 1./(1+K);
end