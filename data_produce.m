clear; clc; system('taskkill /F /IM EXCEL.EXE');
global K; global I; global Q; global N; global t; global Nt;
K=3; I=2; Q=2; 
N_sample=1;
N=2; t1=0.3; t2=0.8; t=[t1;t2];
Nt1=norminv(t1,0,1);  Nt2=norminv(t2,0,1); Nt=[Nt1;Nt2]; 
dNt1=difference(t1);  dNt2=difference(t2); dNt=[dNt1;dNt2];
% real_value=importdata('./real.xlsx'); 
% real=real_value.data;
% be_matrix=real(2:K+1,2:Q+1); 
% si_matrix=real(K+3:K+Q+2,2:I+1); 
% mu_matrix=real(K+Q+4:K+2*Q+3,2:I+1); 
r1=rand(K,Q); r2=sum(r1,2); be_matrix=r1./r2;  
si_matrix=rand(1,1) * ones(Q, I); 
mu_matrix=10 * rand(Q,I);
delete('real.xlsx');
xlswrite('./real.xlsx', {'beta'}, 1, 'A1'); 
xlswrite('./real.xlsx', [1:K]', 1, 'A2');  xlswrite('./real.xlsx', [1:Q], 1, 'B1'); 
xlswrite('./real.xlsx', be_matrix, 1, 'B2');
xlswrite('./real.xlsx', {'sigma'}, 1, [char('A'),num2str(2+K)]);
xlswrite('./real.xlsx', [1:Q]', 1, [char('A'),num2str(3+K)]);  xlswrite('./real.xlsx', [1:I], 1, [char('B'),num2str(2+K)]); 
xlswrite('./real.xlsx', si_matrix, 1, [char('B'),num2str(3+K)]);
xlswrite('./real.xlsx', {'mu'}, 1, [char('A'),num2str(3+K+Q)]);
xlswrite('./real.xlsx', [1:Q]', 1, [char('A'),num2str(4+K+Q)]);  xlswrite('./real.xlsx', [1:I], 1, [char('B'),num2str(3+K+Q)]);
xlswrite('./real.xlsx', mu_matrix, 1, [char('B'),num2str(4+K+Q)]);
be=reshape(be_matrix',K*Q,1); 
si=reshape(si_matrix',Q*I,1);  
mu=reshape(mu_matrix',Q*I,1);
beta=beta_matrix(be); 
sigma_iNt=sigma_iNt_vector(si);
mu_iI=mu_iI_vector(mu);
Sigma_xi_it=covariance_xi_it(si);
Sigma_epsilon_it=covariance_epsilon_it(be,si);
me=cell(I);  cov=cell(I);
rdata = cell(I, 1);
data = [];
for i=1:I
    me{i}=beta*(sigma_iNt{i}+mu_iI{i});   
    cov{i}=beta*Sigma_xi_it{i}*beta.'+Sigma_epsilon_it{i}; 
    rdata{i}=mvnrnd(me{i},cov{i},N_sample);
    for k=1:K
        xls=rdata{i}(:,(k-1)*N+1:k*N);
        if (i-1)*N+2*I*(k-1)<=25
            xlswrite('data.xlsx',xls,1,[char('A'+(i-1)*N+2*I*(k-1)),num2str(1)]);
        else
            xlswrite('data.xlsx',xls,1,[char('A'+floor(((i-1)*N+2*I*(k-1))/26)-1) char('A'+(i-1)*N+2*I*(k-1)-26*floor(((i-1)*N+2*I*(k-1))/26)),num2str(1)]);
        end
    end
    system('taskkill /F /IM EXCEL.EXE');  
end

    