function COV = getCov(x, y)  
% generate NVARS*NVARS Dim cov matrix
cur_ar_size = size(x, 1);
pop_Dev = zeros(cur_ar_size, size(x,2));
for i = 1:cur_ar_size
    pop_Dev(i, :) = archive{task_idx}(i).Dev(1:NVARS);               
end
COV = cov(pop_Dev);
end
