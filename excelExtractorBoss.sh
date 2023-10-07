

function myFormat(){
    data=$1
    data="${data##" "}"
    data="${data%%" "}"
    data="${data#*"'"}"
    data="${data%"'"*}"
    data="${data#*"\""}"
    data="${data%"\""*}"
    echo "$data"
}



DELIMETR=";"
LINE_DELIMETR=$'\n'
departmentColNum=0
chatIdColNum=1
userNameColNum=2
passwordColNum=3
spliterForValues=","
spliterForEntity=","
declare -A dataMap
while getopts 'hd:c:p:u:s:e:-:' OPTION; do
  if [ "$OPTION" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"       # extract long option name
   OPTARG="${OPTARG#OPTION}"   # extract long option argument (may be empty)
#    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPTION" in
    h | help)
      echo "-d | --departmentCol - to specify num of column that is key in map (group by this column)"
      echo "-c | --chatIdCol - to specify num of column that is value in map (that will bee group in list of values for each key)"
      echo "-u | --userNameCol - to specify num of column that is value in map (that will bee group in list of values for each key)"
      echo "-p | --passwordCol - to specify num of column that is value in map (that will bee group in list of values for each key)"
      echo "-s | --spliter - to set spliter for values (default ',')"
      echo "-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',')"
      exit 1
      ;;
    d | departmentCol)
      ((departmentColNum = OPTARG - 1))
    echo "use departmentColNum= $departmentColNum"  1>&2
      ;;
    c | chatIdCol)
      ((chatIdColNum = OPTARG - 1))
    echo "use chatIdColNum= $chatIdColNum"  1>&2
      ;;
    u | userNameCol)
      ((userNameColNum = OPTARG - 1))
    echo "use userNameColNum = $userNameColNum"  1>&2
      ;;
    p | passwordCol)
      ((passwordColNum = OPTARG - 1))
    echo "use passwordColNum= $passwordColNum"  1>&2
      ;;
    s | spliter)
      spliterForValues="${OPTARG}"
      ;;
    e | entitySpliter)
      spliterForEntity="${OPTARG}"
      ;;
    *)
      echo "script usage: $(basename \$0) [-h] [-d departmentColNumber] [-c chatIdColNumber] [-u userNameColNumber] [-p passwordColNumber]  [-s vluesSpliter] [-e entitySpliter]" >&2
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
  if ! ((lenOfRow <= departmentColNum || lenOfRow <= chatIdColNum || lenOfRow <= userNameColNum || lenOfRow <= passwordColNum ));
  then
      departmentColumn=${lineData[$departmentColNum]}
      chatIdColumn=$(myFormat "${lineData[$chatIdColNum]}")
      userNameColumn=$(myFormat "${lineData[$userNameColNum]}")
      passwordColumn=$(myFormat "${lineData[$passwordColNum]}")
      if [[ ! $departmentColumn == "" ]];
      then
        bossData="{'chat_id':${chatIdColumn}, 'user_name':'$userNameColumn', 'password':'$passwordColumn'}"
        if [[ ! -v 'dataMap[$departmentColumn]' ]] ;
        then
          dataMap[$departmentColumn]="$bossData"
        else
          echo "varible department $departmentColumn has 2 or more entery ${dataMap[$aggrColumn]} and $bossData" 1>&2
        fi
      else
        echo "varible departmentColumn is empty -> skiped       line:$line" 1>&2
      fi
  else
    echo "len of row is $lenOfRow and it is less then departmentColNum=$departmentColNum or chatIdColNum=$chatIdColNum or userNameColNum=$userNameColNum or passwordColNum=$passwordColNum -> line:$line" 1>&2
  fi

done
for key in "${!dataMap[@]}"
do
  if [[ -n "$result" ]]
  then
    result="$result${spliterForEntity}'${key}':${dataMap[$key]}"
  else
    result="{'${key}':${dataMap[$key]}"
  fi
done
echo "$result}"
#python3 -c"data='''$data''';index=0;data=list(map(lambda x: list(x.split(',')), data.split('\n')));import xlsxwriter;workbook = xlsxwriter.Workbook('$1');worksheet = workbook.add_worksheet();[(worksheet.write(f'{chr(65)}{index}', data[0]), worksheet.write(f'{chr(65+1)}{index}', data[1]), worksheet.write(f'{chr(65+2)}{index}', data[2]), worksheet.write(f'{chr(65+3)}{index}', data[3]), worksheet.write(f'{chr(65+4)}{index}', f'{data[2][0]}.{data[3][0]}.') , index++) for i in data];workbook.close()"