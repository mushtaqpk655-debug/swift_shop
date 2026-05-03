plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // --- ADDED FOR FIREBASE ---
    id("com.google.gms.google-services")
}

android {
    namespace = "com.mushtaq.swiftshop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.mushtaq.swiftshop"

        // --- UPDATED FOR FIREBASE COMPATIBILITY ---
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // --- ADDED FOR LARGE PROJECTS ---
        multiDexEnabled = true
    }

    buildTypes {getByName("release") {
        // Use the debug signing config for now so the build doesn't fail
        signingConfig = signingConfigs.getByName("debug")

        // Set this to false to stop the Stripe R8 errors immediately
        isMinifyEnabled = false
        isShrinkResources = false

        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Basic multidex support for older Android versions
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.android.material:material:1.13.0")
}
