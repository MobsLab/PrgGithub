function plotw(bias, w)
fplot(@(x) -(bias + w(1)*x )/w(2))
end

