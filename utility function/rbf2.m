function H=rbf_dot(X,Y,deg)
%Author：kailugaji
%Deg is kernel size
[N_X,~]=size(X);
[N_Y,~]=size(Y);
G = sum((X.*X),2);
H = sum((Y.*Y),2);
Q = repmat(G,1,N_Y(1));
R = repmat(H',N_X(1),1);
H = Q + R - 2*X*Y';  %||x-y||^2
H=exp(-H/2/deg^2);  %N_X*N_Y
end
% function H=rbf2(X,Y,simga)
% for i=1:size(X,1)
%     for j=1:size(Y,1)
%         H(i,j)=exp(-sum((X(:,i)-Y(:,j)).^2)/simga^2);
%     end
% end
% end