A. Download files
--------------------------------------

1. Download the files from github and change the directory to iscDNase

<pre>
[wlku@matrix] git clone https://github.com/wailimku/iscDNase-seq.git
[wlku@matrix] cd iscDNase-seq
[wlku@matrix iscDNase-seq] pwd
[kuw@cn4257 scDNase-seq$
/yourpath/iscDNase-seq
[wlku@matrix iscDNase-seq] sh script_download_fastq
[wlku@matrix iscDNase-seq] sh script_rename_fastq
[wlku@matrix iscDNase-seq] sh script_mkdir
[wlku@matrix iscDNase-seq] sh script_mv_fastq
[wlku@matrix iscDNase-seq] sh script_cp_fastq
</pre>

B. Demultiplexing and mapping 
--------------------------------------

1. Using matlab to generate Unix script. Note that here require the build of reference genome. Assume that it is located at yourpath/Basic_data/Bowtie2Index/hg18/.

<pre>
[wlku@matrix iscDNase-seq] cd barcode_B_sc
[wlku@matrix barcode_B_sc] sh script_map
[wlku@matrix barcode_B_sc] matlab -nodesktop
>>run ./src/iscDNase_mapping_demul_96_barcodes.m
>>exit
[wlku@matrix barcode_B_sc] ls ./GB*/script_mapping|awk '{print "sh "$1}'>sh_script_mapping
[wlku@matrix barcode_B_sc] sh sh_script_mapping
</pre>

2. Remove duplicated reads and identify single cells
<pre>
[wlku@matrix barcode_B_sc] ls ./GB*/*.hg18 |awk '{print "sort -u -k1,1 -k2,2 -k3,3 "$1" > "$1".uniq &" }'>script_sort_uniq
[wlku@matrix barcode_B_sc] sh script_sort_uniq
[wlku@matrix barcode_B_sc] wc -l ./GB*/*hg18.uniq|awk ''{print $1"\t"$2}''>wc_uniq2.txt'
[wlku@matrix barcode_B_sc] sed -e '$ d'  wc_uniq2.txt > wc_uniq.txt'
[wlku@matrix barcode_B_sc] rm wc_uniq.txt;
[wlku@matrix barcode_B_sc] matlab -nodesktop
>> run ./src/iscDNase_get_sc.m
>> exit
[wlku@matrix barcode_B_sc] mkdir selbed
[wlku@matrix barcode_B_sc] paste selfile_hg18.txt selfile_hg18_2.txt|awk '{print "cp "$1" ./selbed/"$2" &"}'>script_cp_files
[wlku@matrix barcode_B_sc] sh script_cp_files
</pre>

</pre>
