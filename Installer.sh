
#!/bin/bash


file='conf.txt'            				 #конфигурационный файл
tempfile1=/tmp/dialog_1    				 #временные файлы
tempfile2=/tmp/dialog_2	
tempfile3=/tmp/dialog_3
tempfile4=/tmp/dialog_4
tempfile5=/tmp/dialog_5
tempfile7=/tmp/dialog_7
tempfile8=/tmp/dialog_8
tempfile9=/tmp/dialog_9
tempfile10=/tmp/dialog_10
tempfile11=/tmp/dialog_11
tempfile12=/tmp/dialog_12
tempfile13=/tmp/dialog_13
tempfile14=/tmp/dialog_14
tempfile15=/tmp/dialog_15
tempfile16=/tmp/dialog_16
tempfile17=/tmp/dialog_17
tempfile18=/tmp/dialog_18
tempfile19=/tmp/dialog_19
tempfile20=/tmp/dialog_20
tempfile21=/tmp/dialog_21
tempfile22=/tmp/dialog_22
Installer=/home/aleks/Project/Installer.sh		#файл главного скрипта
Version_info=/home/aleks/Project/Version_info.txt			#файл с информацией о текущей версии программы
Linux_software_info=/home/aleks/Project/Linux_software_info.txt	        #файл с информацией компонентах Linux
Preparation_script=/home/aleks/Project/Preparation_script.sh

if test -f $tempfile15 ; then echo ; else		#если tempfile15 нету, значит скрипт обрабатывается первый раз
cat << EOF > $tempfile2				#в этом случае создаются два временных файла, связанных с настройкой компонентов системы
1							
EOF
cat << EOF > $tempfile8				#и наполняются 1, означающей базовую конфигурацию (минимальный набор)
1
EOF
fi

trap "rm -f $tempfile1 $tempfile2 $tempfile3 $tempfile4 $tempfile5 $tempfile7 $tempfile8  $tempfile9 $tempfile10 $tempfile11 $tempfile12 $tempfile13 $tempfile14 $tempfile15 $tempfile16 $tempfile17 $tempfile18 $tempfile19 $tempfile20 $tempfile21 $tempfile22" 0 1 2 5 15												#после закрытия скрипта все временные файлы удаляются


_basic_setup () {								#экран отвечающий за выбор готовых конфигураций
   dialog --title "Выбор конфигурации" \
           --menu "Выберите необходимую конфигурацию" 20 50 4 \
                  1 "Базовый набор" \
                  2 "Набор разработчика"\
                  3 "Набор с SSH-доступом"\
                  4 "Набор с иерархией пользователей" 2> $tempfile2			#производится выбор одной из готовых конфигураций, номер соответствующий этой конфигурации записывается в $tempfile2

   retv=$?
   choice=$(cat $tempfile2) 
   [ $retv -eq 1 -o $retv -eq 255 ] && _main 	#переход на главнй экран при нажатии "esc" или "cencel"

   case $choice in	 #исходя из номера конфигурации происходит создание списка компонентов в файле $tempfile1
1)			#базовый набор (никаких дополнительных программ не добавляется, базовые программы изначально заносятся в конфигурационный файл)
cat << EOF > $tempfile1
EOF
cat $tempfile2 > $tempfile8 #также значения $tempfile2 переносятся в $tempfile8, данный файл нужен для корректного отображения выбранных конфигураций на экране расширенных настроек (_advanced_setup )
_main #Переход на главный экран
;;
2)			#набор разработчика
cat $tempfile2 > $tempfile8
cat << EOF > $tempfile1  
Gcc
Ncurses
Sed
Gettext
Grep
GDBM
Gperf
Autoconf
Automake
Python3
Coreutils
Check
Gawk
Make
Vim
EOF
_main 
;;
3)			#набор с SSH-доступом
cat $tempfile2 > $tempfile8
cat << EOF > $tempfile1
Iana-etc
Inetutils
Openssl
IProute
EOF
_main
;;
4)			#набор с иерархией пользователей
cat $tempfile2 > $tempfile8
cat << EOF > $tempfile1
Shadow
EOF
_main
;;
esac
}


_advanced_setup () { 		#экран отвечающий за за выбор дополнительных компонентов системы (расширенных настроек)
choice=$(cat $tempfile8) 
case $choice in		#в зависимости от пункта выбранного на экране готовых конфигураций (_basic_setup) галочкам отмечаются только те компоненты, которые входят в выбранный набор

1)			#базовый набор			
   dialog --title "Выбор компонентов для установки"\
        --checklist "Выбирите дополнительное ПО необходимое для вашей системы" 20 35 5 \
        "Iana-etc"   "" off \
        "Shadow"   "" off \
        "Gcc"   "" off \
        "Ncurses"   "" off \
        "Sed"   "" off \
        "Gettext"   "" off \
        "Grep" "" off \
        "Bash" "" off \
        "Gdbm" "" off \
        "Gperf" "" off \
        "Inetutils" "" off \
        "Autoconf" "" off \
        "Automake" "" off \
        "Openssl" "" off \
        "Python3" "" off \
        "Coreutils" "" off \
        "Check" "" off \
        "Gawk" "" off \
        "Iproute2" "" off \
        "Make" "" off \
        "Vim" "" o  2> $tempfile4 #отмеченые галочкой компоненты заносятся в файл $tempfile4 
        _next							#перехода на вторую часть скрипта данного экрана
        ;;
        
2)								#набор разработчика
  dialog --title "Выбор компонентов для установки"\
        --checklist "Выбирите дополнительное ПО необходимое для вашей системы" 20 35 5 \
        "Iana-etc"   "" off \
        "Shadow"   "" off \
        "Gcc"   "" on \
        "Ncurses"   "" on \
        "Sed"   "" on \
        "Gettext"   "" on \
        "Grep" "" on \
        "Bash" "" on \
        "Gdbm" "" on \
        "Gperf" "" on\
        "Inetutils" "" off \
        "Autoconf" "" on \
        "Automake" "" on \
        "Openssl" "" off \
        "Python3" "" on \
        "Coreutils" "" on \
        "Check" "" on \
        "Gawk" "" on \
        "Iproute2" "" off \
        "Make" "" on \
        "Vim" "" on  2> $tempfile4 #отмеченые галочкой компоненты заносятся в файл $tempfile4 
        _next
        ;;
        
3)								#набор с SSH-доступом
    dialog --title "Выбор компонентов для установки"\
        --checklist "Выбирите дополнительное ПО необходимое для вашей системы" 20 35 5 \
        "Iana-etc"   "" on \
        "Shadow"   "" off \
        "Gcc"   "" off \
        "Ncurses"   "" off \
        "Sed"   "" off \
        "Gettext"   "" off \
        "Grep" "" off \
        "Bash" "" off \
        "Gdbm" "" off \
        "Gperf" "" off\
        "Inetutils" "" on \
        "Autoconf" "" off \
        "Automake" "" off \
        "Openssl" "" on \
        "Python3" "" off \
        "Coreutils" "" off \
        "Check" "" off \
        "Gawk" "" off \
        "Iproute2" "" on \
        "Make" "" off \
        "Vim" "" off  2> $tempfile4 #отмеченые галочкой компоненты заносятся в файл $tempfile4 
        ;;
4)							#набор с иерархией пользователей
    dialog --title "Выбор компонентов для установки"\
        --checklist "Выбирите дополнительное ПО необходимое для вашей системы" 20 35 5 \
        "Iana-etc"   "" off \
        "Shadow"   "" on \
        "Gcc"   "" off \
        "Ncurses"   "" off \
        "Sed"   "" off \
        "Gettext"   "" off \
        "Grep" "" off \
        "Bash" "" off \
        "Gdbm" "" off \
        "Gperf" "" off\
        "Inetutils" "" off \
        "Autoconf" "" off \
        "Automake" "" off \
        "Openssl" "" off \
        "Python3" "" off \
        "Coreutils" "" off \
        "Check" "" off \
        "Gawk" "" off \
        "Iproute2" "" off \
        "Make" "" off \
        "Vim" "" off  2> $tempfile4 #отмеченые галочкой компоненты заносятся в файл $tempfile4 
        _next
        ;;
         esac
   	 } 


_next() { 							#вторая часть скрипта экран отвечающего за выбор дополнительных компонентов системы (_advanced_setup)
   	   retv1=$?
  	  [ $retv1 -eq 1 -o $retv1 -eq 255 ] && _main 	#переход на главнй экран при нажатии "esc" или "cencel"
cat << EOF > $tempfile1 #создание или перезапись $tempfile1 (если он уже был создан на экране выбора готовых конфигураций _basic_setup)
EOF
   	string=$(cat $tempfile4)		#переформатирование записи в строчку ($tempfile4) в запись в столбец ($tempfile1) (для конфигурационного файла) компонентов системы при помощи цикла
	IFS=' ' read -ra array <<< "$string"
	for i in "${array[@]}"
	do
   	echo $i | tee -a $tempfile1
	done
	_main #возврат на главный экран
}


_info () {  #экран информация о выбранной конфигурации
cat << EOF > $tempfile17 #создание всех необходимых файлов с шаблонами
1.Состав системы:
Ядро linux
Util-linux
Glibc
Libstdc++
Binutils
Bash
Eudev
Sysinit
zlib
zstd
Bc
Flex 
Pkg-config
Kmod
Libelf
Grub
Eudev
SysVinit
Bzip2
EOF

cat << EOF > $tempfile19
2.Директория установки:
EOF
if test -s $tempfile9 && test -f $tempfile9; then
cat << EOF > $tempfile20

3.Имя пользователя:
EOF
fi;

if test -s $tempfile21 && test -f $tempfile21; then
cat << EOF > $tempfile22

4.Пароль:
EOF
fi;

cat $tempfile17 $tempfile1 $tempfile19 $tempfile15 $tempfile20 $tempfile9 $tempfile22 $tempfile21 > $file #создание из шаблонных файлов ($tempfile17, $tempfile19, $tempfile20, $tempfile21) и файлов содержащих выбранные конфигурации ($tempfile1, $tempfile9, $tempfile15, $tempfile22) одного конфигурационного файла
dialog --clear --title "Текущая конфигурация" --textbox "$file" 0 0 #вывод созданного конфигурационного файла на экран

case $? in
  0)
    echo "OK";;
  255)
    echo "ESC pressed.";;
esac
_main 									#возврат в главное меню
}


_setup() {								#экран "Директория установки системы"
ls /dev/ | grep sd > $tempfile11					#поиск всех жестких дисков и запись их наименований в $tempfile11
cat << EOF > $tempfile12						#создание $tempfile12 с началом нового скрипта экрана, где будут расположены все доступные диски для установки системы
#!/bin/bash
dialog --title "Выбор директории" \\\

--menu "Выбирите директорию для установки системы" 15 25 10 \\\

EOF
cat << EOF > $tempfile13						#создание $tempfile13 с окончанием скрипта экрана, где будут расположены все доступные диски для установки системы
2> $tempfile15
$Installer
EOF

sed "s/..*/'&' ' ' \\\/" $tempfile11 > $tempfile14			#добавление к списку доступных дисков необходимых символов, для получение центральной части скрипта экрана, где будут расположены все доступные диски для установки системы 
cat $tempfile12 $tempfile14 $tempfile13 > $tempfile16 #сборка скрипта экрана, с расположением всех доступных дисков для установки системы 
rm -f $tempfile12 $tempfile14 $tempfile13 $tempfile11 #удаление не нужных временныъ файлов
chmod +x $tempfile16					#разрешение чтения скрипта
$tempfile16						#чтение скрипта
exit
}


_name() {
					#Экран для ввода имени пользователи
dialog --title "Ввод имени" --clear \
	--inputbox "Введите имя для учетной записи:" 16 51 2> $tempfile9 #Запись введенного имени пользователя 
case $? in
  0) _Password ;;
  esac
  retval=$?
 [ $retval -eq 1 -o $retval -eq 255 ] && _main  #переход на главнй экран при нажатии "esc", "cencel" или "ок" 
}

_Password() {						#Экран для ввода имени пользователи
dialog --title "Ввод пароля" --clear \
	--inputbox "Введите пароль:" 16 51 2> $tempfile21 #Запись введенного имени пользователя 
case $? in
  0)  _Installation_start ;;
  esac
retval=$?
[ $retval -eq 1 -o $retval -eq 255 ] && _main  #переход на главнй экран при нажатии "esc", "cencel" или "ок" 
}


_setup_start () {  #Экран начала установки системы
if test -f $tempfile15 && test -s $tempfile15; then #Проверка на наличие временного файла с директорией установки системы и проверка наличия символов в нем
		if grep "Shadow" $tempfile1; then
		_name
		else
		_Installation_start
		fi			#При подтверждении запуск скрипта установки системы
 
		else					#Если файл пуст или его нет, появляется экран с предупреждением, что установка не возможна и происходит возврат в главное меню
		dialog --title "Внимание!" --msgbox 'Перед началом установки 		необходимо произвести конфигурацию всех необходимых настроек, 		проверьте указана ли директория установки системы.' 15 30;
		_main
		fi
}

_Installation_start () {
 cat << EOF > $tempfile17 #создание всех необходимых файлов с шаблонами
1.Состав системы:
Ядро linux
Util-linux
Glibc
Libstdc++
Binutils
Bash
Eudev
Sysinit
zlib
zstd
Bc
Flex 
Pkg-config
Kmod
Libelf
Grub
Eudev
SysVinit
Bzip2
EOF

cat << EOF > $tempfile19
2.Директория установки:
EOF
if test -s $tempfile9 && test -f $tempfile9; then
cat << EOF > $tempfile20

3.Имя пользователя:
EOF
fi;

if test -s $tempfile21 && test -f $tempfile21; then
cat << EOF > $tempfile22

4.Пароль:
EOF
fi;

cat $tempfile17 $tempfile1 $tempfile19 $tempfile15 $tempfile20 $tempfile9 			$tempfile22 $tempfile21 > $file #создание из шаблонных файлов ($tempfile17, 			$tempfile19, $tempfile20, $tempfile21) и файлов содержащих выбранные 		конфигурации ($tempfile1, $tempfile9, $tempfile15, $tempfile22) одного 			конфигурационного файла
dialog --title " " --clear \
       	 --yesno "Начать установку системы?" 5 30
		case $? in
   		 0)
   		 $Preparation_script
   		 exit;;
 		 1)
		_main;;				#При отказе возврат в главное меню
   		 255)
		_main;;
		esac
		}

_info_app () { #Экрана "Спарвка"
   dialog --title "Информация о системе" \
           --menu "Для получения информации о компонентах Linux выбирите пункт <Компоненты Linux>, для получения информации о версии установщика выбирите пункт <Версия установщика>" 15 40 3 \
                  1 "Компоненты Linux" \
                  2 "Версия установщика" 2> $tempfile10
   retv=$?
   choice=$(cat $tempfile10)
   [ $retv -eq 1 -o $retv -eq 255 ] && _main
   case $choice in
       1) _Linux_software_info #Выбор экрана с информацией о компонентах Linux
       ;;
       2) _Version_info	#или о версии установщика
       ;;
   esac
}


_Version_info() {		#Экран с информацией о версии установщика
dialog --clear --title "___Версия установщика" --textbox "$Version_info" 0 0 #Отображается файл с информацией о версии установщика
case $? in
  0)
    echo "OK"
    ;;
  255)
    echo "ESC pressed."
    ;;
esac
_info_app			#Возврат на экран "Спарвка"
}


_Linux_software_info() {	#Экран с информацией о компонентах Linux
dialog --clear --title "Компоненты Linux" --textbox "$Linux_software_info" 40 80 #Отображается файл с информацией о компонентах
case $? in
  0)
    echo "OK";;
  255)
    echo "ESC pressed.";;
esac
_info_app			#Возврат на экран "Спарвка"
}


_main () {			#Экран главного меню
   dialog --title "Установка операционной системы" \
           --menu "Здравствуйте, вас приветствует установщик операционной системы, пожалуйста, произведите необходимые настройки, затем выберите пункт <Установить>, для просмотра сделанных конфигураций выберите пункт <Информация о выбранных конфигурациях>" 20 55 5 \
                  1 "Выбор готовых конфигураций установки" \
                  2 "Расширенные настройки конфигурации системы" \
                  3 "Директория установки системы" \
                  4 "Информация о выбранных конфигурациях" \
                  5 "Установить систему"\
                  6 "СПРАВКА"\
                   2> $tempfile3
   retv=$?
   choice=$(cat $tempfile3)
   [ $retv -eq 1 -o $retv -eq 255 ] && exit
   case $choice in		#В зависимости от выбора переходит на часть скрипта соответствующего экрана
       1)  _basic_setup
       ;;
       2) _advanced_setup
       ;;
       3) _setup
       ;;
       4) _info
       ;;
       5) _setup_start
       ;;
       6) _info_app
       ;;
   esac
}


_main

