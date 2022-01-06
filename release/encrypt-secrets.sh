encrypt() {
  PASSPHRASE=$1
  INPUT=$2
  OUTPUT=$3
  gpg --batch --yes --passphrase="$PASSPHRASE" --cipher-algo AES256 --symmetric --output $OUTPUT $INPUT
}

if [[ ! -z "$ENCRYPT_KEY" ]]; then
  encrypt ${ENCRYPT_KEY} .env.default .env.default.gpg
  encrypt ${ENCRYPT_KEY} ezc_dev.jks ezc_dev.gpg
  encrypt ${ENCRYPT_KEY} google-services.json google-services.gpg
  encrypt ${ENCRYPT_KEY} key_store.properties key_store.gpg
else
  echo "ENCRYPT_KEY is empty"
fi
