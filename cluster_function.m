function [cluster_result, closeidx, cluster_num] = cluster_function(beta)
opts = statset('Display','off');
num=3;          
repN=50;       
[Idx_1,~,~,D] = kmeans(beta,num,'Replicates',repN,'Options',opts);
for i=1:num
    tm_1=find(Idx_1==i); 
    tm_1=reshape(tm_1,1,length(tm_1));
    cluster_result{i,1} = int2str(tm_1);
    [~, j] = min(D(tm_1, i));
    closeidx(i, 1) = tm_1(1, j);
    cluster_num(i,1) = length(tm_1);
end
