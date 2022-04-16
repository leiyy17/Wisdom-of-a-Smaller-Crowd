function beta_q=beta_q_matrix(be)  
global K; global N; global Q;
be=reshape(be,Q,K)';
for q=1:Q
    beta_q{q}=[];
    for k=1:K
        b=repmat({be(k,q)},N,1);
        beta_q{q}=[beta_q{q};blkdiag(b{:})];
    end
end
end