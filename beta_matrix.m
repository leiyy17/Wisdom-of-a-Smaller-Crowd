function beta=beta_matrix(be)  
global K; global N; global Q;
beta=[];
for k=1:K
    b=be((k-1)*Q+1:k*Q);
    b=repmat({b'},N,1);  
    beta=[beta;blkdiag(b{:})];  
end
end