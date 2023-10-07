# LinuxLessionTask
TASK:<br>
Автоматическая раздача подарочных pdf-сертификатов девушкам сотрудникам фирмы.<br>
Исходные данные: <br>
-- список сотрудников в формате .xls<br>
-- папка с 200 подарочными файлами<br>
По файлу создается список подразделений фирмы, для каждого подразделения состав сотрудников делится на мужчин и женщин (да, только два гендера), в каталог подразделения складывается необходимое количество сертификатов. Доступ к файлам организуется для специально созданного пользователя, логин\пароль рассылается главам подразделений по почте, дополнительно высылается архив с “подарками”.



# How To Use

для запуска в линукс нужно установить пакты из requrements.txt

excelExtractor перобразовавает XLSX файл в csv а после агрегирует по одному из стобцов значения другого столбца <br>
-k | --keyColumn - to specify num of column that is key in map (group by this column) <br>
-v | --valueColumn - to specify num of column that is value in map (that will bee group in list of values for each key) <br>
-s | --spliter - to set spliter for values (default ',') <br>
-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',') <br>
при этом значения у одного ключа могут повторться, тогда на выходе у одного ключа бдет несколько значений. При этом стоит отметить что параметры -k и -v соответсвуют excel-евской идеии и начинаются с 1, а не с 0 <br>
Пример использования:<br>
 ./excelExtractor.sh  -k 1 -v 2 -s "|" -e "^" ./Departments_data1.xlsx<br>
 получим что то типа {'Аппарат Банка России':['Федор Алексеевич Расходов'|'Лиза Леонидовна Ходжиязова'|'Виолетта Максимовна Турлина'|'Геннадий Аркадиевич Намазаоиев'|'Раиса Алексеевна Хузрева']^'Служба анализа рисков':['Кира Сергеевна Хотенцева'|'Владислав Юрьевич Альжигидов'|'Анатолий Денисович Олегин'|'Георгий Георгиевич Сибукаев'|'Софья Егоровна Гюшнибаева']^'Департамент статистики':['Константин Вадимович Николашев'|'Вячеслав Николаевич Чуршунов']}<br>

creator генерит необходимую файловую систему <br>
-h | --help - to see this list <br>
-v | --verbose - to verbose print <br>
-n | --names - to set names (they mast be separated with ', ') <br>
-d | --departments - to set departments (they mast be separated with ', ') <br>
-p | --path - to set working directory to set departments file system <br>
-m | --map - you can set map department-names and from this map will be created file tree<br>
по дефолту генерит рандомные имена и берет департаменты из списка (откуда список? хз. Егор откуда то достал, а я позаимствовал) но можно специфицировать мапу департамент-сотрудники что бы сгенерировалось из мапы<br>
Пример использования:<br>
./creator.sh -v -m "{'key1':['val1', 'val2', 'val3'], 'key2':['val4']}" -p ./tmp<br>
Так же стоит отметить что именно он отсекает лиц мужкого пола, если мы хотим что бы раотало для всех нужно поменять параметр use_only_femail в начале файла.


excelExtractorBoss
-h | --help - to see this list <br>
-d | --departmentCol - to specify num of department column that contains name of department (of what deo=partment is boss) <br>
-c | --chatIdCol - to specify num of chat id column <br>
-u | --userNameCol - to specify num of column with username (that will be owner of folder with certificates) <br>
-p | --passwordCol - to specify num of column with password for user <br>
-s | --spliter - to set spliter for values (default ',') <br>
-e | --entitySpliter - to set spliter for entity (pair of key and value) (default ',') <br>


sender делает рассылку (в теории он и есть основная задача задания)
-h | --help - to see this list <br>
-v | --verbose - to verbose print <br>
-d | --departments - to set departments (they mast be separated with ', ') <br>
-p | --path - to set working directory to set departments file system <br>



# Quick start
It is obviosly not that quick, but not so hard.

#start with update <br>
sudo apt update

sudo apt install xlsx2csv <br>


#for start you need to install python3
sudo apt install python3



#then install pip  <br>
sudo apt install python3-pip python3-dev <br>
#or <br>
wget https://bootstrap.pypa.io/get-pip.py | sudo python3 get-pip.py <br>



#then install library for python3 <br>
pip3 install russian_names



#then you need to made .sh files executable<br>
chmod +x ./excelExtractor.sh<br>
chmod +x ./creator.sh<br>
chmod +x ./sender.sh



#напишите боту и найдите id чата (я использовал бота https://t.me/RUTtestbot)<br>
#перейдите по ссылке (заменив <TOKEN> на токен бота) и найдите ID чата<br>
https://api.telegram.org/bot<TOKEN>/getUpdates<br>
#и в файле sender.sh поменяйте мапу DEPARTMENTS_MAP (там же добавьте необходимого юзера\юзеров) (или использовать ./excelExtractorBoss.sh)


убедитесь что у вас имеется нужный xlsx файл, Departments_data.xlsx в текщей дериктории и убедитесь что есть колонка с департаментами и колонка с именами сотрудников департамента


проверьте что мапа формируется правильно (у меня первая и вторая колонки это департаменты и имена соответсятвенно (колонка A:A и B:B))<br>
./excelExtractor.sh  -k 1 -v 2 ./Departments_data1.xlsx


Дальше можно запустить ./creator.sh (но рекомендую сначла создать папку tmp что бы не засорять текущую дерикторию тогда нужно будет запускать ./creator.sh -p ./tmp). Так же отмечу что можно его запустить без дополнительных параметров тогда он создаст рандомные имена и рандомно их разбрасает по департаментам, по если мы все таки хотим подгрузить данные из XLSX то это можно сделать так:<br>
./creator.sh -v -m "$(./excelExtractor.sh ./Departments_data1.xlsx)" -p ./tmp <br>
После этого создаться дерево файлов типа /департамент/имя_сотрудника.txt<br>
Причем в фалы запишется "data-name-department", что бы изменить наполнение файла можно потрогать функцию get_certificate() в creator.sh и например достовать данные по имени или департаменту, ходить куда-нибудь курлом(curl) ну и тд.<br>
Если данные о начальниках департаментов лежат в XLSX файле(например Departments_boss.xlsx), то можно использовать ./excelExtractorBoss.sh:<br>
./excelExtractorBoss.sh -d 1 -c 2 -u 3 -p 4 ./Departments_boss.xlsx <br>
После этого можно запустить ./sender.sh он попытается написать в ТГ от имени бота <br>
./sender.sh -m "$(./excelExtractorBoss.sh -d 1 -c 2 -u 3 -p 4 ./Departments_boss.xlsx)" -d "$(echo "$(ls ./tmp)" | tr $'\n' ",")" -p ./tmp

 
