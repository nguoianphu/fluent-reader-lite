
Test keys


```
keytool -genkeypair -v -noprompt \
           -storetype PKCS12 \
           -alias my-android-release-key \
           -keystore my-android-release-key.keystore \
           -keyalg RSA -keysize 2048 -validity 10000 \
           -storepass testpassword123 \
           -keypass testpassword123 \
           -dname "CN=nguoianphu.com, OU=NA, O=Company, L=HOCHIMINH, S=HOCHIMINH, C=VN"

# why?
cp my-android-release-key.keystore app/

keytool -export -rfc -v -noprompt \
   -storepass testpassword123 \
   -keypass testpassword123 \
   -keystore my-android-release-key.keystore \
   -alias my-android-release-key \
   -file my-android-release-upload-certificat.pem
   
```
