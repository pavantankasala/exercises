% By Pavan Tankasala,
% applied support vector machine only tested with linear kerenel and will
% be exploring more on various kernels.

for i=1:length(good_deals)
    k=good_deals{i};
    l=bad_deals{i};
    kl{i}=double(k);
    ml{i}=double(l);
end
kl2=kl';
ml2=ml';
lvl=3;offst=3;

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

SVMStruct = svmtrain(x00,[ones(1,18) zeros(1,18)]);
SVMclassify(SVMStruct,cell2mat(Test)');
