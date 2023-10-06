# LinuxLessionTask
TASK:<br>
Автоматическая раздача подарочных pdf-сертификатов девушкам сотрудникам фирмы.<br>
Исходные данные: <br>
-- список сотрудников в формате .xls<br>
-- папка с 200 подарочными файлами<br>
По файлу создается список подразделений фирмы, для каждого подразделения состав сотрудников делится на мужчин и женщин (да, только два гендера), в каталог подразделения складывается необходимое количество сертификатов. Доступ к файлам организуется для специально созданного пользователя, логин\пароль рассылается главам подразделений по почте, дополнительно высылается архив с “подарками”.



# How To Use

для запуска в линукс нужно установить пакты из requrements.txt

creator генерит необходимую файловую систему <br>
-h | --help - to see this list <br>
-v | --verbose - to verbose print <br>
-n | --names - to set names (they mast be separated with ', ') <br>
-d | --departments - to set departments (they mast be separated with ', ') <br>
-p | --path - to set working directory to set departments file system <br>
по дефолту генерит рандомные имена и берет департаменты из списка (откуда список? хз. Егор откуда то достал, а я позаимствовал)

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
sudo apt install csv2xlsx


#for start you need to install python3
sudo apt install python3



#then install pip  <br>
sudo apt install python3-pip python3-dev <br>
#or <br>
wget https://bootstrap.pypa.io/get-pip.py | sudo python3 <br>



#then install library for python3 <br>
pip3 install russian_names



#then you need to made .sh files executable<br>
chmod +x ./creator.sh<br>
chmod +x ./sender.sh



#напишите боту и найдите id чата (я использовал бота https://t.me/RUTtestbot)<br>
#перейдите по ссылке (заменив <TOKEN> на токен бота) и найдите ID чата<br>
https://api.telegram.org/bot<TOKEN>/getUpdates<br>
#и в файле sender.sh поменяйте мапу DEPARTMENTS_MAP (там же добавьте необходимого юзера\юзеров)


после этого можно запустить ./creator.sh (но рекомендую сначла создать папку tmp что бы не засорять текущую дерикторию тогда нужно будет запускать ./creator.sh -p ./tmp)<br> после этого создаться дерево файлов типа /департамент/рандомное_имя.txt<br> после этого можно запустить ./sender.sh он попытается написать в ТГ от имени бота <br> так же при желании можно изменять имена и департаменты соответствующими ключами.

