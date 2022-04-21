# Hierarchical Clustering based Tunable Coding Unit Division for Video-based Point Cloud Coding
This is the official repository of source codes and deployment methods for the paper "Hierarchical Clustering based Tunable Coding Unit Division for Video-based Point Cloud Coding".

The program versions used in the experiment are as follows (You can get their official versions through the link after quotation marks): 

1. TMC2-v8.0: https://github.com/MPEGGroup/mpeg-pcc-tmc2/tree/release-v8.0
2. HM-16.20+SCM-8.8-AI-RA: https://vcgit.hhi.fraunhofer.de/jvet/HM/-/tree/HM-16.20+SCM-8.8
3. HDRTools-v0.18: https://gitlab.com/standards/HDRTools/-/tree/0.18-dev

In order to reduce the size of GitHub uploaded files, only some key files are uploaded. If necessary, please download the official version in the above link and replace it with the files provided by this repository. A brief introduction to the files provided is listed below:

## mpeg-pcc-tmc2-release-v8.0
This folder contains tmc2-v8 0 program, please pay attention to the following points: 
1. Under this folder, we provide an example of the script used for reference: BP_soldier32_LIYUE_SI1_2.sh. Please modify the path in the shell file according to the actual deployment of your computer. If there is no modification after downloading this repository, run this shell after correctly deploying the input file to start the operation of the <b>sequence soldier</b> in Table 11 in the paper. The reconstruction results are saved in the output folder and the console output is saved in the statisticdata folder.
2. "mpeg-pcc-tmc2-release-v8.0/cfg/sequencehas" been modified according to the above shell，please ensure that the point cloud files of 8i-vox10 or owlii-vox11 officially provided by MPEG are extracted into ply folder according to the default path, if you want to use our shell.

## external
1. HDRTools-v0.18, executable file HDRConvert.exe has been generated under “external/HDRTools-v0.18/bin”.
2. HM-HM-16.20+SCM-8.8, this folder contains HM that has been modified by the method described in the paper. You can use "external/HM-HM-16.20+SCM-8.8/source/Lib/TLibEncoder/TEncCu.cpp" to see our changes.
3. HM-Reference-bin, this folder contains 11 executable files, TAppDecoder.exe is stored to ensure the normal execution of shell, this executable is a decoding program generated by HM without source change, TAppEncoder_C2AI_xxx.exe are executable file packaged and generated by the method described in the paper under AI configuration, in which TAppEncoder_C2AI_Anchor.exe is a coding program generated by HM without source change, TAppEncoder_C2RA_xxx.exe is an executable file packaged and generated by the method described in the paper under RA configuration, in which TAppEncoder_C2RA_Anchor.exe is the same as TAppEncoder_C2AI_Anchor.exe is exactly the same program. The reason why it is divided into two is to facilitate the call of the shell mentioned earlier.

## other file folders
ply stores the input file of the point cloud, output stores the output file of the point cloud, and statisticdata stores the console output of the point cloud. 
<br/>These three files ensure that the script provided by us can run normally on your computer. If you don't want to use the script provided by us, you can set it according to your own preferences.