#!/bin/bash

# Konfigurasi
THRESHOLD=10
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
EMAIL="eryzakariatrimadhani14@gmail.com" 
SMTP_SERVER="$SMTP"
SMTP_PORT="587"
SMTP_USER="$USER"
SMTP_PASSWORD="$PASSWORD"
EMAIL_FROM=$EMAIL"

# Cek apakah penggunaan disk melebihi threshold
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    # Pesan email
    SUBJECT="Disk Usage Alert"
    EMAIL_BODY="Disk usage has exceeded 90% on $(hostname). Current usage: $USAGE%."

    # Buat file email sementara
    EMAIL_CONTENT=$(mktemp)
    cat <<EOF > "$EMAIL_CONTENT"
From: $EMAIL_FROM
To: $EMAIL
Subject: $SUBJECT

$EMAIL_BODY
EOF

    # Kirim email menggunakan curl
    curl --url "smtp://$SMTP_SERVER:$SMTP_PORT" \
         --ssl-reqd \
         --mail-from "$EMAIL_FROM" \
         --mail-rcpt "$EMAIL" \
         --user "$SMTP_USER:$SMTP_PASSWORD" \
         --upload-file "$EMAIL_CONTENT"

    # Cek status pengiriman
    if [ $? -eq 0 ]; then
        echo "Email notification sent to $EMAIL."
    else
        echo "Failed to send email notification."
    fi

    # Hapus file email sementara
    rm "$EMAIL_CONTENT"
else
    echo "Disk usage is under $THRESHOLD%. No action needed."
fi