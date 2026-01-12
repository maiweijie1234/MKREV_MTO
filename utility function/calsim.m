function similarity = calsim(p1, p2)
% Calculate similarity
D=size(p1,2);
cov0 = cov(p1);  
cov1 = cov(p2);  
cov0_det = det(cov0);  
Inv_cov0 = pinv(cov0); 
cov1_det = det(cov1);
Inv_cov1 = pinv(cov1);
tr = getTrace(Inv_cov1, cov0);
u = getMul(p1, p2 ,Inv_cov1);                           
if cov0_det < 1e-3
    cov0_det = 0.001;  
end         
if cov1_det < 1e-3                                     
    cov1_det = 0.001;   
end                                         
s1 = abs(0.5 * (tr + u - D + log(cov1_det / cov0_det)));
tr = getTrace(Inv_cov0, cov1);
u = getMul(p2,p1, Inv_cov0);
s2 = abs(0.5 * (tr + u - D + log(cov0_det / cov1_det)));
similarity = 0.5 * (s1 + s2);               
end