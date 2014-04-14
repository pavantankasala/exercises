% By pavan Tankasala
% CO-occurence feature as feature discriptors
% Nueral netwroks with Bayesian backpropagation, scale conjugate method,
% levan margett method
% neural nets results for 25 avergae runs.
% Test data was unseen till the end of the process and its tested only
% once. Parmeters for GLCM and neural networks are set on training data
% which is divided into 60% for training and 40% for testing.


for i=1:length(good_deals)
    k=good_deals{i};
    l=bad_deals{i};
    kl{i}=double(k);
    ml{i}=double(l);
end
kl2=kl';
ml2=ml';
lvl=12;offst=10;

        for i=1:length(kl2)
          jl=kl2{i};
    
    glcm = graycomatrix(uint8(jl)','NumLevels',lvl, 'offset', [offst 0]);
    stats = graycoprops(glcm);
    H{i}=[stats.Contrast stats.Correlation stats.Energy  stats.Homogeneity]';
    gl=ml2{i};
    glcm = graycomatrix(uint8(gl)','NumLevels',lvl,'offset', [offst 0]);
    stats = graycoprops(glcm);
    M{i}=[stats.Contrast stats.Correlation stats.Energy  stats.Homogeneity]';
        end
for j=1:18
G1=randperm(length(H));
G2=randperm(length(M));

for b=1:floor(length(H)*0.6)
    gen_H1{b}=H{G1(b)};
    
end
f=1;
for c=floor(length(H)*0.6)+1:length(H)
    gen_H2{f}=H{G1(c)};
    f=f+1;
end

for b=1:floor(length(M)*0.6)
    imp_H1{b}=M{G2(b)};
    
end
f=1;
for c=floor(length(M)*0.6)+1:length(M)
    imp_H2{f}=M{G2(c)};
    f=f+1;
end
net.trainParam.epochs=100;
net.trainParam.goal=0;
net.trainParam.mu=0.05;
net.trainParam.mu_dec=0.01;
net.trainParam.mu_inc=10;
net.trainParam.max_fail=500;
net.trainParam.min_grad=1e-3;
net.trainParam.show=25;
net.trainParam.showCommandLine=0;
net.trainParam.showWindow=0; 


net = newff([cell2mat(gen_H1) cell2mat(imp_H1)],[ones(1,18) zeros(1,18)],36,{},'trainscg');
net = train(net,[cell2mat(gen_H1) cell2mat(imp_H1)],[ones(1,18) zeros(1,18)]);
a = sim(net,[cell2mat(gen_H1) cell2mat(imp_H1)]);
a1= sim(net,[cell2mat(gen_H2) cell2mat(imp_H2)]);

[roc,EER_Trn{j},area_Trn{j}]=ezroc3(a,[ones(1,18) zeros(1,18)],0);
[roc,EER_Val{j},area_Val{j}]=ezroc3(a1,[ones(1,12) zeros(1,12)],0);
EER_Val
if j==1
    S=a1;
else
    S=S+a1;
end
net_store{j}=net;
end
    
% EER_Trn_avg=sum(cell2mat(EER_Val))/length(EER_Val);
% AUC_Trn_avg=sum(cell2mat(area_Val))/length(area_Val);
% [lvl offst EER_Trn_avg AUC_Trn_avg]


for i=1:length(test_deals)
    k=test_deals{i};
    kl{i}=double(k);
end
kl2=kl';

lvl=3;offst=3;

        for i=1:length(kl2)
          jl=kl2{i};
    
    glcm = graycomatrix(uint8(jl)','NumLevels',lvl, 'offset', [offst 0]);
    stats = graycoprops(glcm);
    Test{i}=[stats.Contrast stats.Correlation stats.Energy  stats.Homogeneity]';
    
        end
        for i=1:18
        a2{i}= sim(net_store{i},Test);
        end
        
for i=1:18
    if i==1
        Out_test=cell2mat(a2{i})';
    else
        Out_test=Out_test+cell2mat(a2{i})';
    end
end
 HJK=sum(Out_test)>12;
 HJK=Out_test>12;







    