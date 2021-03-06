#!/bin/bash
#Execute the Maude prover from a LLTP file
#Example: ls *.p | ./exec-ILLTP-file.sh

#Where to find the prover's Maude Files
MAUDE_FILES_DIR="../maude-prover"

#SED (MAC OS)
sedcmd="gsed" #Linux: sedcmd="sed"

#Limit for contraction/copy rule
copy_limit="5"

#TIMEOUT
TIMEOUT=10

#Finding Maude
maude_exec=`which maude`
if [[  -z  $maude_exec  ]] ;  then
  echo "Maude not found"
  exit 1
fi
#Finding the prover
maude_file="$MAUDE_FILES_DIR/ILL-Prover-flat.maude"
if [ ! -f $maude_file ]; then
    echo "File $maude_file not found."
    echo "The variable MAUDE_FILES_DIR must point to the directory containing the Maude files of the prover"
    exit 1
fi


#Maude options
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options $maude_file "


#Output file
output_file="output.txt"
if [[ !  -z  $1  ]] ;  then
  output_file=$1
fi

cat /dev/null > $output_file

counter=0
set -f

while read seq_file  ; 
do
  IFS=$'\n'
  counter=$((counter+1))
  echo "("$counter") Processing file ... "$seq_file ;
  lines=`grep "fof" $seq_file`
  premisses=()
  goal=""
  for l in $lines
  do
    lseq=`echo $l |  sed -e 's/fof(.*,//' -e 's/)[\s]*\.//' | $sedcmd -r "s/[a-zA-Z]+/\'&/g" | $sedcmd -e "s/-'o/-o/g" -e "s/+/o/g" -e "s/'bot/bot/g" -e "s/'top/top/g"`
    if [[ "$l" == *"axiom"* ]]; then
      premisses+=($lseq)
    else
      goal=$lseq
    fi
  done
  if [ -z "$premisses" ]; then
    prem="empMS"
  else
    prem=$(printf ",%s" "${premisses[@]}")
    prem=${prem:1}
  fi
  unset IFS
  seq="([emp] $prem |~ $goal )"
  echo $seq
  resultrow=`echo "red solve($copy_limit, $seq) ." | timeout $TIMEOUT $maude_command`
  title=$seq_file
  if [[ $resultrow != *"Bool"*  ]] ;  then
    result="timeout!"
    str_time="timeout!"
  else
    result=`echo "$resultrow" | grep "Bool" | sed -e s/\"//g -e s/result\ Bool\://g -e s/"Maude> Bye."//g`
    str_time=`echo "$resultrow" | grep -o '[0-9]*ms real' | grep -o '[0-9]*'`
  fi
  echo -e "$title ; $str_time ; $result" >> $output_file
done
echo "DONE!"
echo "----------------------------------"
echo "Output: "$output_file
echo "Limit on copy rule: "$copy_limit
echo "----------------------------------"
