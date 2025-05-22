plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.islamic_store"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.islamic_store"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Firebase BoM to manage versions
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // Firebase Authentication (for user sign-in/sign-up)
    implementation("com.google.firebase:firebase-auth")

    // Cloud Firestore (for storing products, orders, user data)
    implementation("com.google.firebase:firebase-firestore")

    // Firebase Storage (if you want to upload product images)
    implementation("com.google.firebase:firebase-storage")

    // Firebase Analytics (optional but recommended for tracking user behavior)
    implementation("com.google.firebase:firebase-analytics")

    // Firebase Crashlytics (optional for error tracking in your app)
    implementation("com.google.firebase:firebase-crashlytics")
}


flutter {
    source = "../.."
}
