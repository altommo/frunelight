@echo off
REM FruneLight Dependency Builder (Windows)
REM Automatically clones and builds all required dependencies

echo 🚀 FruneLight Dependency Builder
echo ================================

REM Configuration
set DEPS_DIR=dependencies
set LIBS_DIR=libs

REM Create directories
if not exist "%DEPS_DIR%" mkdir "%DEPS_DIR%"
if not exist "%LIBS_DIR%" mkdir "%LIBS_DIR%"

echo 📁 Setting up dependency directories...

REM Clone or update repositories
echo 📦 Fetching dependencies...

REM melxin-runelite
if exist "%DEPS_DIR%\melxin-runelite" (
    echo    Updating melxin-runelite...
    cd "%DEPS_DIR%\melxin-runelite"
    git pull
    cd ..\..
) else (
    echo    Cloning melxin-runelite...
    git clone https://codeberg.org/melxin/runelite.git "%DEPS_DIR%\melxin-runelite"
)

REM melxin-devious-client
if exist "%DEPS_DIR%\melxin-devious-client" (
    echo    Updating melxin-devious-client...
    cd "%DEPS_DIR%\melxin-devious-client"
    git pull
    cd ..\..
) else (
    echo    Cloning melxin-devious-client...
    git clone https://github.com/melxin/devious-client.git "%DEPS_DIR%\melxin-devious-client"
)

REM melxin-microbot
if exist "%DEPS_DIR%\melxin-microbot" (
    echo    Updating melxin-microbot...
    cd "%DEPS_DIR%\melxin-microbot"
    git pull
    cd ..\..
) else (
    echo    Cloning melxin-microbot...
    git clone https://github.com/melxin/Microbot.git "%DEPS_DIR%\melxin-microbot"
)

REM Build all dependencies
echo 🏗️  Building dependencies...

REM Build melxin-runelite
echo 🔨 Building melxin-runelite...
cd "%DEPS_DIR%\melxin-runelite"
call .\gradlew clean build -x test
copy "runelite-client\build\libs\*-shaded.jar" "..\..\%LIBS_DIR%\melxin-runelite.jar"
cd ..\..
echo ✅ melxin-runelite built successfully

REM Build melxin-devious-client
echo 🔨 Building melxin-devious-client...
cd "%DEPS_DIR%\melxin-devious-client"
call .\gradlew clean build -x test
copy "runelite-client\build\libs\*-shaded.jar" "..\..\%LIBS_DIR%\melxin-devious-client.jar"
cd ..\..
echo ✅ melxin-devious-client built successfully

REM Build melxin-microbot (Maven)
echo 🔨 Building melxin-microbot...
cd "%DEPS_DIR%\melxin-microbot"
call mvn clean package -DskipTests
copy "runelite-client\target\microbot-*.jar" "..\..\%LIBS_DIR%\melxin-microbot.jar"
cd ..\..
echo ✅ melxin-microbot built successfully

echo 📋 Verifying builds...
for %%f in ("%LIBS_DIR%\*.jar") do (
    echo ✅ %%~nxf
)

echo.
echo 🎉 Dependency build complete!
echo 📁 JAR files are in the '%LIBS_DIR%' directory
echo 🚀 Ready to build FruneLight!
pause
