function get_certificate {
  #This is an example of using a function
  if [ -n "$1" ];
  then
    echo ""
    #there can be department
  fi
  if [ -n "$2" ];
  then
    echo ""
    #there can be name
  fi
  echo "date"
}

VERBOSE=false
REGENERATE_CERTIFICATE=false

while getopts 'ndp:hv-:' OPTION; do
  if [ "$OPTION" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"       # extract long option name
   OPTARG="${OPTARG#OPTION}"   # extract long option argument (may be empty)
#    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPTION" in
    h | help)
      echo "-v | --verbose - to verbose print"
      echo "-n | --names - to set names (they mast be separated with ', ')"
      echo "-d | --departments - to set departments (they mast be separated with ', ')"
      echo "-p | --path - to set working directory to set departments file system"
      return 1
      ;;
    v | verbose)
      VERBOSE=true
      ;;
    n | names)
      echo "use provided names"
      names_str="$OPTARG"
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
if [ ! -n "$names_str" ] ;
then
  names_str=$(python3 -c "from russian_names import RussianNames;rn = RussianNames(count=200);batch = rn.get_batch();print(batch);")
fi
names_str=${names_str//"("/}
names_str=${names_str//")"/}
names_str=${names_str//"["/}
names_str=${names_str//"]"/}
names_str=${names_str//"'"/}
names_str=${names_str//"\""/}
names_str=${names_str//", "/"DELIMITER"}
names_str=${names_str//" "/"__SPACE__"}
names_str=${names_str//"DELIMITER"/" "}
names=($names_str)
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
departments_str=${departments_str//"("/}
departments_str=${departments_str//")"/}
departments_str=${departments_str//"["/}
departments_str=${departments_str//"]"/}
departments_str=${departments_str//"'"/}
departments_str=${departments_str//"\""/}
departments_str=${departments_str//", "/"DELIMITER"}
departments_str=${departments_str//" "/"__SPACE__"}
departments=(${departments_str//"DELIMITER"/" "})
#echo $departments
for key in "${!departments[@]}"
do
  departments[$key]=${departments[$key]//"__SPACE__"/" "}
  if [ $VERBOSE = true ];
  then
    echo "${departments[$key]}"
  fi
done
names=( $(shuf -e "${names[@]}") )
for key in "${!names[@]}"
do
  names[$key]=${names[$key]//"__SPACE__"/" "}
  if [ $VERBOSE = true ];
  then
    echo "${names[$key]}"
  fi
done
(( departments_key = -1 ))
departments_length=${#departments}
department_name=""
(( separator = 0 ))
for names_key in "${!names[@]}"
do
  if (( separator == 0 && departments_key + 1 < departments_length ));
  then
    (( departments_key += 1 ))
    separator=$(shuf -i 3-20 -n 1)
    department_name=${departments[departments_key]}
    dir_path="$WORKING_DIRECTORY/$department_name"
    if [ ! -d "$dir_path" ];
    then
      mkdir "$dir_path"
      if [ $VERBOSE = true ];
      then
          echo "created $dir_path directory"
      fi
    fi
  else
    (( separator -= 1 ))
  fi
  #mast be change to pdf on production
  file_path="$dir_path/${names[names_key]}.txt"
  if [ ! -f file_path ] ;
  then
    touch "$file_path"
    if [ $VERBOSE = true ];
    then
        echo "created $file_path file"
    fi
    get_certificate "$department_name" "${names[names_key]}" 1> "$file_path" 2>&2
  else
    if [ $VERBOSE = true ];
    then
        echo "rewrote $file_path file"
    fi
    if [ $REGENERATE_CERTIFICATE = true ]
    then
      get_certificate "$department_name ""${names[names_key]}" 1> "$file_path" 2>&2
    fi
  fi
done