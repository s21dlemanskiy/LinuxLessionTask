
TOKEN="5662594280:AAGhEFWlCW5qClFAVCp5Q4lJ3E-VjEFaspM"

VERBOSE=false

DEPARTMENTS_MAP="{'Департамент статистики':{'chat_id':536160029, 'user_name':'user', 'password':'pass'}}"
tmp_file_name="tmp_file.tar"


function get_departments_map_data() {
#  echo "DN:$1" >&2
  echo $(python3 -c "map=$DEPARTMENTS_MAP;result = map.get(\"$1\", {}).get(\"$2\", '');print(result)")
}
#curl -X POST -v -F "chat_id=536160029" -H "Content-Type:multipart/form-data" -F document=@"/mnt/c/Users/koly36/Desktop/tmp/tmp_file.tar" "https://api.telegram.org/bot5662594280:AAGhEFWlCW5qClFAVCp5Q4lJ3E-VjEFaspM/sendDocument"

#echo $(get_departments_map_data "Департамент статистики" "chat_id")

while getopts 'ndp:hv-:' OPTION; do
  if [ "$OPTION" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"       # extract long option name
   OPTARG="${OPTARG#OPTION}"   # extract long option argument (may be empty)
#    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPTION" in
    h | help)
      echo "-v | --verbose - to verbose print"
      echo "-d | --departments - to set departments (they mast be separated with ', ')"
      echo "-p | --path"
      ;;
    v | verbose)
      VERBOSE=true
      ;;
    d | departments)
      echo "use provided departments"
      departments_str="$OPTARG"
      ;;
    p | path)
      WORKING_DIRECTORY=$(realpath $OPTARG)
      ;;
    *)
      echo "script usage: $(basename \$0) [-h] [-v] [-n somevalue] [-d somevalue] working_directory(optional)" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [ -z "$WORKING_DIRECTORY" ] ;
then
  WORKING_DIRECTORY=$(realpath ".")
fi

if [ $VERBOSE = true ] ;
then
      echo "WORKING_DIRECTORY=$WORKING_DIRECTORY"
fi
if [ -z "$departments_str" ] ;
then
  departments_str=$(cat <<EOF1
 'Аппарат Банка России', 'Департамент статистики', 'Департамент исследований и прогнозирования', 'Департамент наличного денежного обращения', 'Департамент национальной платежной системы', 'Департамент бухгалтерского учета и отчетности', 'Департамент регулирования бухгалтерского учета', 'Департамент допуска и прекращения деятельности финансовых организаций', 'Департамент финансового оздоровления', 'Департамент корпоративных отношений', 'Служба анализа рисков', 'Департамент банковского регулирования и аналитики', 'Департамент надзора за системно значимыми кредитными организациями', 'Служба текущего банковского надзора', 'Главная инспекция Банка России', 'Департамент операций на финансовых рынках', 'Операционный департамент', 'Департамент финансовой стабильности', 'Департамент финансового мониторинга и валютного контроля', 'Департамент денежно-кредитной политики', 'Департамент стратегического развития финансового рынка', 'Департамент страхового рынка', 'Департамент инвестиционных финансовых посредников', 'Департамент инфраструктуры финансового рынка', 'Департамент микрофинансового рынка', 'Департамент управления данными', 'Департамент противодействия недобросовестным практикам', 'Служба по защите прав потребителей и обеспечению доступности финансовых услуг', 'Юридический департамент', 'Департамент полевых учреждений', 'Департамент информационных технологий', 'Департамент финансовых технологий', 'Департамент проектов и процессов', 'Департамент кадровой политики', 'Финансовый департамент', 'Департамент внутреннего аудита', 'Департамент организации международных расчетов', 'Департамент сотрудничества с международными организациями', 'Департамент по связям с общественностью', 'Административный департамент', 'Департамент закупок Банка России', 'Департамент недвижимости Банка России', 'Департамент информационной безопасности', 'Департамент безопасности Банка России', 'Университет Банка России']
EOF1
)
fi
departments_str=${departments_str//"("/}
departments_str=${departments_str//")"/}
departments_str=${departments_str//"["/}
departments_str=${departments_str//"]"/}
departments_str=${departments_str//"'"/}
departments_str=${departments_str//"\""/}
departments_str=${departments_str//", "/"DELIMITER"}
departments_str=${departments_str//" "/"__SPACE__"}
departments=(${departments_str//"DELIMITER"/" "})
for key in "${!departments[@]}"
do
  departments[$key]=${departments[$key]//"__SPACE__"/" "}
  if [ $VERBOSE = true ];
  then
    echo "${departments[$key]}"
  fi
done
for departments_key in "${!departments[@]}"
do
    department_name=${departments[departments_key]}
    dir_path="$WORKING_DIRECTORY/$department_name/"
    chat_id=$(get_departments_map_data "$department_name" "chat_id")
    user_name=$(get_departments_map_data "$department_name" "user_name")
    password=$(get_departments_map_data "$department_name" "password")
    if [ -d "$dir_path" ];
    then
      tmp_file_path="$WORKING_DIRECTORY/$tmp_file_name"
      tar -cvf "$tmp_file_path" "$dir_path"
      echo $tmp_file_path
      [ -n "$chat_id" ] && curl -v -F "chat_id=$chat_id" -F "text=user:${user_name}password:${password}" "https://api.telegram.org/bot${TOKEN}/sendMessage"
      [ -n "$chat_id" ] && curl -v -F "chat_id=$chat_id" -F document=@"$tmp_file_path" "https://api.telegram.org/bot${TOKEN}/sendDocument"
      if [ $VERBOSE = true ];
      then
          [ -n "$chat_id" ] && echo "fetch $dir_path directory"
          [ -z "$chat_id" ] && echo "empty chat_id for $department_name"
      fi
      rm "$tmp_file_path"
    else
      if [ $VERBOSE = true ];
      then
          echo "Directory $dir_path doesn't exist. It will be skiped"
      fi
    fi
done