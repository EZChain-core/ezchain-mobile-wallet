local_dev() {
  ENCRYPT_KEY=$1
  export ENCRYPT_KEY=$ENCRYPT_KEY && ./decrypt-secrets.sh
  cp google-services.json ../android/app/google-services.json
  cp GoogleService-Info.plist ../ios/Runner/GoogleService-Info.plist
  rm -f GoogleService-Info.plist
  rm -f google-services.json
  rm -f .env.default
}

if [[ ! -z "$ENCRYPT_KEY" ]]; then
  local_dev ${ENCRYPT_KEY}
else
  echo "ENCRYPT_KEY is empty"
fi