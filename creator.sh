#!/usr/bin/bash


declare -A departmentsPeopleMap

VERBOSE=false
REGENERATE_CERTIFICATE=false
LASTNAME_INDEX=1
use_only_femail=true

CERTIFICATE_DIRECTORY="./certificates"
USED_CERTIFICATE_DIRECTORY="./used_certificates"


function get_certificate() {
  if [ -n "$1" ];
  then
    department=$1
    #there can be department
  fi
  if [ -n "$2" ];
  then
    name=$2
    #there can be name
  fi
  if [ -n "$3" ];
  then
    path_to_result_file=$3
    #there can be path to file, where will be certificate
  fi
  random_file=$(ls $CERTIFICATE_DIRECTORY | shuf -n 1)
  random_file_path="$CERTIFICATE_DIRECTORY/$random_file"
  if [ -n "$random_file" ] && [ -e "$random_file_path" ]; then
    echo "certificate:$random_file" >&2
    cp "$random_file_path" "$path_to_result_file"
    cp "$random_file_path" "$USED_CERTIFICATE_DIRECTORY/$(basename $random_file_path)"
    rm "$random_file_path"
  else
    echo "CERTIFICATE_DIRECTORY ($CERTIFICATE_DIRECTORY) is empty $name from $departments wouldnt have certificate" >&2
  fi
}


function printMap() {
  for i in "${!departmentsPeopleMap[@]}"
  do
    echo "$i=${departmentsPeopleMap[$i]}"  1>&2
  done
}


function parceMapFromString() {
  # input like {"key1":["val1", "val2"], key2:[val3, val4]}
  # we extact it like line1 = "key1" line2=["val1", "val2"], key2 line3=[val3, val4]
  #

#  stringMap="${stringMap%"}"*}"
#  stringMap="${stringMap#*"{"}"
  stringMap=$1
  IFS=":"
  entries=( ${stringMap} )
  for line in "${entries[@]}" ;
  do
#      echo "'$line'"  1>&2
      if [[ "$line" == *"{"*  ]];
      then
        key="${line}"
        key="${key##" "}"
        key="${key%%" "}"
        key="${key#*"'"}"
        key="${key%"'"*}"
        key="${key#*"\""}"
        key="${key%"\""*}"
      else
        if [[ "$line" == *"}"* ]]
        then
          value_str="$line"
          value_str="${value_str##*"["}"
          value_str="${value_str%%"]"*}"
          value_str="${value_str##*"("}"
          value_str="${value_str%%")"*}"
          IFS=","
          values=( $value_str )
          for val_key in "${!values[@]}" ; do
              values[$val_key]="${values[$val_key]##" "}"
              values[$val_key]="${values[$val_key]%%" "}"
              values[$val_key]="${values[$val_key]#*"'"}"
              values[$val_key]="${values[$val_key]%"'"*}"
              values[$val_key]="${values[$val_key]#*"\""}"
              values[$val_key]="${values[$val_key]%"\""*}"
          done
          value=$( IFS=';'; echo "${values[*]}" )
        else
          value_str="${line%","*}"
          value_str="${value_str##*"["}"
          value_str="${value_str%%"]"*}"
          value_str="${value_str##*"("}"
          value_str="${value_str%%")"*}"
          IFS=","
          values=( $value_str )
          for val_key in "${!values[@]}" ; do
              values[$val_key]="${values[$val_key]##" "}"
              values[$val_key]="${values[$val_key]%%" "}"
              values[$val_key]="${values[$val_key]#*"'"}"
              values[$val_key]="${values[$val_key]%"'"*}"
              values[$val_key]="${values[$val_key]#*"\""}"
              values[$val_key]="${values[$val_key]%"\""*}"
          done
          value=$( IFS=';'; echo "${values[*]}" )
        fi
        if [[ -n "$value" ]];
        then
            if [ $VERBOSE = true ];
            then
              echo "Map creation key:$key , value:$value"  1>&2
            fi
            departmentsPeopleMap[$key]="$value"
        fi
        key="${line##*","}"
        key="${key##" "}"
        key="${key%%" "}"
        key="${key#*"'"}"
        key="${key%"'"*}"
        key="${key#*"\""}"
        key="${key%"\""*}"
      fi
  done
}


function createMapWithRandom() {
      # generate(if needed) and parce names
      shuf_names=false
      if [ ! -n "$names_str" ] ;
      then
        names_str=$(python3 -c "from russian_names import RussianNames;rn = RussianNames(count=200);batch = rn.get_batch();print(batch);")
        shuf_names=true
      fi
      names_str=${names_str#*"("}
      names_str=${names_str%")"*}
      names_str=${names_str#*"["}
      names_str=${names_str%"]"*}
      IFS=","
      names=( $names_str )
      for key in "${!names[@]}"
      do
#        echo "'${names[$key]}'"  1>&2
        names[$key]=${names[$key]##" "}
        names[$key]=${names[$key]%%" "}
        names[$key]=${names[$key]#*"'"}
        names[$key]=${names[$key]%"'"*}
        names[$key]=${names[$key]#*"\""}
        names[$key]=${names[$key]%"\""*}
        if [ $VERBOSE = true ];
        then
          echo "extracted to names array : ${names[$key]}"  1>&2
        fi
      done
      if [ $shuf_names = true ] ;
      then
        for key in "${!names[@]}"
        do
#          echo "'${names[$key]}'"  1>&2
          names[$key]=${names[$key]//" "/"__SPACE__"}
        done
        IFS=$'\n'
        names=( $(shuf -e "${names[@]}") )
        for key in "${!names[@]}"
        do
#          echo "'${names[$key]}'"  1>&2
          names[$key]="${names[$key]//"__SPACE__"/" "}"
        done
      fi


      # generate(if needed) and parce departments


      if [ -z "$departments_str" ] ;
      then
        departments_str=$(cat <<EOF1
'Аппарат Банка России', 'Департамент статистики', 'Департамент исследований и прогнозирования', 'Департамент наличного денежного обращения', 'Департамент национальной платежной системы', 'Департамент бухгалтерского учета и отчетности', 'Департамент регулирования бухгалтерского учета', 'Департамент допуска и прекращения деятельности финансовых организаций', 'Департамент финансового оздоровления', 'Департамент корпоративных отношений', 'Служба анализа рисков', 'Департамент банковского регулирования и аналитики', 'Департамент надзора за системно значимыми кредитными организациями', 'Служба текущего банковского надзора', 'Главная инспекция Банка России', 'Департамент операций на финансовых рынках', 'Операционный департамент', 'Департамент финансовой стабильности', 'Департамент финансового мониторинга и валютного контроля', 'Департамент денежно-кредитной политики', 'Департамент стратегического развития финансового рынка', 'Департамент страхового рынка', 'Департамент инвестиционных финансовых посредников', 'Департамент инфраструктуры финансового рынка', 'Департамент микрофинансового рынка', 'Департамент управления данными', 'Департамент противодействия недобросовестным практикам', 'Служба по защите прав потребителей и обеспечению доступности финансовых услуг', 'Юридический департамент', 'Департамент полевых учреждений', 'Департамент информационных технологий', 'Департамент финансовых технологий', 'Департамент проектов и процессов', 'Департамент кадровой политики', 'Финансовый департамент', 'Департамент внутреннего аудита', 'Департамент организации международных расчетов', 'Департамент сотрудничества с международными организациями', 'Департамент по связям с общественностью', 'Административный департамент', 'Департамент закупок Банка России', 'Департамент недвижимости Банка России', 'Департамент информационной безопасности', 'Департамент безопасности Банка России', 'Университет Банка России']
EOF1
      )
      fi
      #departments_str='["elem1", "elem2"]'
      #departments_str=${departments_str//'\n'/" "}
      #readarray -t departments < <(jq -r '.[]' <<< "$departments_str")
      #readarray -t departments < <(jq -r '.[]'  <<< "$departments_str")
      departments_str=${departments_str#*"("}
      departments_str=${departments_str%")"*}
      departments_str=${departments_str#*"["}
      departments_str=${departments_str%"]"*}
      departments_str=${departments_str//"'"/}
      departments_str=${departments_str//"\""/}
      IFS=","
      departments=( $departments_str )
      for key in "${!departments[@]}"
      do
        departments[$key]=${departments[$key]##" "}
        departments[$key]=${departments[$key]%%" "}
        departments[$key]=${departments[$key]#*"'"}
        departments[$key]=${departments[$key]%"'"*}
        departments[$key]=${departments[$key]##"\""}
        departments[$key]=${departments[$key]%%"\""}
        if [ $VERBOSE = true ];
        then
          echo "extracted to departments array: ${departments[$key]}"  1>&2
        fi
      done




      (( departments_key = -1 ))
      departments_length=${#departments[@]}
      department_name=""
      (( separator = 0 ))
      for names_key in "${!names[@]}"
      do
#        echo "'${names[$names_key]}'"
        if (( separator == 0 && departments_key + 1 < departments_length ));
        then
          (( departments_key += 1 ))
          separator=$(shuf -i 3-20 -n 1)
          department_name="${departments[departments_key]}"
        else
          (( separator -= 1 ))
        fi
        if [[ -v 'departmentsPeopleMap[$department_name]' ]] ;
        then
          departmentsPeopleMap[$department_name]="${departmentsPeopleMap[$department_name]};${names[names_key]}"
#          echo "${departmentsPeopleMap[$department_name]}"  1>&2
        else
          departmentsPeopleMap[$department_name]="${names[names_key]}"
#          echo "111${department_name};${departmentsPeopleMap[$department_name]}222"  1>&2
        fi
      done
      if [ $VERBOSE = true ];
      then
        for key in "${!departmentsPeopleMap[@]}"
        do
          echo "Map creation key:${key} ---- value:${departmentsPeopleMap[$key]}"  1>&2
        done
      fi

}



while getopts 'hvm:n:d:p:c:u:-:' OPTION; do
  if [ "$OPTION" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"       # extract long option name
   OPTARG="${OPTARG#OPTION}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPTION" in
    h | help)
      echo "-v | --verbose - to verbose print"
      echo "-n | --names - to set names (they mast be separated with ', ')"
      echo "-d | --departments - to set departments (they mast be separated with ', ')"
      echo "-p | --path - to set working directory to set departments file system"
      echo "-m | --map - you can set map department-names and from this map will be created file tree"
      exit 1
      ;;
    v | verbose)
      VERBOSE=true
#      shift "$(($OPTIND -1))"
      ;;
    n | names)
      echo "use provided names"  1>&2
      names_str="$OPTARG"
      ;;
    d | departments)
      echo "use provided departments"  1>&2
      departments_str="$OPTARG"
      ;;
    p | path)
      WORKING_DIRECTORY=$(realpath $OPTARG)
      echo "use dir provided working directory"  1>&2
      ;;
    m | map)
      stringMapdepartmentsPeople="${OPTARG}"
      echo "use provided map $stringMapdepartmentsPeople"  1>&2
      ;;
    c | certificates)
      CERTIFICATE_DIRECTORY=$(realpath $OPTARG)
      echo "use provided certificate directory $CERTIFICATE_DIRECTORY"  1>&2
      ;;
    u | used_certificates)
      USED_CERTIFICATE_DIRECTORY=$(realpath $OPTARG)
      echo "use provided used certificate directory $USED_CERTIFICATE_DIRECTORY"  1>&2
      ;;
    *)
      echo "script usage: $(basename \$0) [-h] [-v] [-n listOfNames] [-d listOfDepartments] [-m someMapDepartmentsNames] [-p working_directory] [-c certificates directory] [-u used certificates directory]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

#echo "'${stringMapdepartmentsPeople}'"
#echo "'${WORKING_DIRECTORY}'"
if [ -z "$WORKING_DIRECTORY" ] ;
then
  WORKING_DIRECTORY=$(realpath ".")
fi

if [ $VERBOSE = true ] ;
then
      echo "WORKING_DIRECTORY=$WORKING_DIRECTORY"  1>&2
fi


if [[ -n "${stringMapdepartmentsPeople}" ]]
then
  parceMapFromString "${stringMapdepartmentsPeople}"
else
  createMapWithRandom
fi


for department_name in "${!departmentsPeopleMap[@]}"
do
  dir_path="$WORKING_DIRECTORY/$department_name"
  if [ ! -d "$dir_path" ];
  then
    mkdir "$dir_path"
    if [ $VERBOSE = true ];
    then
        echo "created $dir_path directory"  1>&2
    fi
  fi
  IFS=";"
  names_list=( ${departmentsPeopleMap[$department_name]} )
  for name in "${names_list[@]}"
  do
    IFS=" "
    fio_list=( $name )
    if [[ $use_only_femail == false || ("${#fio_list[@]}" == "3" && "${fio_list[$LASTNAME_INDEX]}" =~ ^.*вна$) ]]
    then
      #mast be change to pdf on production
      file_path="$dir_path/${name}.pdf"
      if [ ! -f file_path ] ;
      then
        touch "$file_path"
        if [ $VERBOSE = true ];
        then
            echo "created $file_path file"  1>&2
        fi
        get_certificate "$department_name" "${name}" "$file_path" 2>&2
      else
        if [ $VERBOSE = true ];
        then
            echo "rewrote $file_path file"  1>&2
        fi
        if [ $REGENERATE_CERTIFICATE = true ]
        then
          get_certificate "$department_name" "${name}" "$file_path" 2>&2
        fi
      fi
    fi
  done
done
