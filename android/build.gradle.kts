// Project-level build.gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Updated to the latest stable version for 2026
        classpath("com.google.gms:google-services:4.4.4")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// FIX: 'buildDir' is deprecated and requires a File object, not a String.
// We use layout.buildDirectory to handle this the modern way.
rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}