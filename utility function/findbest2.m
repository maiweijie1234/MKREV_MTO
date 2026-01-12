function [x,tempst]=findbest2(p)
%[~,index]=sort([p.rank]);
%iindex=sort(index);
M=vec2mat([p.rnvec],length(p(1).rnvec));
tempst=std(M);
n=5;
bestid=randsample(n,3);
x(1,:)=p(bestid(1)).rnvec;
x(2,:)=p(bestid(2)).rnvec;
x(3,:)=p(bestid(3)).rnvec;
end
