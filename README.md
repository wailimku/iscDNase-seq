A. Download files
--------------------------------------

1. Download the files from github and change the directory to iscDNase

<pre>
[wlku@matrix] git clone https://github.com/wailimku/iscDNase-seq.git
[wlku@matrix] cd iscDNase-seq
[wlku@matrix iscDNase-seq] pwd
/yourpath/iscDNase-seq
[wlku@matrix iscDNase-seq] sh script_download_fastq
[wlku@matrix iscDNase-seq] sh script_rename_fastq
[wlku@matrix iscDNase-seq] sh script_mkdir
[wlku@matrix iscDNase-seq] sh script_mv_fastq
</pre>

B. Demultiplexing and mapping 
--------------------------------------

1. Using matlab to generate Unix script. Note that here require the build of reference genome. Assume that it is located at yourpath/Basic_data/Bowtie2Index/hg18/.

<pre>
[wlku@matrix iscDNase-seq] sh script_map
[wlku@matrix iscDNase-seq] matlab -nodesktop
>>run ./src/iscDNase_mapping_demul_96_barcodes.m
>>run ./src/iscDNase_mapping_demul_61_barcodes.m
>>exit
[wlku@matrix iscDNase-seq] ls ./barcode_*_sc/GB*/script_mapping|awk '{print "sh "$1}'>sh_script_mapping
[wlku@matrix iscDNase-seq] sh sh_script_mapping
</pre>

2. Remove duplicated reads and identify single cells
<pre>
[wlku@matrix iscDNase-seq] ls ./barcode_*_sc/GB*/*.hg18 |awk '{print "sort -u -k1,1 -k2,2 -k3,3 "$1" > "$1".uniq &" }'>script_sort_uniq
[wlku@matrix iscDNase-seq] sh script_sort_uniq
[wlku@matrix iscDNase-seq] wc -l ./barcode_B_sc/*hg18.uniq|awk ''{print $1"\t"$2}''>wc_uniq_B2.txt'
[wlku@matrix iscDNase-seq] sed -e '$ d'  wc_uniq_B2.txt > wc_uniq_B.txt'
[wlku@matrix iscDNase-seq] rm wc_uniq_B2.txt;
[wlku@matrix iscDNase-seq] wc -l ./barcode_A_sc/*hg18.uniq|awk ''{print $1"\t"$2}''>wc_uniq_A2.txt'
[wlku@matrix iscDNase-seq] sed -e '$ d'  wc_uniq_A2.txt > wc_uniq_A.txt'
[wlku@matrix iscDNase-seq] rm wc_uniq_A2.txt;
[wlku@matrix iscDNase-seq] matlab -nodesktop
>> run ./src/iscDNase_get_sc_B.m
>> run ./src/iscDNase_get_sc_A.m
>> exit
[wlku@matrix barcode_B_sc] mkdir selbed
[wlku@matrix barcode_B_sc] sh script_cp_file_B
[wlku@matrix barcode_B_sc] sh script_cp_file_A
</pre>


C. Cell clustering
--------------------------------------
Update on (17-March-2021) 3pm EST

</pre>
