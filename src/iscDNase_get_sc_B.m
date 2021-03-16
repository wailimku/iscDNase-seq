
path0 = '/yourpath/iscDNase-seq/';
path = strcat(char(path0),'barcode_B_sc'); %% need to change
nw = 480; %number of well, need to change;
kcheck = zeros(96,nw);
a = readtable(strcat(char(path),'wc_uniq_B.txt'),'ReadVariableNames',0);
b = table2array(a(:,2));
d = table2array(a(:,1));
wc_size = reshape(table2array(a(:,1)),[96,nw]);
check = zeros(max(size(d)),1);
for i =1:nw
    [ia,ib] = sort(wc_size(:,i),'descend');
    ic = ib(1:25); 
    id = ia(1:25); 
    q = find(id<1000|id>100000);
    ic(q)=[];
    if(min(size(ic))>0)
        m = (i-1)*96+ic;
        check(m) = 1;
        kcheck(m,i) = 1;
    end;
end;
q = find(check==1);

sel_file = b(q);
sel_file = b(q);
sel_file2 = cell([max(size(q)),1]);
for i = 1:max(size(q))
    a1 = strsplit(char(sel_file(i)),'./');
    a2 = strsplit(char(a1(2)),'/');
    sel_file2(i)=cellstr(strcat(a2(1),'_',a2(2)));    
end;

fp = fopen(strcat(char(path0),'script_cp_selfile_B'),'w');
for i= 1:max(size(q))
    fprintf(fp,'%s\t%s\t%s\n','cp',char(sel_file(i)),strcat('./selbed/',char(sel_file2(i))));
end;
fclose(fp);