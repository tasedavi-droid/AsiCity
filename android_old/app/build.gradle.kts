plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'com.google.gms.google-services'
}

android {
    namespace 'com.example.asicity'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.asicity"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"

        multiDexEnabled true
    }

    buildTypes {
        release {
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        // ESSAS TRÊS LINHAS SÃO OBRIGATÓRIAS
        coreLibraryDesugaringEnabled false
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {

    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.10"
    implementation platform('com.google.firebase:firebase-bom:32.2.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-messaging'
    implementation 'androidx.multidex:multidex:2.0.1'
}