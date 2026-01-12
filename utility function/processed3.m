function uu=processed3(temp,xgdv,xbest,r,i,NN) 
id=randsample(5,1);
xxbest=xbest(id,:);
while isequal(temp(i).rnvec,xxbest)
    id=randsample(5,1);
    xxbest=xbest(id,:);
end

ve_xgdv=xgdv-temp(i).rnvec;  
ve_xbest=xxbest-temp(i).rnvec;  

%xi-xi,g、xi-xi,p的直线参数方程
t=rand;   %随机取一点
P=temp(i).rnvec+t*ve_xgdv;   %P点
Q=temp(i).rnvec+t*ve_xbest;  %

rr=randsample(length(xgdv),NN); 
U=zeros(NN,length(xgdv));
%分别求xi-xi,g和xi-xi的垂直方向向量
for j=1:NN 
    a=ve_xgdv;
    b=ve_xbest;
    temp1=temp(r(j)).rnvec;
    x1=temp1;
    temp1(rr(j))=[];
    a(rr(j))=[];
    v1=-(sum(temp1.*a))/ve_xgdv(rr(j));
    x1(rr(j))=v1; 
    d1=x1;
    
    temp2=temp(r(j+1)).rnvec; 
    x2=temp2;
    temp2(rr(j))=[];
    b(rr(j))=[];
    v2=-(sum(temp2.*b))/ve_xbest(rr(j));
    x2(rr(j))=v2; 
    d2=x2;
    
    U(j,:)=line_intersection_n(P,d1,Q,d2); 
  
end
  uu=mean(U,1);
end