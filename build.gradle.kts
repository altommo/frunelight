plugins {
    java
    application
}

group = "net.frunelight"
version = "1.0.0"

repositories {
    mavenCentral()
    maven("https://repo.runelite.net")
    maven("https://jitpack.io")
}

dependencies {
    // Our compiled framework dependencies (built by build-dependencies script)
    implementation(files("libs/melxin-runelite.jar"))
    implementation(files("libs/melxin-devious-client.jar"))
    implementation(files("libs/melxin-microbot.jar"))
    
    // Optional: OSRSBot if successfully built
    implementation(fileTree("libs") {
        include("osrsbot.jar")
    })
    
    // ML/AI dependencies
    implementation("org.bytedeco:opencv:4.8.1-1.5.9")
    implementation("ai.djl:api:0.23.0")
    
    // Utility dependencies
    implementation("com.google.inject:guice:5.1.0")
    implementation("com.google.code.gson:gson:2.10.1")
    implementation("org.slf4j:slf4j-api:2.0.9")
    implementation("ch.qos.logback:logback-classic:1.4.11")
    
    // Test dependencies
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
}

application {
    mainClass.set("net.frunelight.FruneLightLauncher")
}

tasks.test {
    useJUnitPlatform()
}

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

// Task to build dependencies automatically
tasks.register<Exec>("buildDependencies") {
    group = "frunelight"
    description = "Builds all required framework dependencies"
    
    if (System.getProperty("os.name").lowercase().contains("windows")) {
        commandLine("cmd", "/c", "build-dependencies.bat")
    } else {
        commandLine("bash", "build-dependencies.sh")
    }
}

// Make build depend on buildDependencies if JAR files don't exist
tasks.build {
    doFirst {
        val libsDir = file("libs")
        val requiredJars = listOf(
            "melxin-runelite.jar",
            "melxin-devious-client.jar", 
            "melxin-microbot.jar"
        )
        
        val missingJars = requiredJars.filter { !file("$libsDir/$it").exists() }
        
        if (missingJars.isNotEmpty()) {
            logger.lifecycle("Missing dependency JARs: $missingJars")
            logger.lifecycle("Run 'gradle buildDependencies' to build them automatically")
        }
    }
}

// Custom task to clean dependencies
tasks.register<Delete>("cleanDependencies") {
    group = "frunelight"
    description = "Cleans all downloaded dependencies and built JARs"
    delete("dependencies", "libs")
}
