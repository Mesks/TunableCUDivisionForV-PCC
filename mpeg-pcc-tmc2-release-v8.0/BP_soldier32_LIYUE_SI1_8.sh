#!/bin/bash

MAINDIR=$( dirname $( cd "$( dirname $0 )" && pwd ) )/mpeg-pcc-tmc2-release-v8.0;
EXTERNAL=$( dirname $MAINDIR )/external_pkg;
if [ ! -d $EXTERNAL ] ; then EXTERNAL=$( dirname $MAINDIR )/external; fi

## Input parameters
SRCDIR=${MAINDIR}"/../ply/"; # note: this directory must containt: http://mpegfs.int-evry.fr/MPEG/PCC/DataSets/pointCloud/CfP/datasets/Dynamic_Objects/People
CFGDIR=${MAINDIR}"/cfg/";

THREAD=1;
SEQ=25;       # in [22;28]
COND="C2RA";       # in [C2AI, C2LD, CWAI, CWRA]
FRAMECOUNT=32;
MANNER="SI1_8";

## Set external tool paths
ENCODER=${MAINDIR}"/bin/Release/PccAppEncoder.exe";
DECODER=${MAINDIR}"/bin/Release/PccAppDecoder.exe";
NDATAPATH="set_value";
SEQDIR="set_value";
OUTPUT="set_value";
HDRCONVERT=${EXTERNAL}"/HDRTools-v0.18/bin/HDRConvert.exe";
HMENCODER=${EXTERNAL}"/HM-Reference-bin/TAppEncoder_"${COND}"_"${MANNER}".exe";
HMDECODER=${EXTERNAL}"/HM-Reference-bin/TAppDecoder.exe";

if [ ! -f $ENCODER    ] ; then ENCODER=${MAINDIR}/bin/PccAppEncoder;               fi
if [ ! -f $ENCODER    ] ; then ENCODER=${MAINDIR}/bin/Release/PccAppEncoder.exe;   fi
if [ ! -f $ENCODER    ] ; then ENCODER=${MAINDIR}/bin/Debug/PccAppEncoder.exe;     fi
                                                                                   
if [ ! -f $DECODER    ] ; then DECODER=${MAINDIR}/bin/PccAppDecoder;               fi
if [ ! -f $DECODER    ] ; then DECODER=${MAINDIR}/bin/Release/PccAppDecoder.exe;   fi
if [ ! -f $DECODER    ] ; then DECODER=${MAINDIR}/bin/Debug/PccAppDecoder.exe;     fi

if [ ! -f $HDRCONVERT ] ; then HDRCONVERT=${EXTERNAL}/HDRTools/bin/HDRConvert;     fi
if [ ! -f $HDRCONVERT ] ; then HDRCONVERT=${EXTERNAL}/HDRTools/bin/HDRConvert.exe; fi

if [ ! -f $HMENCODER ] ; then HMENCODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/TAppEncoderStatic;                  fi
if [ ! -f $HMENCODER ] ; then HMENCODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/vc2015/x64/Release/TAppEncoder.exe; fi
if [ ! -f $HMENCODER ] ; then HMENCODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/vc2015/x64/Debug/TAppEncoder.exe;   fi
                                                   
if [ ! -f $HMDECODER ] ; then HMDECODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/TAppDecoderStatic;                  fi
if [ ! -f $HMDECODER ] ; then HMDECODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/vc2015/x64/Release/TAppDecoder.exe; fi
if [ ! -f $HMDECODER ] ; then HMDECODER=${EXTERNAL}/HM-16.18+SCM-8.7/bin/vc2015/x64/Debug/TAppDecoder.exe;   fi

## Parameters and pathes check
if [ ! -f $ENCODER    ] ; then echo "Can't find PccAppEncoder, please set.     ($ENCODER )";   exit -1; fi
if [ ! -f $DECODER    ] ; then echo "Can't find PccAppDecoder, please set.     ($DECODER )";   exit -1; fi
if [ ! -f $HDRCONVERT ] ; then echo "Can't find HdrConvert, please set.        ($HDRCONVERT)"; exit -1; fi
if [ ! -f $HMENCODER  ] ; then echo "Can't find TAppEncoderStatic, please set. ($HMENCODER)";  exit -1; fi
if [ ! -f $HMDECODER  ] ; then echo "Can't find TAppDecoderStatic, please set. ($HMDECODER)";  exit -1; fi

## Set Configuration based on sequence, condition and rate
if [ $COND == "C2AI" -o $COND == "C2RA" ] 
then
  case $SEQ in
      22) CFGSEQUENCE="sequence/queen.cfg";;
      23) CFGSEQUENCE="sequence/loot_vox10.cfg";;
      24) CFGSEQUENCE="sequence/redandblack_vox10.cfg";;
      25) CFGSEQUENCE="sequence/soldier_vox10.cfg";;
      26) CFGSEQUENCE="sequence/longdress_vox10.cfg";;
      27) CFGSEQUENCE="sequence/basketball_player_vox11.cfg";;
      28) CFGSEQUENCE="sequence/dancer_vox11.cfg";;
      *) echo "sequence not correct ($SEQ)";   exit -1;;
  esac
else
   case $SEQ in
      22) CFGSEQUENCE="sequence/queen-lossless.cfg";;
      23) CFGSEQUENCE="sequence/loot_vox10-lossless.cfg";;
      24) CFGSEQUENCE="sequence/redandblack_vox10-lossless.cfg";;
      25) CFGSEQUENCE="sequence/soldier_vox10-lossless.cfg";;
      26) CFGSEQUENCE="sequence/longdress_vox10-lossless.cfg";;
      27) CFGSEQUENCE="sequence/basketball_player_vox11.cfg";;
      28) CFGSEQUENCE="sequence/dancer_vox11.cfg";;
      *) echo "sequence not correct ($SEQ)";   exit -1;;
  esac 
  CFGRATE="rate/ctc-r5.cfg"
  BIN=${OUTPUT}S${SEQ}${COND}_F${FRAMECOUNT}.bin
fi

case $COND in
  CWAI) CFGCOMMON="common/ctc-common-lossless-geometry-texture.cfg";;
  CWLD) CFGCOMMON="common/ctc-common-lossless-geometry-texture.cfg";; 
  C2AI) CFGCOMMON="common/ctc-common.cfg";;                           
  C2RA) CFGCOMMON="common/ctc-common.cfg";;           
  *) echo "Condition not correct ($COND)";   exit -1;;
esac

case $COND in
  CWAI) CFGCONDITION="condition/ctc-all-intra-lossless-geometry-texture.cfg";;
  CWLD) CFGCONDITION="condition/ctc-low-delay-lossless-geometry-texture.cfg";;
  C2AI) CFGCONDITION="condition/ctc-all-intra.cfg";;
  C2RA) CFGCONDITION="condition/ctc-random-access.cfg";;  
  *) echo "Condition not correct ($COND)";   exit -1;;
esac

   case $SEQ in
      22) NDATAPATH="queen/queen_n/frame_%04d_n.ply";SEQDIR="queen";;
      23) NDATAPATH="loot/loot_n/loot_vox10_%04d_n.ply";SEQDIR="loot";;
      24) NDATAPATH="redandblack/redandblack_n/redandblack_vox10_%04d_n.ply";SEQDIR="redandblack";;
      25) NDATAPATH="soldier/soldier_n/soldier_vox10_%04d_n.ply";SEQDIR="soldier";;
      26) NDATAPATH="longdress/longdress_n/longdress_vox10_%04d_n.ply";SEQDIR="longdress";;
      27) NDATAPATH="basketball_player/basketball_player_vox11_%08d.ply";SEQDIR="basketball_player";;
      28) NDATAPATH="dancer/dancer_vox11_%08d.ply";SEQDIR="dancer";;
      *) echo "sequence not correct ($SEQ)";   exit -1;;
  esac 

  MetricResolution=1023;
  if [ $SEQ == 27 -o $SEQ == 28 ];
    then MetricResolution=2047;
  fi

## Encoder 
for RATE in {1..5}
do
  case $RATE in
      5) CFGRATE="rate/ctc-r5.cfg";OUTPUT="../output/"${MANNER}"/"${SEQDIR}"/r5/";;
      4) CFGRATE="rate/ctc-r4.cfg";OUTPUT="../output/"${MANNER}"/"${SEQDIR}"/r4/";;
      3) CFGRATE="rate/ctc-r3.cfg";OUTPUT="../output/"${MANNER}"/"${SEQDIR}"/r3/";;
      2) CFGRATE="rate/ctc-r2.cfg";OUTPUT="../output/"${MANNER}"/"${SEQDIR}"/r2/";;
      1) CFGRATE="rate/ctc-r1.cfg";OUTPUT="../output/"${MANNER}"/"${SEQDIR}"/r1/";;
      *) echo "rate not correct ($RATE)";   exit -1;;
  esac
  BIN=${OUTPUT}S${SEQ}${COND}R0${RATE}_F${FRAMECOUNT}.bin
  
  $ENCODER \
    --config=${CFGDIR}${CFGCOMMON} \
    --config=${CFGDIR}${CFGSEQUENCE} \
    --config=${CFGDIR}${CFGCONDITION} \
    --config=${CFGDIR}${CFGRATE} \
    --configurationFolder=${CFGDIR} \
    --uncompressedDataFolder=${SRCDIR} \
    --frameCount=$FRAMECOUNT \
    --colorSpaceConversionPath=$HDRCONVERT \
    --videoEncoderPath=$HMENCODER \
    --videoEncoderAuxPath==$HMENCODER \
    --videoEncoderOccupancyMapPath=$HMENCODER \
    --reconstructedDataPath=${BIN%.???}_rec_%04d.ply \
    --compressedStreamPath=$BIN \
    --nbThread=$THREAD \
    --resolution=$MetricResolution \
    --keepIntermediateFiles=1 \
    --normalDataPath=${SRCDIR}${NDATAPATH} | tee -a ../statisticData/${MANNER}_${SEQDIR}.txt

done