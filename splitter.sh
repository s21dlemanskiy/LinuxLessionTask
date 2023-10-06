DELIMETR=";"
LINE_DELIMETR=$'\n'
data=$(xlsx2csv -d "$DELIMETR" $1)
declare -A dataMap
# aggregate by 1-st column
IFS=$LINE_DELIMETR
data=( $data )
for line in "${data[@]}"
do
  column1Data="${line%%"${DELIMETR}"*}"
  otherData="${line#*"${DELIMETR}"}"
  if [[ -v 'dataMap[$column1Data]' ]] ;
  then
    dataMap[$column1Data]="${dataMap[$column1Data]},'${otherData}'"
  else
    dataMap[$column1Data]="'${otherData}'"
  fi
done
for key in "${!dataMap[@]}"
do
  if [[ -n "$result" ]]
  then
    result="$result,${key}:[${dataMap[$key]}]"
  else
    result="{${key}:[${dataMap[$key]}]"
  fi
done
echo "$result}"
#python3 -c"data='''$data''';index=0;data=list(map(lambda x: list(x.split(',')), data.split('\n')));import xlsxwriter;workbook = xlsxwriter.Workbook('$1');worksheet = workbook.add_worksheet();[(worksheet.write(f'{chr(65)}{index}', data[0]), worksheet.write(f'{chr(65+1)}{index}', data[1]), worksheet.write(f'{chr(65+2)}{index}', data[2]), worksheet.write(f'{chr(65+3)}{index}', data[3]), worksheet.write(f'{chr(65+4)}{index}', f'{data[2][0]}.{data[3][0]}.') , index++) for i in data];workbook.close()"