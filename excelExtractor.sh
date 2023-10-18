#!/usr/bin/bash

DELIMETR=";"
LINE_DELIMETR=$'\n'
aggrBy=0
aggregated=1
spliterForValues=","
spliterForEntity=","
declare -A dataMap
while getopts 'hk:v:s:e:-:' OPTION; do
  if [ "$OPTION" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"       # extract long option name
   OPTARG="${OPTARG#OPTION}"   # extract long option argument (may be empty)
#    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPTION" in
    h | help)
      echo "-k | --keyColumn - to specify num of column that is key in map (group by this column)"
      echo "-v | --valueColumn - to specify num of column that is value in map (that will bee group in list of values for each key)"
      echo "-s | --spliter - to set spliter for values (default ',')"
      echo "-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',')"
      exit 1
      ;;
    k | keyColumn)
      ((aggrBy = OPTARG - 1))
      echo "use aggrBy = $aggrBy"  1>&2
      ;;
    v | valueColumn)
      ((aggregated = OPTARG - 1))
      echo "use aggregated = $aggregated"  1>&2
      ;;
    s | spliter)
      spliterForValues="${OPTARG}"
      echo "use spliterForValues = $spliterForValues"  1>&2
      ;;
    e | entitySpliter)
      spliterForEntity="${OPTARG}"
      echo "use spliterForEntity = $spliterForEntity"  1>&2
      ;;
    *)
      echo "script usage: $(basename \$0) [-h] [-v valueColumnNumber] [-k keyColumnNumber] [-s vluesSpliter] [-e entitySpliter] " >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
data=$(xlsx2csv -d "$DELIMETR" $1)
IFS=$LINE_DELIMETR
data=( $data )
for line in "${data[@]}"
do
  IFS=$DELIMETR
  lineData=( $line )
  lenOfRow=${#lineData[@]}
  if ! ((lenOfRow <= aggrBy || lenOfRow <= aggregated ));
  then
      aggrColumn=${lineData[$aggrBy]}
      aggregatedColumn=${lineData[$aggregated]}
      if [[ ! $aggrColumn == "" ]];
      then
        if [[ -v 'dataMap[$aggrColumn]' ]] ;
        then
          dataMap[$aggrColumn]="${dataMap[$aggrColumn]}${spliterForValues}'${aggregatedColumn}'"
        else
          dataMap[$aggrColumn]="'${aggregatedColumn}'"
        fi
      else
        echo "varible aggrColumn is empty -> skiped" 1>&2
      fi
  else
    echo "len of row is $lenOfRow and it is less then aggrBy=$aggrBy or aggregated=$aggregated" 1>&2
  fi

done
for key in "${!dataMap[@]}"
do
  if [[ -n "$result" ]]
  then
    result="$result${spliterForEntity}'${key}':[${dataMap[$key]}]"
  else
    result="{'${key}':[${dataMap[$key]}]"
  fi
done
echo "$result}"
#python3 -c"data='''$data''';index=0;data=list(map(lambda x: list(x.split(',')), data.split('\n')));import xlsxwriter;workbook = xlsxwriter.Workbook('$1');worksheet = workbook.add_worksheet();[(worksheet.write(f'{chr(65)}{index}', data[0]), worksheet.write(f'{chr(65+1)}{index}', data[1]), worksheet.write(f'{chr(65+2)}{index}', data[2]), worksheet.write(f'{chr(65+3)}{index}', data[3]), worksheet.write(f'{chr(65+4)}{index}', f'{data[2][0]}.{data[3][0]}.') , index++) for i in data];workbook.close()"