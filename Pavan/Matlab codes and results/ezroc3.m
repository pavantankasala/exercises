%ROC plotting program, v3.00 (c) by Reza Derakhshani
%v3 Changelog: now provides d' (decidability), as the ratio of the means difference over sqrt of the average of the variances between geniune and imposter distributions
%v2.43 Changelog: plots thicker lines, overloaded third input plot_stat (0 turns off plotting, plot_stat=3 plots 3D ROC), and returns roc,EER,area,EERthr, ALLthr, with added ALLthr for all threshould points for all roc points
%In case of using square H (not using T) but needing to specify plot_stat, enter null ('') for T
%Changlelog for v2.42:lines 19-21 added for const. input causing error in loop limits in lines 27 or 45
%Accepts H, the inter-similarity matrix (i.e. the higher the diagonal, the better)
%H is for N subjects, 1 sample againse N-1, N times (rows). K such runs can be stacked on 3rd dimesion, i.e. H will be NxNxK
%Overloaded for 2-class (regular) ROC, in which case H does not have to be square,
% but a vector and accompanied by similarly-sized T, which is 1 for corresponding 'class' entries in H, and 0 otherwise
%Outputs roc=[x;y], EER, area under the curve, threshold for EER (EERthr) and all the thresholds, ALLthr (for points in roc), d (d' or decidability), gen, imp (genuine and imposter scores for ditribution analysis)
%Usage: [roc,EER,area,EERthr,ALLthr,d,gen,imp]=ezroc2(H); for multi-class, use H=cat(3,H1,H2,...) for multiple H's
%Or  [roc,EER,area,EERthr,ALLthr,d,gen,imp]=ezroc2(H,T); (single-class-vs-rest)
%Or  [roc,EER,area,EERthr,ALLthr,d,gen,imp]=ezroc2(H,T,plot_stat), where plot_stat of 0 turns off plotting, and plot_stat=3 plots 3D ROC (y=GAR x=FAR z=thr)
%Bug fix: Line 20 now reports 'True Reject' more accurately, esp. for smaller Hs
%Enhanced functionality: overloaded for one-class-agains-rest, multiple class multiple H averaging, turning off the plot or making it 3D
%Now a third and forth agument (has to be both) allows for turning off plot function to avoid hangs during repeated calls (could be any value)
%Future development (ezroc3.1): provide quality scores for each ROC neighborhood by looking at GAR-FAR vs Thr slope in 3D, possiblly color-code ROC accordingly
function [roc,EER,area,EERthr,ALLthr,d,gen,imp]=ezroc3(H,T,plot_stat)
t1=min(min(min(H)));
t2=max(max(max(H)));
num_subj=size(H,1);

stp=(t2-t1)/500;   %step size here is 0.2% of threshold span, can be adjusted

if stp==0   %if all inputs are the same...
    stp=0.01;   %Token value
end
ALLthr=(t1-stp):stp:(t2+stp);
if (nargin==1 || (nargin==3 &&  isempty(T)))  %Using only H, multi-class case, and maybe 3D or no plot
    GAR=zeros(503,size(H,3));  %initialize for accumulation in case of multiple H (on 3rd dim of H)
    FAR=zeros(503,size(H,3));
    gen=[]; %genuine scores place holder (diagonal of H), for claculation of d'
    imp=[]; %impostor scores place holder (non-diagonal elements of H), for claculation of d'
    for setnum=1:size(H,3); %multiple H measurements (across 3rd dim, where 2D H's stack up)
        gen=[gen; diag(H(:,:,setnum))]; %digonal scores
        imp=[imp; H(find(not(eye(size(H,2)))))]; %off-diagonal scores, with off-diagonal indices being listed by find(not(eye(size(H,2)))) 
        for t=(t1-stp):stp:(t2+stp),    %Note that same threshold is used for all H's, and we increase the limits by a smidgeon to get a full curve
            ind=round((t-t1)/stp+2);   %current loop index, +2 to start from 1
            id=H(:,:,setnum)>t;
            
            True_Accept=trace(id);  %TP
            False_Reject=num_subj-True_Accept;  %FN
            % In the following, id-diag(diag(id)) simply zeros out the diagonal of id
            True_Reject=sum( sum( (id-diag(diag(id)))==0 ) )-size(id,1); %TN, number of off-diag zeros. We need to subtract out the number of diagonals, as 'id-diag(diag(id))' introduces those many extra zeros into the sum
            False_Accept=sum( sum( id-diag(diag(id)) ) ); %FP, number of off-diagonal ones
            
            GAR(ind,setnum)=GAR(ind,setnum)+True_Accept/(True_Accept+False_Reject); %1-FRR, Denum: all the positives (correctly IDed+incorrectly IDed)
            FAR(ind,setnum)=FAR(ind,setnum)+False_Accept/(True_Reject+False_Accept); %1-GRR, Denum: all the negatives (correctly IDed+incorrectly IDed)
        end
    end
    GAR=sum(GAR,2)/size(H,3);   %average across multiple H's
    FAR=sum(FAR,2)/size(H,3);
elseif (nargin==2 || nargin==3),   %Regular, 1-class-vs-rest ROC, and maybe 3D or no plot
    gen=H(find(T)); %genuine scores
    imp=H(find(not(T))); %impostor scores
    for t=(t1-stp):stp:(t2+stp),    %span the limits by a smidgeon to get a full curve
        ind=round((t-t1)/stp+2);   %current loop index, +2 to start from 1
        id=H>t;
        
        True_Accept=sum(and(id,T)); %TP
        False_Reject=sum(and(not(id),T));   %FN
        
        True_Reject=sum(and(not(id),not(T)));   %TN
        False_Accept=sum(and(id,not(T)));   %FP
        
        GAR2(ind)=True_Accept/(True_Accept+False_Reject); %1-FRR, Denum: all the positives (correctly IDed+incorrectly IDed)
        FAR2(ind)=False_Accept/(True_Reject+False_Accept); %1-GRR, Denum: all the negatives (correctly IDed+incorrectly IDed)
        
    end
    GAR=GAR2';
    FAR=FAR2';
end
roc=[GAR';FAR'];
FRR=1-GAR;
[e ind]=min(abs(FRR'-FAR'));    %This is Approx w/ error e. Fix by linear inerpolation of neigborhood and intersecting w/ y=x
EER=(FRR(ind)+FAR(ind))/2;
area=abs(trapz(roc(2,:),roc(1,:)));
EERthr=t1+(ind-1)*stp;%EER threshold

d=abs(mean(gen)-mean(imp))/(0.5*sqrt(var(gen)+var(imp)));   %Decidability or d'

if (nargin==1 || nargin==2)
    figure, plot(roc(2,:),roc(1,:),'LineWidth',3),axis([-0.002 1 0 1.002]),title(['ROC Curve;   EER=' num2str(EER) ',   Area=' num2str(area) ',   Decidability=' num2str(d)]),xlabel('FAR'),ylabel('GAR');
end

if nargin==3
    if plot_stat == 3
        figure, plot3(roc(2,:),roc(1,:),ALLthr,'LineWidth',3),axis([0 1 0 1 (t1-stp) (t2+stp)]),title(['3D ROC Curve;   EER=' num2str(EER) ',   Area=' num2str(area)  ',   Decidability=' num2str(d)]),xlabel('FAR'),ylabel('GAR'),zlabel('Threshold'),grid on,axis square;
    else
        %else it must be 0, i.e. no plot
    end
end

end


%Note: this will generate the same average AUC in multiple H as pair wise comparison. E.G:
% H1=(rand(100)+.5*eye(100));
% H2=(rand(100)+.4*eye(100));
% H3=(rand(100)+.3*eye(100));
% [roc1,EER1,area1]=ezroc2(cat3(3,H1,H2,H3));   %DO THIS
%
% Which is the same as (AUC-wise, given eqiual probability of each class according to Hand and Till 2001 paper on multi class ROC):
% T=eye(100);
% for i=1:100,
%     [roc,EER,area(i)]=ezroc2([H1(i,:),H2(i,:),H3(i,:)],[T(i,:),T(i,:),T(i,:)]);
% close,
% end
% mean(area)    %EQUAL to area1, but higher computaional cost
%
% But not the same AUC as
% [roc2,EER2,area2]=ezroc2((H1+H2+H3)/3);   %DO NOT DO THIS

