#! /bin/bash



tempfile1=/tmp/tmp_1
tempfile2=/tmp/tmp_2
tempfile3=/tmp/tmp_3
tempfile4=/tmp/tmp_4
tempfile6=/tmp/tmp_6
tempfile7=/tmp/tmp_7
logfile_PS=/home/aleks/Project/log/logfile_PS_$$.txt
conffile="conf.txt"
setup_script_template="Setup_script_template.txt"
setup_script="Setup_script.sh"

exec > >(tee -i $logfile_PS)

echo Создание заготовки скрипта установки
cp $setup_script_template $setup_script >&2 #скрипта установки 
chmod +x $setup_script

echo Чтение конфигурационного файла
echo sed '/Директория установки:/,$ d' < $conffile  > $tempfile1
sed '/Имя пользователя:/,$ d' < $conffile  > $tempfile2
sed '1,/Директория установки:/ d' < $tempfile2 > $tempfile3
sed '/Пароль:/,$ d' < $conffile  > $tempfile4
sed '1,/Имя пользователя:/ d' < $tempfile4 > $tempfile6
sed '1,/Пароль:/ d' < $conffile > $tempfile7

echo Создание скрипта установки
cp $tempfile3 $tempfile4 #копирование tmp_3

sed -i "s/..*/& \\\/" $tempfile3 #Добавление переноса строки "/"
sed -i '/sudo mount -v -t/ r /tmp/tmp_3' $setup_script #Вставка выбранного раздела в скрипт установки

sed -i 's/[0-9]//g' $tempfile4
sed -i '/grub-install/ r /tmp/tmp_4' $setup_script #Диск для установки Grub

sed -i '/-m -k / r /tmp/tmp_6' $setup_script #Вставка имени
sed -i '/groupadd/ r /tmp/tmp_6' $setup_script #Вставка имени

sed -i "s/..*/& \\\/" $tempfile6 #Добавление переноса строки "/"
sed -i '/useradd/ r /tmp/tmp_6' $setup_script #Вставка имени


sed -i '/passwd / r /tmp/tmp_7' $setup_script #Вставка пароля


