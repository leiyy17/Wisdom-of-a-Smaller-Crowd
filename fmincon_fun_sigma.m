function f=fmincon_fun_sigma(x,A,B,be0,mu,q,i)
global I; global Q; global N; global K;  global Nt; global t;
beta_q=beta_q_matrix(be0);
for t1=1:size(t)
    for t2=1:size(t)
        at(t1,t2)=a(t(t1),t(t2));
    end
end
si_xi=x.^2*at;
for t1=1:size(t)
    for t2=1:size(t)
        bt(t1,t2)=b(t(t1),t(t2));
    end
end
si_epsilon=[];
be0=reshape(be0,Q,K)';
for k=1:K
    si_epsilon_k=be0(k,q)*x*bt;
    si_epsilon=blkdiag(si_epsilon,si_epsilon_k);
end
S=beta_q{q}*si_xi*beta_q{q}.'+si_epsilon; 
si_qi=x.*Nt;
mu=reshape(mu,I,Q)';
mu_qi=repmat(mu(q,i),N,1);
M=beta_q{q}*(si_qi+mu_qi);
f=log((2*pi).^N*det(S))+ones(1,K*N)*(B.*inv(S))*ones(K*N,1)+2*(A-M).'*inv(S)*A+(A-M).'*inv(S)*(A-M);
end