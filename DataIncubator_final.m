%read data, remove nan, replace zero with a samll number
[num,txt,row]=xlsread('projobs.xlsx');
sta=txt(2:end,1);
con=txt(2:end,2);

r = find(isnan(num(:,1)));
num(any(isnan(num),2),:)=[];
num(num==0) = 0.0001;
sta(r(1):r(end))=[];
%sort data
[st, SortIndex] = sort(sta);
cont=con(SortIndex);
ob=num(SortIndex,1);
rec=num(SortIndex,2);
pov=num(SortIndex,3);

recpov=1./((rec.*pov)./(max(rec.*pov)));
%calculate ratios and normalize them
obpov=(ob./pov)./max(ob./pov);
obrec=(ob./rec)./max(ob./rec);

%fit obesity with normal dist, find tale and values there
norm=fitdist(ob,'Normal')
yob = pdf(norm,ob);
pp=norm.mu+1.5*norm.sigma;% find tale
IDX = uint32(1:size(ob,1));
ind = IDX(ob(:,:) >= pp & ob(:,:) < max(ob));%find indexis in tale
obpovc=obpov(ind);
obrecc=obrec(ind);
stc=st(ind);
contc=cont(ind);
IDX2 = uint32(1:size(contc,1));
ind2 = IDX2(((obpovc.*obrecc)./max(obpovc.*obrecc))>0.8);
selcontc=contc(ind2);
selstc=stc(ind2);

[recpov_so, SortIndex2] = sort(recpov(ind));
stc_so=stc(SortIndex2);
contc_so=contc(SortIndex2);

%plot obesity with normal dist
figure(1)
plot(ob,yob,'*','LineWidth',2)
xlabel('Obesity Rate')
ylabel('PDF')

figure(2) %inset of fig3
plot(1:length(recpov_so),(1./recpov_so)./max(1./recpov_so),'k+')

figure(3)
plot(1:length(recpov_so),(1./recpov_so)./max(1./recpov_so),'k+')
set(gca,'XTick',1:10,'XTickLabel',cellstr(contc_so))
xlabel('County')
ylabel('1/(Poverty Rate)(Facility Rate)')