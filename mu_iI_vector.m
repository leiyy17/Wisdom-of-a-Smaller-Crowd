function mu_iI=mu_iI_vector(mu)
global I; global Q; global N;
mu=reshape(mu,I,Q)';
for i=1:I
    mu_iI{i}=repmat(mu(:,i),N,1);
end
end