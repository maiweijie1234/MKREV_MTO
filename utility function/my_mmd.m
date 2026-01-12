function mmd_XY=my_mmd(X, Y, sigma)
%Maximum Mean Discrepancy 
%mmd_XY=my_mmd(X, Y, 4)
[N_X, ~]=size(X);
[N_Y, ~]=size(Y);
K = rbf_dot(X,X,sigma); %N_X*N_X
L = rbf_dot(Y,Y,sigma);  %N_Y*N_Y
KL = rbf_dot(X,Y,sigma);  %N_X*N_Y
c_K=1/(N_X^2);
c_L=1/(N_Y^2);
c_KL=2/(N_X*N_Y);
mmd_XY=sum(sum(c_K.*K))+sum(sum(c_L.*L))-sum(sum(c_KL.*KL));
mmd_XY=sqrt(mmd_XY);
end
% function mmd_XY=my_mmd(X, Y, sigma)
% %Maximum Mean Discrepancy 
% %mmd_XY=my_mmd(X, Y, 4)
% % [N_X, ~]=size(X);
% % [N_Y, ~]=size(Y);
% [~, N_X]=size(X);
% [~, N_Y]=size(Y);
% % K = rbf_dot(X,X,sigma); %N_X*N_X
% % L = rbf_dot(Y,Y,sigma);  %N_Y*N_Y
% % KL = rbf_dot(X,Y,sigma);  %N_X*N_Y
% K = rbf2(X,X,sigma); %N_X*N_X
% L = rbf2(Y,Y,sigma);  %N_Y*N_Y
% KL = rbf2(X,Y,sigma);  %N_X*N_Y
% c_K=1/(N_X^2);
% c_L=1/(N_Y^2);
% c_KL=2/(N_X*N_Y);
% mmd_XY=sum(sum(c_K.*K))+sum(sum(c_L.*L))-sum(sum(c_KL.*KL));
% mmd_XY=sqrt(mmd_XY);
% end