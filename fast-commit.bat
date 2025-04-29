@echo off
setlocal

chcp 65001

:: Получаем путь к директории, где находится этот .bat файл
set "script_dir=%~dp0"

:: Переходим в директорию скрипта
cd /d "%script_dir%"

git add .
git commit -m "Обновление документации по проекту"
git push origin sdwg2

endlocal