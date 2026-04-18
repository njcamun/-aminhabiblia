// This is the build.gradle.kts file for the 'app' module of your Flutter project (Kotlin DSL).

import java.util.Properties

plugins {
    id("com.android.application")           
    kotlin("android")                       
    id("dev.flutter.flutter-gradle-plugin") 
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterRoot = localProperties.getProperty("flutter.sdk")
if (flutterRoot.isNullOrBlank()) {
    throw GradleException("Flutter SDK not found. Define location with flutter.sdk in local.properties.")
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties().apply {
    val keyPropsFile = file("../key.properties")
    if (keyPropsFile.exists()) {
        keyPropsFile.inputStream().use { load(it) }
    }
}

android {
    namespace = "com.nelson.biblia_app"
    // Atualizado para 36 conforme exigido pelos plugins no seu log
    compileSdk = 36 

    // Atualizado conforme exigido pelos plugins no seu log
    ndkVersion = "28.2.13676358"

    defaultConfig {
        applicationId = "com.nelson.biblia_app"
        minSdk = flutter.minSdkVersion 
        targetSdk = 36 
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    
    kotlinOptions {
        jvmTarget = "17"
    }

    packaging {
        jniLibs {
            // MÉTODO MODERNO PARA 16KB: useLegacyPackaging = false
            // Com AGP 8.3+ e NDK 27, isso alinha as libs nativas (.so) automaticamente em 16KB no APK.
            useLegacyPackaging = false
        }
    }

    signingConfigs {
        create("release") {
            val sFile = keystoreProperties.getProperty("storeFile")
            if (sFile != null) {
                storeFile = file("../" + sFile)
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
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
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.multidex:multidex:2.0.1")
}
