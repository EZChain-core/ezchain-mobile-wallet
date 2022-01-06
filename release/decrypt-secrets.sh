decrypt() {
  PASSPHRASE=$1
  INPUT=$2
  OUTPUT=$3
  gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" --output $OUTPUT $INPUT
}

if [[ ! -z "$ENCRYPT_KEY" ]]; then
  decrypt ${ENCRYPT_KEY} .env.default.gpg .env.default
  decrypt ${ENCRYPT_KEY} ezc_dev.gpg ezc_dev.jks
  decrypt ${ENCRYPT_KEY} google-services.gpg google-services.json
  decrypt ${ENCRYPT_KEY} key_store.gpg key_store.properties
else
  echo "ENCRYPT_KEY is empty"
fi
