function u = getMul(x, y, invcov)
% KLD second step
% pop0_archive = archive{t0};
% pop1_archive = archive{t1};
% cur_ar_size0 = size(pop0_archive, 1);
% cur_ar_size1 = size(pop1_archive, 1);
% pop0_Dev = zeros(cur_ar_size0, NVARS);
% pop1_Dev = zeros(cur_ar_size1, NVARS);
% for i = 1:cur_ar_size0
%     pop0_Dev(i, :) = pop0_archive(i).Dev(1:NVARS);               
% end
% for i = 1:cur_ar_size1
%     pop1_Dev(i, :) = pop1_archive(i).Dev(1:NVARS);
% end
u0 = mean(x);
u1 = mean(y);
u = (u1 - u0) * invcov * (u1 - u0)';
end