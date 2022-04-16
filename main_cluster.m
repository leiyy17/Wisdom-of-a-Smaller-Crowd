clear;clc;system('taskkill /F /IM EXCEL.EXE');
global K; global I; global Q; global N; global t; global Nt; con=0;
K=3; I=2; Q=2;  
forecast_error=importdata('./data.xlsx'); 
N=2; t1=0.3; t2=0.8; t=[t1;t2];
Nt1=norminv(t1,0,1);  Nt2=norminv(t2,0,1); Nt=[Nt1;Nt2];  
id=1;
yxls=forecast_error(id,:); 
y=cell(K,I); 
for k=1:K
    for i=1:I
        y{k,i}=yxls(1,(k-1)*I*N+(i-1)*N+1:(k-1)*I*N+(i-1)*N+N)';
    end
end
y_it=y_vector(y);

r1=rand(K,Q); r2=sum(r1,2); be0=r1./r2; model0.beta=reshape(be0',K*Q,1);  
model0.sigma=rand(Q*I,1);  
model0.mu=10 * rand(Q*I,1);   
Li_real=L_real(y_it);
tol=0.001;  maxiter=100; 
for iter=1:maxiter
    be0=model0.beta;  si0=model0.sigma;
    model.mu=solve_mu(be0,si0,y_it);
    mu=model.mu;
    model.sigma=solve_sigma(be0,mu,y_it,si0);
    si=model.sigma;
    model.beta=solve_beta(si,mu,y_it,be0);
    modelxls(iter)=model;  
    L(iter)=result_y(model,y_it);
    if (norm(model.beta-model0.beta)<tol) && (norm(model.mu-model0.mu)<tol) && (norm(model.sigma-model0.sigma)<tol)
        break;
    end
    model0=model;
end
for it=1:iter
    x_sort_beta=reshape(modelxls(it).beta,Q,K)';
    x_sort_sigma=reshape(modelxls(it).sigma,I,Q)';
    x_sort_mu=reshape(modelxls(it).mu,I,Q)';
    [A,S]=sortrows(x_sort_beta');
    x_sort_beta=A';
    x_sort_sigma=x_sort_sigma(S,:);  
    x_sort_mu=x_sort_mu(S,:);
    modelxls(it).beta=reshape(x_sort_beta',K*Q,1);
    modelxls(it).sigma=reshape(x_sort_sigma',Q*I,1);
    modelxls(it).mu=reshape(x_sort_mu',Q*I,1);
end
[L_min,min_label]=min(L);
min_beta=reshape(modelxls(min_label).beta,Q,K)';
min_sigma=reshape(modelxls(min_label).sigma,I,Q)';
min_mu=reshape(modelxls(min_label).mu,I,Q)';
real_value=importdata('./real.xlsx');  real=real_value.data;
be_matrix=real(2:K+1,2:Q+1);
cluster_true = cluster_function(be_matrix);
cluster_estimated = cluster_function(min_beta);
cluster_result = compute_cluster_result(cluster_true, cluster_estimated);
