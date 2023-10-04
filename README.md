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

sender делает рассылку
в теории он и есть основная задача задания


# Quick start
It is obviosly not that quick, but not so hard.

#start with update
sudo apt update

#for start you need to install python3
sudo apt install python3

#then install pip 
sudo apt install python3-pip python3-dev
#or
wget https://bootstrap.pypa.io/get-pip.py | sudo python3

#then install library for python3
pip install russian_names

#then you need to made .sh files executable
chmod +x ./creator.sh
chmod +x ./sender.sh
