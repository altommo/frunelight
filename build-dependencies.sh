#!/bin/bash

# FruneLight Dependency Builder
# Automatically clones and builds all required dependencies

set -e

echo "🚀 FruneLight Dependency Builder"
echo "================================"

# Configuration
DEPS_DIR="dependencies"
LIBS_DIR="libs"

# Framework repositories  
MELXIN_RUNELITE="https://codeberg.org/melxin/runelite.git"
MELXIN_DEVIOUS="https://github.com/melxin/devious-client.git"
MELXIN_MICROBOT="https://github.com/melxin/Microbot.git"
OSRSB_OSRSBOT="https://github.com/OSRSB/OsrsBot.git"

# Create directories
mkdir -p "$DEPS_DIR"
mkdir -p "$LIBS_DIR"

echo "📁 Setting up dependency directories..."

# Function to clone or update repository
clone_or_update() {
    local repo_url=$1
    local dir_name=$2
    
    echo "📥 Processing $dir_name..."
    
    if [ -d "$DEPS_DIR/$dir_name" ]; then
        echo "   Repository exists, updating..."
        cd "$DEPS_DIR/$dir_name"
        git pull
        cd ../..
    else
        echo "   Cloning repository..."
        git clone "$repo_url" "$DEPS_DIR/$dir_name"
    fi
}

# Function to build Gradle project
build_gradle() {
    local dir_name=$1
    local jar_pattern=$2
    local output_name=$3
    
    echo "🔨 Building $dir_name..."
    cd "$DEPS_DIR/$dir_name"
    
    if [ -f "gradlew" ]; then
        ./gradlew clean build -x test
    elif [ -f "gradlew.bat" ]; then
        ./gradlew.bat clean build -x test
    else
        gradle clean build -x test
    fi
    
    # Copy JAR to libs directory
    find . -name "$jar_pattern" -type f -exec cp {} "../../$LIBS_DIR/$output_name" \;
    cd ../..
    echo "✅ $dir_name built successfully"
}

# Function to build Maven project
build_maven() {
    local dir_name=$1
    local jar_pattern=$2
    local output_name=$3
    
    echo "🔨 Building $dir_name (Maven)..."
    cd "$DEPS_DIR/$dir_name"
    
    mvn clean package -DskipTests
    
    # Copy JAR to libs directory
    find . -name "$jar_pattern" -type f -exec cp {} "../../$LIBS_DIR/$output_name" \;
    cd ../..
    echo "✅ $dir_name built successfully"
}

# Clone/update all repositories
echo "📦 Fetching dependencies..."
clone_or_update "$MELXIN_RUNELITE" "melxin-runelite"
clone_or_update "$MELXIN_DEVIOUS" "melxin-devious-client"  
clone_or_update "$MELXIN_MICROBOT" "melxin-microbot"
clone_or_update "$OSRSB_OSRSBOT" "osrsbot"

# Build all dependencies
echo "🏗️  Building dependencies..."

# Build melxin-runelite
build_gradle "melxin-runelite" "*-shaded.jar" "melxin-runelite.jar"

# Build melxin-devious-client
build_gradle "melxin-devious-client" "*-shaded.jar" "melxin-devious-client.jar"

# Build melxin-microbot (Maven)
build_maven "melxin-microbot" "microbot-*.jar" "melxin-microbot.jar"

# Build OSRSBot (may need special handling)
echo "🔨 Building OSRSBot..."
cd "$DEPS_DIR/osrsbot"
if ./gradlew clean build -x test 2>/dev/null; then
    find . -name "*.jar" -not -path "*/test/*" -exec cp {} "../../$LIBS_DIR/osrsbot.jar" \;
    echo "✅ OSRSBot built successfully"
else
    echo "⚠️  OSRSBot build failed, skipping..."
fi
cd ../..

# Verify builds
echo "📋 Verifying builds..."
for jar in "$LIBS_DIR"/*.jar; do
    if [ -f "$jar" ]; then
        size=$(du -h "$jar" | cut -f1)
        echo "✅ $(basename "$jar") - $size"
    fi
done

echo ""
echo "🎉 Dependency build complete!"
echo "📁 JAR files are in the '$LIBS_DIR' directory"
echo "🚀 Ready to build FruneLight!"
