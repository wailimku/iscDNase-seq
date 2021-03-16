%==================================================
%This code is to show an example for mapping the iscDNase-seq single cell data
%You will need to set the path. For example, '/yourpath/iscDNase-seq/barcode_A_sc/';
%==================================================
% In matlab, run the following code to genreate the file,"script_mapping", in each folder.
%***********************************
% Start (for generating "script_mapping")
%***********************************
path0 = '/yourpath/iscDNase-seq/';
path = strcat(char(path0),'barcode_A_sc'); %% need to change
outputname = '_readname.txt.R1.bed.hg18'; %% need to change

common_primer1 = 'AGAACCATGTCGTCAGTGTCCCCCCCCC';
common_primer2 = 'AGAACCATGTCGTCAGTGTCCCCCCCC';
common_primer3 = 'AGAACCATGTCGTCAGTGTCCCCCCC';
common_primer4 = 'AGAACCATGTCGTCAGTGTCCCCCC';
common_primer5 = 'AGAACCATGTCGTCAGTGTCCCCC';
common_primer6 = 'AGAACCATGTCGTCAGTGTCCCC';
common_primer7 = 'AGAACCATGTCGTCAGTGTCCC';
common_primer8 = 'AGAACCATGTCGTCAGTGTCC';
common_primer9 = 'AGAACCATGTCGTCAGTGTC';
common_primer10 ='AGAACCATGTCGTCAGTGT';

      
listing = dir(strcat(char(path),'/GB*/GB*R2.fastq'));
msize = max(size(listing));

filename  = cell([msize, 1]);
for i = 1:msize
    filename(i) = cellstr(listing(i).name);
end;

foldername = filename;
for i = 1:msize
    c = strsplit(char(filename(i)),'_R2');
    foldername(i) = cellstr(c(1));
end;    

for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'w');
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer1),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer2),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer3),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer4),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer5),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer6),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer7),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer8),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer9),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'%s%s%s%s\n', 'sed -i -e ''s/',char(common_primer10),'/\t/g'' ',strcat(char(path),char(foldername(i)),'/',char(filename(i))));
    fprintf(fp,'\n');
    fclose(fp);
end;    

%+========================================================================
%+========================================================================
command2 = '|awk ''{{if(NR%4==1) {key1=$1;getline;} if(NR%4==2) {if(NF==2){key0=$2; key2=$1;} k=NF;getline;};if (NR%4==3) {key3=$1;};getline} if(k==2) print key1"\t"key2"\t"key0}''>';
for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');

    infile = strcat(char(path),char(foldername(i)),'/',filename(i));
    outfile = strcat(char(path),char(foldername(i)),'/barcode_readname.txt');
    fprintf(fp,'%s\t%s%s%s\n','less',char(infile),char(command2),char(outfile));
    fprintf(fp,'\n');
    fclose(fp);
end;    
 
%+========================================================================
%+========================================================================
barcode_com = cell([61,1]);

a = readtable(strcat(char(path0),'/pre_data/barcode_61.txt'),'ReadVariableNames',0);
barcode = table2array(a);

barcode_com2 = barcode_com;
for i = 1:61
    barcode_com(i) = cellstr('barcode_readname.txt');
    barcode_com2(i) = cellstr(strcat(barcode(i),'_','barcode_readname.txt'));
end;    


for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    for j = 1:61
        filein = strcat(char(path),char(foldername(i)),'/',char(barcode_com(j)));
        fileout = strcat(char(path),char(foldername(i)),'/',char(barcode_com2(j)));
        fprintf(fp,'%s %s %s%s%s\n','grep',char(barcode(j)),char(filein),'>',char(fileout));
    end;
    fprintf(fp,'\n');
    fclose(fp);
end;    

commands1 = '|awk ''{if(substr($2,1,8)==';
commands2 = ') print}''';
for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    for j = 1:61
        filein = strcat(char(path),char(foldername(i)),'/',char(barcode_com2(j)));
        fileout = strcat(char(path),char(foldername(i)),'/',char(barcode_com2(j)),'.v2.txt');
        fprintf(fp,'%s %s %s%s%s%s%s%s%s\n','less',char(filein),char(commands1),'"',char(barcode(j)),'"',char(commands2),'>',char(fileout));
    end;
    fprintf(fp,'\n');
    fclose(fp);
end;    
    

for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    for j = 1:61
        filein = strcat(char(path),char(foldername(i)),'/',char(barcode_com2(j)),'.v2.txt');
        fprintf(fp,'%s %s\n','sed -i -e ''s/@//g''',char(filein));
    end;
    fprintf(fp,'\n');
    fclose(fp);
end;    


command3 = '|awk ''{print $1}''>';
for i = 1:msize
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    for j = 1:61
        filein = strcat(char(path),char(foldername(i)),'/',char(barcode_com2(j)),'.v2.txt');
        fileout = strcat(char(path),char(foldername(i)),'/',char(barcode(j)),'_readname.txt');
        
        fprintf(fp,'%s %s%s%s\n','less',char(filein),char(command3),char(fileout));
    end;
    fprintf(fp,'\n');
    fclose(fp);
end;    


command4 = 'bedtools bamtobed -i';
command4b = '|awk ''{if($5>=10) print}''';
for i = 1:msize
    a = dir(strcat(char(path),char(foldername(i)),'/','*hg18.bam'));
    bedin = strcat(char(path),char(foldername(i)),'/',cellstr(a.name));
    bedout = strcat(char(path),char(foldername(i)),'/','test_result_hg18.bed');
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    fprintf(fp,'%s %s%s%s%s\n',char(command4),char(bedin),char(command4b),'>',char(bedout));
    fprintf(fp,'\n');
    fclose(fp);
end;


command5 = 'grep -Fwf';
for i = 1:msize
    bedin = strcat(char(path),char(foldername(i)),'/','test_result_hg18.bed');
    fp = fopen(strcat(char(path),char(foldername(i)),'/','script_mapping'),'a');
    for j = 1:61
        filein = strcat(char(path),char(foldername(i)),'/',char(barcode(j)),'_readname.txt');
        fileout = strcat(char(path),char(foldername(i)),'/',char(barcode(j)),char(outputname)); 
        fprintf(fp,'%s %s %s%s%s\n', char(command5),char(filein),char(bedin),'>',char(fileout));
    end;
    fprintf(fp,'\n');
    fclose(fp);
end;

%***********************************
% End;
%***********************************

%=========================================
%run "sh script_mapping" in each folder
%==================================================

