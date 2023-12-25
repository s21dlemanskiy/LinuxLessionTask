# Usage
[link to video](https://drive.google.com/file/d/1Jemu6qL1Yl29BRvN5rmEVpIxb7120_fw/view?usp=sharing)

# LinuxLessionTask
TASK:<br>
Автоматическая раздача подарочных pdf-сертификатов девушкам сотрудникам фирмы.<br>
Исходные данные: <br>
-- список сотрудников в формате .xls<br>
-- папка с 200 подарочными файлами<br>
По файлу создается список подразделений фирмы, для каждого подразделения состав сотрудников делится на мужчин и женщин (да, только два гендера), в каталог подразделения складывается необходимое количество сертификатов. Доступ к файлам организуется для специально созданного пользователя, логин\пароль рассылается главам подразделений по почте, дополнительно высылается архив с “подарками”.



# How To Use

для запуска в линукс нужно установить пакты из requrements.txt <br>

## скрипты и их задачи, а так же флаги:

**excelExtractor** перобразовавает XLSX файл в csv а после агрегирует по одному из стобцов значения другого столбца <br>
-k | --keyColumn - to specify num of column that is key in map (group by this column) <br>
-v | --valueColumn - to specify num of column that is value in map (that will bee group in list of values for each key) <br>
-s | --spliter - to set spliter for values (default ',') <br>
-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',') <br>
при этом значения у одного ключа могут повторться, тогда на выходе у одного ключа бдет несколько значений. При этом стоит отметить что параметры -k и -v соответсвуют excel-евской идеии и начинаются с 1, а не с 0 <br>
Пример использования:<br>
 ./excelExtractor.sh  -k 1 -v 2 -s "|" -e "^" ./Departments_data1.xlsx<br>
 получим что то типа {'Аппарат Банка России':['Федор Алексеевич Расходов'|'Лиза Леонидовна Ходжиязова'|'Виолетта Максимовна Турлина'|'Геннадий Аркадиевич Намазаоиев'|'Раиса Алексеевна Хузрева']^'Служба анализа рисков':['Кира Сергеевна Хотенцева'|'Владислав Юрьевич Альжигидов'|'Анатолий Денисович Олегин'|'Георгий Георгиевич Сибукаев'|'Софья Егоровна Гюшнибаева']^'Департамент статистики':['Константин Вадимович Николашев'|'Вячеслав Николаевич Чуршунов']}<br>

**creator** генерит необходимую файловую систему <br>
-h | --help - to see this list <br>
-v | --verbose - to verbose print <br>
-n | --names - to set names (they mast be separated with ', ') <br>
-d | --departments - to set departments (they mast be separated with ', ') <br>
-p | --path - to set working directory to set departments file system <br>
-m | --map - you can set map department-names and from this map will be created file tree<br>
-c | --certificates   from where take pdf certificates <br>
-u | --used_certificates  where store used certificates <br>
по дефолту генерит рандомные имена и берет департаменты из списка (откуда список? хз. Егор откуда то достал, а я позаимствовал) но можно специфицировать мапу департамент-сотрудники что бы сгенерировалось из мапы<br>
Пример использования:<br>
./creator.sh -v -m "{'key1':['val1', 'val2', 'val3'], 'key2':['val4']}" -p ./tmp -c ./certificates -u ./used_certificates<br>
Так же стоит отметить что именно он отсекает лиц мужкого пола, если мы хотим что бы раотало для всех нужно поменять параметр use_only_femail в начале файла.


**excelExtractorBoss**  перобразовавает XLSX файл в csv а после достает необходимые колонки (более утилитарный чем первый) <br>
-h | --help - to see this list <br>
-d | --departmentCol - to specify num of department column that contains name of department (of what deo=partment is boss) <br>
-c | --chatIdCol - to specify num of chat id column <br>
-u | --userNameCol - to specify num of column with username (that will be owner of folder with certificates) <br>
-p | --passwordCol - to specify num of column with password for user <br>
-s | --spliter - to set spliter for values (default ',') <br>
-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',') <br>


**sender** делает рассылку (в теории он и есть основная задача задания) <br>
-h | --help - to see this list <br>
-v | --verbose - to verbose print <br>
-d | --departments - to set departments (they mast be separated with ', ') <br>
-p | --path - to set working directory to set departments file system <br>
-m | --departmentsBossMap - to set map like "{departmentname:{'chat_id':1222212, 'user_name':'username1', 'password':'hardPass'}}" <br>



# Quick start
It is obviosly not that quick, but not so hard.

#start with update <br>
> sudo apt update
#install xlsx2csv
> sudo apt install xlsx2csv


#for start you need to install python3
> sudo apt install python3

#install 7z
> sudo apt install p7zip-full


#then install pip  <br>
> sudo apt install python3-pip python3-dev
#or <br>
> wget https://bootstrap.pypa.io/get-pip.py | sudo python3 get-pip.py 



#then install library for python3 <br>
> pip3 install russian_names



#then you need to made .sh files executable<br>
> chmod +x ./excelExtractor.sh
> chmod +x ./creator.sh
> chmod +x ./sender.sh
> chmod +x ./excelExtractorBoss.sh



#напишите боту и найдите id чата (я использовал бота https://t.me/RUTtestbot)<br>
#перейдите по ссылке (заменив <TOKEN> на токен бота) и найдите ID чата<br>
https://api.telegram.org/bot<TOKEN>/getUpdates<br>
#и в файле sender.sh поменяйте мапу DEPARTMENTS_MAP (там же добавьте необходимого юзера\юзеров) (или использовать ./excelExtractorBoss.sh)


убедитесь что у вас имеется нужный xlsx файл, Departments_data.xlsx в текщей дериктории и убедитесь что есть колонка с департаментами и колонка с именами сотрудников департамента


проверьте что мапа формируется правильно (у меня первая и вторая колонки это департаменты и имена соответсятвенно (колонка A:A и B:B))<br>
> ./excelExtractor.sh  -k 1 -v 2 ./Departments_data1.xlsx


Дальше можно запустить ./creator.sh (но рекомендую сначла создать папку tmp что бы не засорять текущую дерикторию тогда нужно будет запускать ./creator.sh -p ./tmp). Так же отмечу что можно его запустить без дополнительных параметров тогда он создаст рандомные имена и рандомно их разбрасает по департаментам, по если мы все таки хотим подгрузить данные из XLSX то это можно сделать так:<br>
> ./creator.sh -v -m "$(./excelExtractor.sh ./Departments_data1.xlsx)" -p ./tmp -c ./certificates -u ./used_certificates
После этого создаться дерево файлов типа /департамент/имя_сотрудника.txt<br>
Причем в фалы запишется случайный сертификат из ./certificates и каждый записанный сертификат удаляется из этой папки и переносится в ./used_certificates<br>
Если данные о начальниках департаментов лежат в XLSX файле(например Departments_boss.xlsx), то можно использовать ./excelExtractorBoss.sh:<br>
> ./excelExtractorBoss.sh -d 1 -c 2 -u 3 -p 4 ./Departments_boss.xlsx 
После этого можно запустить ./sender.sh он попытается написать в ТГ от имени бота <br>
> ./sender.sh -m "$(./excelExtractorBoss.sh -d 1 -c 2 -u 3 -p 4 ./Departments_boss.xlsx)" -d "$(echo "$(ls ./tmp)" | tr $'\n' ",")" -p ./tmp






 tables example 
 <table border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0 gridlines">
        <colgroup><col class="col0">
        <col class="col1">
        <col class="col2">
        <col class="col3">
        <col class="col4">
        <col class="col5">
        <col class="col6">
        <col class="col7">
        <col class="col8">
        </colgroup><tbody>
         <tr>
          <th colspan="8">./Departments_data1.xlsx</th>
        </tr>
          <tr class="row0">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Федор Алексеевич Расходов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row1">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Лиза Леонидовна Ходжиязова</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row2">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Виолетта Максимовна Турлина</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row3">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Геннадий Аркадиевич Намазаоиев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row4">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Раиса Алексеевна Хузрева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row5">
            <td class="column0 style1 s">Департамент статистики</td>
            <td class="column1 style1 s">Константин Вадимович Николашев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row6">
            <td class="column0 style1 s">Департамент статистики</td>
            <td class="column1 style1 s">Вячеслав Николаевич Чуршунов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row7">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Кира Сергеевна Хотенцева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row8">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Владислав Юрьевич Альжигидов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row9">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Анатолий Денисович Олегин</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row10">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Георгий Георгиевич Сибукаев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row11">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Софья Егоровна Гюшнибаева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
        </tbody>
    </table>


<table border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0 gridlines">
        <colgroup><col class="col0">
        <col class="col1">
        <col class="col2">
        <col class="col3">
        <col class="col4">
        <col class="col5">
        <col class="col6">
        <col class="col7">
        <col class="col8">
        </colgroup><tbody>
         <tr>
          <th colspan="8">./Departments_boss.xlsx</th>
        </tr>
          <tr class="row0">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style2 n">536160029</td>
            <td class="column2 style1 s">user1</td>
            <td class="column3 style3 s">pass1</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row1">
            <td class="column0 style1 s">Департамент статистики</td>
            <td class="column1 style3 n">536160029</td>
            <td class="column2 style1 s">user232</td>
            <td class="column3 style3 s">pass2</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row2">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style4 n">536160029</td>
            <td class="column2 style1 s">user3</td>
            <td class="column3 style3 s">pass37</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row3">
            <td class="column0">&nbsp;</td>
            <td class="column1">&nbsp;</td>
            <td class="column2">&nbsp;</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row4">
            <td class="column0">&nbsp;</td>
            <td class="column1">&nbsp;</td>
            <td class="column2">&nbsp;</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row5">
            <td class="column0">&nbsp;</td>
            <td class="column1">&nbsp;</td>
            <td class="column2">&nbsp;</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
        </tbody>
    </table>


# Additinal Info\Bags\Other
будте осторожны с длинными именами флагов. Они не всегда правильно работают, тк все длинные имена требуют агрумента и например --verbose может выдать что то неожиданное. так что лучше использовать короткие ключи типа -v.


заголоки в XLSX файлах все испортят (TODO: добавить ключ который позволяет скипать n первых строк)


Я старался разделять вывод и инфармационные сообщения в отдельные потоки, но вспомнил я про это ближе к концу, так что могут вылезти артефакты


разбор столбца ФИО на четыре, фамилия,  имя, отчество и инициалы написанно на питоне с использованием pandas, тк писать это на sh скриптах..... Душно. для него понадобится pip3 install pandas; pip3 install openpyxl.


Пример использования:
<table border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0 gridlines">
        <colgroup><col class="col0">
        <col class="col1">
        <col class="col2">
        <col class="col3">
        <col class="col4">
        <col class="col5">
        <col class="col6">
        <col class="col7">
        <col class="col8">
        </colgroup><tbody>
         <tr>
          <th colspan="8">./Departments_data1.xlsx</th>
        </tr>
          <tr class="row0">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Федор Алексеевич Расходов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row1">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Лиза Леонидовна Ходжиязова</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row2">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Виолетта Максимовна Турлина</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row3">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Геннадий Аркадиевич Намазаоиев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row4">
            <td class="column0 style1 s">Аппарат Банка России</td>
            <td class="column1 style1 s">Раиса Алексеевна Хузрева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row5">
            <td class="column0 style1 s">Департамент статистики</td>
            <td class="column1 style1 s">Константин Вадимович Николашев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row6">
            <td class="column0 style1 s">Департамент статистики</td>
            <td class="column1 style1 s">Вячеслав Николаевич Чуршунов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row7">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Кира Сергеевна Хотенцева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row8">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Владислав Юрьевич Альжигидов</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row9">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Анатолий Денисович Олегин</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row10">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Георгий Георгиевич Сибукаев</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
          <tr class="row11">
            <td class="column0 style1 s">Служба анализа рисков</td>
            <td class="column1 style1 s">Софья Егоровна Гюшнибаева</td>
            <td class="column2 style1 s">otherData</td>
            <td class="column3">&nbsp;</td>
            <td class="column4">&nbsp;</td>
            <td class="column5">&nbsp;</td>
            <td class="column6">&nbsp;</td>
            <td class="column7">&nbsp;</td>
            <td class="column8">&nbsp;</td>
          </tr>
        </tbody>
    </table>

python3 ./FIO.py -i 1 -p Departments_data1.xlsx <br>
РЕзультат:
<table border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0 gridlines">
        <colgroup><col class="col0">
        <col class="col1">
        <col class="col2">
        <col class="col3">
        <col class="col4">
        <col class="col5">
        <col class="col6">
        </colgroup><tbody>
         <tr>
          <th colspan="8">./Departments_data1.xlsx</th>
        </tr>
          <tr class="row0">
            <td class="column0 style0 inlineStr">Аппарат Банка России</td>
            <td class="column1 style0 inlineStr">Федор Алексеевич Расходов</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Федор</td>
            <td class="column4 style0 inlineStr">Алексеевич</td>
            <td class="column5 style0 inlineStr">Расходов</td>
            <td class="column6 style0 inlineStr">Расходов Ф.А.</td>
          </tr>
          <tr class="row1">
            <td class="column0 style0 inlineStr">Аппарат Банка России</td>
            <td class="column1 style0 inlineStr">Лиза Леонидовна Ходжиязова</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Лиза</td>
            <td class="column4 style0 inlineStr">Леонидовна</td>
            <td class="column5 style0 inlineStr">Ходжиязова</td>
            <td class="column6 style0 inlineStr">Ходжиязова Л.Л.</td>
          </tr>
          <tr class="row2">
            <td class="column0 style0 inlineStr">Аппарат Банка России</td>
            <td class="column1 style0 inlineStr">Виолетта Максимовна Турлина</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Виолетта</td>
            <td class="column4 style0 inlineStr">Максимовна</td>
            <td class="column5 style0 inlineStr">Турлина</td>
            <td class="column6 style0 inlineStr">Турлина В.М.</td>
          </tr>
          <tr class="row3">
            <td class="column0 style0 inlineStr">Аппарат Банка России</td>
            <td class="column1 style0 inlineStr">Геннадий Аркадиевич Намазаоиев</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Геннадий</td>
            <td class="column4 style0 inlineStr">Аркадиевич</td>
            <td class="column5 style0 inlineStr">Намазаоиев</td>
            <td class="column6 style0 inlineStr">Намазаоиев Г.А.</td>
          </tr>
          <tr class="row4">
            <td class="column0 style0 inlineStr">Аппарат Банка России</td>
            <td class="column1 style0 inlineStr">Раиса Алексеевна Хузрева</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Раиса</td>
            <td class="column4 style0 inlineStr">Алексеевна</td>
            <td class="column5 style0 inlineStr">Хузрева</td>
            <td class="column6 style0 inlineStr">Хузрева Р.А.</td>
          </tr>
          <tr class="row5">
            <td class="column0 style0 inlineStr">Департамент статистики</td>
            <td class="column1 style0 inlineStr">Константин Вадимович Николашев</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Константин</td>
            <td class="column4 style0 inlineStr">Вадимович</td>
            <td class="column5 style0 inlineStr">Николашев</td>
            <td class="column6 style0 inlineStr">Николашев К.В.</td>
          </tr>
          <tr class="row6">
            <td class="column0 style0 inlineStr">Департамент статистики</td>
            <td class="column1 style0 inlineStr">Вячеслав Николаевич Чуршунов</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Вячеслав</td>
            <td class="column4 style0 inlineStr">Николаевич</td>
            <td class="column5 style0 inlineStr">Чуршунов</td>
            <td class="column6 style0 inlineStr">Чуршунов В.Н.</td>
          </tr>
          <tr class="row7">
            <td class="column0 style0 inlineStr">Служба анализа рисков</td>
            <td class="column1 style0 inlineStr">Кира Сергеевна Хотенцева</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Кира</td>
            <td class="column4 style0 inlineStr">Сергеевна</td>
            <td class="column5 style0 inlineStr">Хотенцева</td>
            <td class="column6 style0 inlineStr">Хотенцева К.С.</td>
          </tr>
          <tr class="row8">
            <td class="column0 style0 inlineStr">Служба анализа рисков</td>
            <td class="column1 style0 inlineStr">Владислав Юрьевич Альжигидов</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Владислав</td>
            <td class="column4 style0 inlineStr">Юрьевич</td>
            <td class="column5 style0 inlineStr">Альжигидов</td>
            <td class="column6 style0 inlineStr">Альжигидов В.Ю.</td>
          </tr>
          <tr class="row9">
            <td class="column0 style0 inlineStr">Служба анализа рисков</td>
            <td class="column1 style0 inlineStr">Анатолий Денисович Олегин</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Анатолий</td>
            <td class="column4 style0 inlineStr">Денисович</td>
            <td class="column5 style0 inlineStr">Олегин</td>
            <td class="column6 style0 inlineStr">Олегин А.Д.</td>
          </tr>
          <tr class="row10">
            <td class="column0 style0 inlineStr">Служба анализа рисков</td>
            <td class="column1 style0 inlineStr">Георгий Георгиевич Сибукаев</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Георгий</td>
            <td class="column4 style0 inlineStr">Георгиевич</td>
            <td class="column5 style0 inlineStr">Сибукаев</td>
            <td class="column6 style0 inlineStr">Сибукаев Г.Г.</td>
          </tr>
          <tr class="row11">
            <td class="column0 style0 inlineStr">Служба анализа рисков</td>
            <td class="column1 style0 inlineStr">Софья Егоровна Гюшнибаева</td>
            <td class="column2 style0 inlineStr">otherData</td>
            <td class="column3 style0 inlineStr">Софья</td>
            <td class="column4 style0 inlineStr">Егоровна</td>
            <td class="column5 style0 inlineStr">Гюшнибаева</td>
            <td class="column6 style0 inlineStr">Гюшнибаева С.Е.</td>
          </tr>
        </tbody>
    </table>
