clear;clc;system('taskkill /F /IM EXCEL.EXE');
global K; global I; global Q; global N; global t; global Nt; con=0;
K=10; I=15; Q=5;  
forecast_error=importdata('./data.xlsx'); 
N=2; t1=0.3; t2=0.8; t=[t1;t2];
Nt1=norminv(t1,0,1);  Nt2=norminv(t2,0,1); Nt=[Nt1;Nt2];  
id=1;
yxls=forecast_error(id,:);
y=cell(K,I); 
for k=1:K
    for i=1:I
        y{k,i}=yxls(1,(k-1)*I*N+(i-1)*N+1:(k-1)*I*N+(i-1)*N+N)';
        y{k,i}=sort(y{k,i});
    end
end
y_it=y_vector(y);
r1=rand(K,Q); r2=sum(r1,2); be0=r1./r2; model0.beta=reshape(be0',K*Q,1); 
model0.sigma=rand(Q*I,1);  
model0.mu=10 * rand(Q*I,1);    
Li_real=L_real(y_it);
tol=0.001;  maxiter=50;  
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
[cluster_true, ~, cluster_num_true] = cluster_function(be_matrix); 
[cluster_estimated, closeidx_estimated, cluster_num_estimated] = cluster_function(min_beta);  
cluster_result = compute_cluster_result(cluster_true, cluster_estimated);
my=cell2mat(y);m=size(y{1,1},1);
y1=reshape(my(1:m:end),size(y));
y2=reshape(my(2:m:end),size(y));
y1_mean=mean(y1,1);y2_mean=mean(y2,1); 
y_mean=[y1_mean;y2_mean];
si=zeros(1,I);me=zeros(1,I);
for i=1:I
    si(i)=(y_mean(1,i)-y_mean(2,i))/(Nt1-Nt2); 
    me(i)=y_mean(1,i)-si(i)*Nt1; 
end
[me_all,sort_nunber]=sort(me);si_all=si(sort_nunber);
y1=y1(:,sort_nunber);y2=y2(:,sort_nunber);
expert_beta_selected=closeidx_estimated';  
y1_beta_selected=y1(expert_beta_selected,:); y2_beta_selected=y2(expert_beta_selected,:); 
y1_beta_selected_mean_a=mean(y1_beta_selected,1);
y2_beta_selected_mean_a=mean(y2_beta_selected,1); 
y_beta_selected_mean_a=[y1_beta_selected_mean_a;y2_beta_selected_mean_a];
si_beta_selected_a=(y_beta_selected_mean_a(1,:)-y_beta_selected_mean_a(2,:))/(Nt1-Nt2);
me_beta_selected_a=y_beta_selected_mean_a(1,:)-si_beta_selected_a*Nt1;
y1_beta_selected_mean_b = (y1_beta_selected.* cluster_num_true)/I;
y2_beta_selected_mean_b = (y2_beta_selected.* cluster_num_true)/I;
y_beta_selected_mean_b=[y1_beta_selected_mean_b;y2_beta_selected_mean_b];
si_beta_selected_b=(y_beta_selected_mean_b(1,:)-y_beta_selected_mean_b(2,:))/(Nt1-Nt2);
me_beta_selected_b=y_beta_selected_mean_b(1,:)-si_beta_selected_b*Nt1;
M_tau = [var(be_matrix(cluster_estimated{1,1},:)); var(be_matrix(cluster_estimated{2,1},:));var(be_matrix(cluster_estimated{3,1},:))];
for ml = 1 : 3
    if cluster_num_estimated(ml,1) == 0
        M_l(ml,:) = zeros(1, Q);
    else
        for mll = 1 : cluster_num_estimated(ml,1)-1
            be_m = be_matrix(cluster_estimated{ml,1},:);
            be_new_matrix(mll,:)=be_m(mll+1,:)-be_m(mll,:);
        end
        M_l(ml,:) = mean(be_new_matrix);
    end
end
M_beta = [mean(be_matrix(cluster_estimated{1,1},:)); mean(be_matrix(cluster_estimated{2,1},:)); mean(be_matrix(cluster_estimated{3,1},:))];
taulbeta = M_tau.* M_l.* M_beta;
weight_c = 1/Q * cluster_num_true.* sum(taulbeta, 2) + cluster_num_true;
y1_beta_selected_mean_c = (y1_beta_selected.* weight_c)/I;
y2_beta_selected_mean_c = (y2_beta_selected.* weight_c)/I;
y_beta_selected_mean_c=[y1_beta_selected_mean_c;y2_beta_selected_mean_c];
si_beta_selected_c=(y_beta_selected_mean_c(1,:)-y_beta_selected_mean_c(2,:))/(Nt1-Nt2);
me_beta_selected_c=y_beta_selected_mean_c(1,:)-si_beta_selected_c*Nt1;
me_MAPE_a = mean(abs(me_beta_selected_a - me_all)./me_all);
si_MAPE_a = mean(abs(si_beta_selected_a - si_all)./si_all);
me_MAPE_b = mean(abs(me_beta_selected_b - me_all)./me_all);
si_MAPE_b = mean(abs(si_beta_selected_b - si_all)./si_all);
me_MAPE_c = mean(abs(me_beta_selected_c - me_all)./me_all);
si_MAPE_c = mean(abs(si_beta_selected_c - si_all)./si_all);
me_sMAPE_a = mean(abs(me_beta_selected_a - me_all)./((abs(me_all)+abs(me_beta_selected_a))/2));
si_sMAPE_a = mean(abs(si_beta_selected_a - si_all)./((abs(si_all)+abs(si_beta_selected_a))/2));
me_sMAPE_b = mean(abs(me_beta_selected_b - me_all)./((abs(me_all)+abs(me_beta_selected_b))/2));
si_sMAPE_b = mean(abs(si_beta_selected_b - si_all)./((abs(si_all)+abs(si_beta_selected_b))/2));
me_sMAPE_c = mean(abs(me_beta_selected_c - me_all)./((abs(me_all)+abs(me_beta_selected_c))/2));
si_sMAPE_c = mean(abs(si_beta_selected_c - si_all)./((abs(si_all)+abs(si_beta_selected_c))/2));