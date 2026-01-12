%Weijie Mai  12/3/2023
%MR=orth(randn(object.Tdims(1),object.Tdims(1)))
clear;
clc;
warning off
format short e
subpop=100; 
totaltimes=1; 
maxFES=50000;
Gmax=500;
promax=0.22;promin=0.1;
tec=3;
p1=0.5;
p2=0.2;

rootDir=fileparts(mfilename('fullpath')); 
%ch=genpath(rootDir);
addpath(genpath(rootDir)); 
%Path=addpath(genpath(rootDir));
cd(rootDir); 

for problem=1     
    %Tasks=struct(); 
    for i=1:9   %LMF  for i=1:12
        Tasks(i) = gettask2(i); 
        
    end   
    %data=getPF2(problem);
    K=length(Tasks); 
    Dmax=Tasks(1).D; 
    Outcome=[];
  
    for time=1:totaltimes
        disp(['第',num2str(time),'次']);                   
        g=1; 
        rand('seed', sum(rand*clock)); 
        skill_factor = 1;
        count =1;
        [W,N] = UniformPoint(100,2);   
        for k=1:K            
           for i = 1 : subpop
               P(count) = Chromosome();        
               off(count) = Chromosome();                 
               P(count) = initialize(P(count),Dmax);              
               P(count).skill_factor=skill_factor;
               off(count).skill_factor=skill_factor;
               P(count) = evaluate(P(count),Tasks);
               count = count+1;
           end
           skill_factor = skill_factor+1;
        end                                         
             
        FES=subpop;   
        tic
        
        while FES<=maxFES
            disp(['第',num2str(g),'代']);      
            pro=promin+(promax-promin)*(g/Gmax)^(2/3);  
            
            for k = 1:K             
                temp_pop = P((k-1)*subpop+1 : k*subpop);
                [rank,FrontNo] = NSGA2Sort2(temp_pop);                                    
                temp_pop=temp_pop(rank);
                P((k-1)*subpop+1 : k*subpop)=temp_pop;
            end 
            difference=inf.*ones(K);
            simkld=inf.*ones(K);
            %pearman=-inf.*ones(K);
            sigma = 1;
            for count1 = 1:K-1               
                T1 = P((count1-1)*subpop + 1: count1*subpop);
                rnvec_T1 = [T1.rnvec];
                rnvec_T1 = reshape(rnvec_T1 , [Dmax,length(rnvec_T1)/Dmax]);
                rnvec_T11 = [T1.rnvec];
                rnvec_T11 = vec2mat(rnvec_T11 , Dmax);
                for count2 = count1+1:K                   
                    if count2==count1
                       continue;
                    end
                    T2 = P((count2-1)*subpop + 1: count2*subpop);
                    rnvec_T2 = [T2.rnvec];
                    rnvec_T2 = reshape(rnvec_T2 , [Dmax,length(rnvec_T2)/Dmax]);
                    rnvec_T22 = [T2.rnvec];
                    rnvec_T22 = vec2mat(rnvec_T22 ,Dmax);
                    difference(count1,count2) = my_mmd(rnvec_T1, rnvec_T2, sigma);
                    difference(count2,count1) = difference(count1,count2);
                    simkld(count1,count2) = calsim(rnvec_T11, rnvec_T22);
                    simkld(count2,count1) = simkld(count1,count2);                   
                end
            end
            
            PP=P;
            for k=1:K    
                StartIndex = (k-1) * subpop+1;%the index of the first individual of task i in the whole population
                EndIndex = k*subpop;
                temp=P([P.skill_factor]==k);                                          
                objs=vec2mat([temp.factorial_costs],2);
                [z,znad] = deal(min(objs),max(objs));
                xbest=findbest2(temp); %3-objective is set to findbest3  
                xxbest=xbest(1,:);   
                cospop=COSTASK3(P, difference(k,:),simkld(k,:), k); 
                [GAN_modle,~] = gan(temp);    
                     
                for i=1:length(temp)                                                             
                    
                    %*******mutation***************************  
                    if rand<pro                                                                                                  
                       [men,st]=findm_gi3(cospop, temp(i).rnvec);                 
                       u=cauchyrnd(men, st, 1);   
     
                    else                            
                       gm = nnff(GAN_modle,temp(i).rnvec);                       
                       xgdv=gm.layers{3}.a;                    
                       n=[1:i-1,i+1:length(temp)];
                       r=randsample(n,length(temp)-1); 
                       uu=processed2(temp,xgdv,xbest,r,i,1); %3-objective is set to processed3                        
                        
                        %%test                      
                        u=temp(i).rnvec+p1*(uu-temp(i).rnvec)+p2*(temp(r(1)).rnvec-temp(r(2)).rnvec);                     
                                             
                    end                    
                    %******************************************
                                                                                                             
                    %                
                    vioLowIndex=find(u<0);
                    u(vioLowIndex)=(temp(i).rnvec(vioLowIndex)+0.0)/2;               
                    vioUpIndex=find(u>1);
                    u(vioUpIndex)=(temp(i).rnvec(vioUpIndex)+1.0)/2;
                    
                    %crossover *********************************
                    j_rand = floor(rand * Dmax) + 1;
                    t = rand(1, Dmax) < 0.95;                   
                    t(1, j_rand) = 1;
                    t_ = 1 - t;
                    U= t .* u + t_ .* temp(i).rnvec;
                    %********************************************
                    
                    % 
                    off(StartIndex+i-1).rnvec=U;
                    off(StartIndex+i-1)= evaluate(off(StartIndex+i-1),Tasks);
                 
                end   
                off_pop = off((k-1)*subpop+1 : k*subpop);                                   
                
                %
                %survi_rate(g,k)=count/100;
                %
                if tec==1
                    Population = EnvironmentalSelection_NSGAII([Population,Offspring],Problem.N); 
                end

                if tec==2
                    z       = min([z;Offspring(all(Offspring.cons<=0,2)).objs],[],1);
                    Population = EnvironmentalSelection_NSGAIII([Population,off_pop],N,W,z); 
                end

                if tec==3
                    [Population,z,znad] = EnvironmentalSelection_TDEA([temp,off_pop],W,N,z,znad);
                end

                if tec==4
                    [Population,z,znad] = EnvironmentalSelection_MOEAC([Population,Offspring],Problem.N,z,znad,Problem.N); 
                end
%                 com_temp=[temp,off_pop];
%                 rank = NSGA2Sort2(com_temp);                
%                 com_temp = com_temp(rank);
             
                %P(StartIndex:EndIndex)=Population;     
                PP(StartIndex:EndIndex)=Population; 
            end
            
            for i = 1:K                   
                %temp_pop = P((i-1)*subpop+1 : i*subpop);     
                temp_pop = PP((i-1)*subpop+1 : i*subpop);
                T_data = vec2mat([temp_pop.factorial_costs],2); 
                data=Tasks(i).optimum;
                %hv=HV_clc(T_data,data);  %HV
                Distance = min(pdist2(data,T_data),[],2);  %IGD
                igd=mean(Distance);
                %IGD
                if  g == 1
                     IGD(g,i) = igd;
                elseif igd < IGD(g-1,i)
                    IGD(g,i) = igd; 
                else
                    IGD(g,i) = IGD(g - 1,i);
                end
                %%HV
%                 if  g == 1
%                      HV(g,i) = hv;
%                 elseif hv > HV(g-1,i)
%                     HV(g,i) = hv; 
%                 else
%                     HV(g,i) = HV(g - 1,i);
%                 end
               
            end   

            disp(['g = ', num2str(g), ' best solution = ', num2str(IGD(g,:))]);  
            %disp(['g = ', num2str(g), ' best solution = ', num2str(HV(g,:))]);
            P=PP;
            FES=FES+100;
            g=g+1;
            %BestFitness(g,:)=bestobj;
                
        end
              
%         Outcome(time,:)=min(fit)
%         FBest{time}=BestFitness;
    toc
    end
    
end