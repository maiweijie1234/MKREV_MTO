function archive = putarchive(archive, task_idx, individual, N,ArcMultip)
for i=1:length(individual.Dev)
    max_size = ArcMultip * N;  
    archive_size = size(archive{task_idx}, 1);  
    if archive_size < max_size
        archive_size = archive_size + 1;
        tempindiv.Dev=individual.Dev(i,:);
        tempindiv.Obj=individual.Obj(i);
        archive{task_idx}(archive_size, 1) = tempindiv;  
    else
        while 1
             L = ceil(rand * max_size); 
             if L ~= 0  
                  break;
             end
        end
        tempindiv.Dev=individual.Dev(i,:);
        tempindiv.Obj=individual.Obj(i);
        archive{task_idx}(L, 1) = tempindiv;  
    end
end
end