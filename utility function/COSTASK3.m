function [cospop,simkld]=COSTASK3(population , difference,simkld, k)
g1=3e-1;
g2=3;
cvs=[];
cospop = struct;
difference(k)=[];
simkld(k)=[];
dim = length(population(end).rnvec);
P=population;
knowledge_task_num =4;   
I1=g1*simkld./(2+difference).^2;
I2=g2*difference./sqrt(simkld);

[~,xx]=sort(I1);
[~,yy]=sort(I2);
[~,id1]=sort(xx);
[~,id2]=sort(yy);
objs=[I1;I2];
objs=objs';
rank=NSGA2Sort4(objs,cvs);
%     Subpop = population([population.skill_factor] == i);
%     SubpopRnvec = [Subpop(1:end).rnvec];
%     SubpopRnvec = vec2mat(SubpopRnvec , dim);
    %--------------Generate GI's population--------------------------
for j = 1:knowledge_task_num
    if xx(j)==yy(j)
        kk=xx(j);
        temp=P([P.skill_factor]==kk);
        M=vec2mat([temp.rnvec],dim);
        men=mean(M);
        st=std(M);
        cospop(j).con = M;
        cospop(j).m = men;
        cospop(j).st=st;
    else
        if id1(rank(j))<=id2(rank(j))
            kk=xx(j);
            temp=P([P.skill_factor]==kk);
            M=vec2mat([temp.rnvec],dim);
            men=mean(M);
            st=std(M);
            cospop(j).con = M;
            cospop(j).m = men;
            cospop(j).st=st;
        else
            kk=yy(j);
            temp=P([P.skill_factor]==kk);
            M=vec2mat([temp.rnvec],dim);
            men=mean(M);
            st=std(M);
            cospop(j).con = M;
            cospop(j).m = men;
            cospop(j).st=st;
        end
    end
end
                   
end