function mu_qiI=mu_qiI_vector(mu)
global I; global Q; global N;
mu=reshape(mu,I,Q)';
for q=1:Q
    for i=1:I
        mu_qiI{q,i}=repmat(mu(q,i),N,1);
    end
end
end