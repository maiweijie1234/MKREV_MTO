%---------------kernel function---------------
function K = kernel(X,Y,type)
%X 
switch type
case 'linear'   
    K = X'*Y;
case 'rbf'      
    delta = 1;
    delta = delta*delta;
    XX = sum(X'.*X',2);
    YY = sum(Y'.*Y',2);
    XY = X'*Y;
    K = abs(repmat(XX,[1 size(YY,1)]) + repmat(YY',[size(XX,1) 1]) - 2*XY);
    K = exp(-K./2*delta);
end
end