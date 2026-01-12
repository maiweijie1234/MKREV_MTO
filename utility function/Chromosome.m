classdef Chromosome    
    properties
        rnvec; % (genotype)--> decode to find design variables --> (phenotype) 
        factorial_costs;
        factorial_ranks;
        scalar_fitness;
        skill_factor;
        convio=[];
        rank=0;
    end    
    methods        
        function object = initialize(object,D)            
            object.rnvec = rand(1,D);             
        end
        function object = Initialization(object,D)            
            object.rnvec = (rand(1,D)-0.5)*2.*randi([0 1],1,D);            
        end
        function object = Initialization_log(object,D)            
            object.rnvec = logical(randi([0,1],1,D));            
        end
       
        function [object] = evaluate(object,Tasks)                     
                    [object.factorial_costs,~]=fnceval(Tasks(object.skill_factor),object.rnvec);
                    %[object.factorial_costs,~]=fnceval2(Tasks(object.skill_factor),object.rnvec);
        end
        
        % SBX
        function object=crossover(object,p1,p2,cf)
            object.rnvec=0.5*((1+cf).*p1.rnvec + (1-cf).*p2.rnvec);
            object.rnvec(object.rnvec>1)=1;
            object.rnvec(object.rnvec<0)=0;
        end
        
        % polynomial mutation
        function object=mutate(object,p,dim,mum)
            rnvec_temp=p.rnvec;
            for i=1:dim
                if rand(1)<1/dim
                    u=rand(1);
                    if u <= 0.5
                        del=(2*u)^(1/(1+mum)) - 1;
                        rnvec_temp(i)=p.rnvec(i) + del*(p.rnvec(i));
                    else
                        del= 1 - (2*(1-u))^(1/(1+mum));
                        rnvec_temp(i)=p.rnvec(i) + del*(1-p.rnvec(i));
                    end
                end
            end  
            object.rnvec = rnvec_temp;          
        end  
        
    end
end