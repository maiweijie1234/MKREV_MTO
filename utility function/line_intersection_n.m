function inter=line_intersection_n(P,d1,Q,d2)
    D=length(P);
    t1=rand(1,D)*mean(P); 
    t2=rand(1,D)*mean(Q); 
    X1=P+t1'.*d1;
    X2=Q+t2'.*d2;
    x1=mean(X1);
    x2=mean(X2);
    if rand<0.7
        inter=x1;
    else
        inter=x2;
    end
%     if v1<0 &&v2>0
%         inter=x1;
%     elseif v1>0 && v2<0
%         inter=x2;
%     else
%         if rand<0.8
%             inter=x1;
%         else
%             inter=x2;
%         end
%     end

    
end


% P1=[0;0;0];
% V1=[1;1;1];
% P2=[1;0;0];
% V2=[0;1;1];
% line_intersection_n(P1,V1,P2,V2)