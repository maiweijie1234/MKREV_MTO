function [x,tempst]=findbest3(p)
%[~,index]=sort([p.rank]);
%iindex=sort(index);
M=vec2mat([p.rnvec],length(p(1).rnvec));
tempst=std(M);
n=7;
bestid=randsample(n,5);
x(1,:)=p(bestid(1)).rnvec;
x(2,:)=p(bestid(2)).rnvec;
x(3,:)=p(bestid(3)).rnvec;
x(4,:)=p(bestid(4)).rnvec;
x(5,:)=p(bestid(5)).rnvec;
end
