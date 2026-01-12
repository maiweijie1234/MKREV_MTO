function tr = getTrace(inv_cov1, cov2)
% KLD first step
fmatrix = inv_cov1 * cov2;
tr = sum(diag(fmatrix));
end