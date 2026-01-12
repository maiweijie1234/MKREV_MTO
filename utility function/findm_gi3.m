function [men,s]=findm_gi3(C, x)
M=[];
for i=1:length(C)
    M=[M;C(i).m];
end
d=pdist2(x,M);
[~,id]=sort(d);
% d=pdist2(x,M,'cosine');
% [~,id]=sort(d,'descend');
men=C(id(1)).m;
s=C(id(1)).st;  

end
