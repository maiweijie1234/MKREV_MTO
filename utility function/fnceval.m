function [objective,funcCount] = fnceval(obj,PopDec)
d = obj.D;
nvars = PopDec(1:d);
minrange = obj.lower(1:d);
maxrange = obj.upper(1:d);
y=maxrange-minrange;
vars = y.*nvars + minrange; % decoding
PopDec=vars;
objective=obj.CalObj(PopDec);
funcCount=0;
end