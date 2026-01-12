function [objective,funcCount] = fnceval2(obj,PopDec)
d = obj.D;
nvars = PopDec(1:d);
% minrange = obj.lower(1:d);
% maxrange = obj.upper(1:d);
% y=maxrange-minrange;
% vars = y.*nvars + minrange; % decoding
PopDec=nvars;
objective=obj.CalObj(PopDec);
funcCount=0;
end