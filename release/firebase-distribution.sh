firebase_distribution() {
  ENCRYPT_KEY=$1
  export ENCRYPT_KEY=$ENCRYPT_KEY && ./decrypt-secrets.sh
  cp .env.default ../android/fastlane
  cp google-services.json ../android/app
  cp .env.default ../ios/fastlane
  cp ../ios/Runner/GoogleService-Info.plist GoogleService-Info-mock.plist
  cp GoogleService-Info.plist ../ios/Runner/GoogleService-Info.plist
  cd ../android && fastlane android_internal_alpha
  #cd ../ios && fastlane ios_internal_alpha
  #cd ../ios && fastlane ios_test
  cd ../release && cp GoogleService-Info-mock.plist ../ios/Runner/GoogleService-Info.plist
  cd ../release && ./clean-secrets.sh
}

if [[ ! -z "$ENCRYPT_KEY" ]]; then
  firebase_distribution ${ENCRYPT_KEY}
else
  echo "ENCRYPT_KEY is empty"
fi