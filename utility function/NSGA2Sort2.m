function [rank, FrontNo, CrowdDis] = NSGA2Sort2(population)

    Objs=vec2mat([population.factorial_costs],3);
    %Objs=vec2mat([population.factorial_costs],2);
    CVs=[population.convio]';
    FrontNo = NDSort(Objs, CVs, inf);
    CrowdDis = CrowdingDistance(Objs, FrontNo);
    [~, rank] = sortrows([FrontNo', -CrowdDis']);
end    
