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
[cluster_true, ~] = cluster_function(be_matrix); 
[cluster_estimated, closeidx_estimated] = cluster_function(min_beta);
cluster_result = compute_cluster_result(cluster_true, cluster_estimated); 
my=cell2mat(y);m=size(y{1,1},1);
y1=reshape(my(1:m:end),size(y));
y2=reshape(my(2:m:end),size(y));
[cluster_y1, closeidx_y1] = cluster_function(y1);  
[cluster_y2, closeidx_y2] = cluster_function(y2); 
y1_mean=mean(y1,1);y2_mean=mean(y2,1);
y_mean=[y1_mean;y2_mean];
si=zeros(1,I);me=zeros(1,I);
for i=1:I
    si(i)=(y_mean(1,i)-y_mean(2,i))/(Nt1-Nt2); 
    me(i)=y_mean(1,i)-si(i)*Nt1; 
end
[me_all,sort_nunber]=sort(me);si_all=si(sort_nunber);
y1=y1(:,sort_nunber);y2=y2(:,sort_nunber);
conf_1=zeros(1,I);conf_2=zeros(1,I);
for i=1:I
    conf_1(i)=me_all(i)-si_all(i);   conf_2(i)=me_all(i)+si_all(i);
    axy1=line([i,i],[conf_1(i),conf_2(i)],'color','r','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_1(i),conf_1(i)],'color','r','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_2(i),conf_2(i)],'color','r','linestyle','-','LineWidth',1);hold on
end
x=1:1:I;
plot(x,me_all,'-*r','LineWidth',1); hold on
axis([0,16,0,3]) 
set(gca,'XTick',0:1:16)
xlabel('Predicted Variable'); ylabel('Aggregation');
N_random_selected=3; 
vector_expert=1:K;
vector_random_expert=nchoosek(vector_expert,N_random_selected);
figure(1);
number_com=nchoosek(K,N_random_selected);
me_random_ratio_matrix=zeros(number_com,I);si_random_ratio_matrix=zeros(number_com,I);
for num=1:number_com
    expert_random_selected=vector_random_expert(num,:);
    y1_random_selected=y1(expert_random_selected,:); y2_random_selected=y2(expert_random_selected,:);  
    y1_random_selected_mean=mean(y1_random_selected,1);y2_random_selected_mean=mean(y2_random_selected,1); 
    y_random_selected_mean=[y1_random_selected_mean;y2_random_selected_mean];
    si_random_selected=zeros(1,I);me_random_selected=zeros(1,I);conf_1_random_selected=zeros(1,I);conf_2_random_selected=zeros(1,I);
    me_random_ratio=zeros(1,I);si_random_ratio=zeros(1,I);
    for i=1:I
        si_random_selected(i)=(y_random_selected_mean(1,i)-y_random_selected_mean(2,i))/(Nt1-Nt2);
        me_random_selected(i)=y_random_selected_mean(1,i)-si_random_selected(i)*Nt1;
        conf_1_random_selected(i)=me_random_selected(i)-si_random_selected(i);   conf_2_random_selected(i)=me_random_selected(i)+si_random_selected(i);
        axy2=line([i,i],[conf_1_random_selected(i),conf_2_random_selected(i)],'color',[192 192 192]/255,'linestyle','-');hold on
        line([i-0.05,i+0.05],[conf_1_random_selected(i),conf_1_random_selected(i)],'color',[192 192 192]/255,'linestyle','-');hold on
        line([i-0.05,i+0.05],[conf_2_random_selected(i),conf_2_random_selected(i)],'color',[192 192 192]/255,'linestyle','-');hold on
    end
    x=1:1:I;
    plot(x,me_random_selected,'-*','color',[192 192 192]/255);
end
legend_1=strcat('Aggregation on all 10 experts');
legend_2='Aggregation on Randomly Selected Experts';
legend([axy1(1),axy2(1)],legend_1,legend_2,'Location','North','Orientation','horizon','NumColumns',2);
legend boxoff;
expert_y1_selected = closeidx_y1';
y1_y1_selected=y1(expert_y1_selected,:); y2_y1_selected=y2(expert_y1_selected,:);  
y1_y1_selected_mean=mean(y1_y1_selected,1);y2_y1_selected_mean=mean(y2_y1_selected,1); 
y_y1_selected_mean=[y1_y1_selected_mean;y2_y1_selected_mean];
si_y1_selected=(y_y1_selected_mean(1,:)-y_y1_selected_mean(2,:))/(Nt1-Nt2);
me_y1_selected=y_y1_selected_mean(1,:)-si_y1_selected(1,:)*Nt1;
conf_1_y1_selected=me_y1_selected-si_y1_selected;conf_2_y1_selected=me_y1_selected+si_y1_selected;
for i=1:I
    axy6=line([i,i],[conf_1_y1_selected(i),conf_2_y1_selected(i)],'color','g','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_1_y1_selected(i),conf_1_y1_selected(i)],'color','g','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_2_y1_selected(i),conf_2_y1_selected(i)],'color','g','linestyle','-','LineWidth',1);hold on
end
x=1:1:I;
plot(x,me_y1_selected,'-g*','LineWidth',1);
axis([0,16,0,3]) 
set(gca,'XTick',0:1:16) 
xlabel('Predicted Variable'); ylabel('Aggregation');
expert_y2_selected= closeidx_y2'; 
y1_y2_selected=y1(expert_y2_selected,:); y2_y2_selected=y2(expert_y2_selected,:);  
y1_y2_selected_mean=mean(y1_y2_selected,1);y2_y2_selected_mean=mean(y2_y2_selected,1); 
y_y2_selected_mean=[y1_y2_selected_mean;y2_y2_selected_mean];
si_y2_selected=(y_y2_selected_mean(1,:)-y_y2_selected_mean(2,:))/(Nt1-Nt2);
me_y2_selected=y_y2_selected_mean(1,:)-si_y2_selected*Nt1;
conf_1_y2_selected=me_y2_selected-si_y2_selected;conf_2_y2_selected=me_y2_selected+si_y2_selected;
for i=1:I
    axy7=line([i,i],[conf_1_y2_selected(i),conf_2_y2_selected(i)],'color',[64 224 208]/255,'linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_1_y2_selected(i),conf_1_y2_selected(i)],'color',[64 224 208]/255,'linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_2_y2_selected(i),conf_2_y2_selected(i)],'color',[64 224 208]/255,'linestyle','-','LineWidth',1);hold on
end
x=1:1:I;
plot(x,me_y2_selected,'-*','color',[64 224 208]/255,'LineWidth',1);
expert_beta_selected=closeidx_estimated'; 
y1_beta_selected=y1(expert_beta_selected,:); y2_beta_selected=y2(expert_beta_selected,:);  
y1_beta_selected_mean=mean(y1_beta_selected,1);y2_beta_selected_mean=mean(y2_beta_selected,1); 
y_beta_selected_mean=[y1_beta_selected_mean;y2_beta_selected_mean];
si_beta_selected=(y_beta_selected_mean(1,:)-y_beta_selected_mean(2,:))/(Nt1-Nt2);
me_beta_selected=y_beta_selected_mean(1,:)-si_beta_selected*Nt1;
conf_1_beta_selected=me_beta_selected-si_beta_selected;conf_2_beta_selected=me_beta_selected+si_beta_selected;
for i=1:I
    axy3=line([i,i],[conf_1_beta_selected(i),conf_2_beta_selected(i)],'color','b','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_1_beta_selected(i),conf_1_beta_selected(i)],'color','b','linestyle','-','LineWidth',1);hold on
    line([i-0.05,i+0.05],[conf_2_beta_selected(i),conf_2_beta_selected(i)],'color','b','linestyle','-','LineWidth',1);hold on
end
x=1:1:I;
plot(x,me_beta_selected,'-b*','LineWidth',1);
legend_1=strcat('Aggregation on all 10 experts');
legend_6='Aggregation on Experts 2, 6 and 8 from y(0.3) Cluster';
legend_3='Aggregation on Experts 2, 7 and 8 from ¦Â Cluster (Method a)';
legend_7='Aggregation on Experts 4, 5 and 7 from y(0.8) Cluster';
legend([axy1(1),axy3(1),axy6(1),axy7(1)],legend_1,legend_3,legend_6,legend_7,'Location','North','Orientation','horizon','NumColumns',2);
legend boxoff;