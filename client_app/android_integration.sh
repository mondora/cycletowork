pushd android
# flutter build generates files in android/ for building the app
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/_login_test.dart
popd

# chmod +x android_integration.sh
# ./android_integration.sh