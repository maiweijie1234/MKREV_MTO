function [num, possibility] = adaptivechoose(task_idx, T, archive, reward, possibility, Dim, Ro)
sum = 0;
sim = calSIM(task_idx, T, archive, Dim);   
% update possibility table
for i = 1:T
    if i == task_idx
       continue;
    end
    %task_idx
    possibility(task_idx, i) = Ro * possibility(task_idx, i) + reward(task_idx, i) / (1 + log(1 + sim(i, 1)));
    %sum
    sum = sum + possibility(task_idx, i);
end
p = rand;
s = 0;
for i = 1:T
    if i == task_idx
        continue;
    end
    s = s + possibility(task_idx, i) / sum;  %roulette wheel selection
    if s >= p       
        break;
    end
end
num = i;  
end