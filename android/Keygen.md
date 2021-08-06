
Test keys


```
keytool -genkeypair -v -noprompt \
           -storetype PKCS12 \
           -alias my-android-release-key \
           -keystore app/my-android-release-key.keystore \
           -keyalg RSA -keysize 2048 -validity 10000 \
           -storepass testpassword123 \
           -keypass testpassword123 \
           -dname "CN=nguoianphu.com, OU=NA, O=Company, L=HOCHIMINH, S=HOCHIMINH, C=VN"
           
keytool -export -rfc -v -noprompt \
   -storepass testpassword123 \
   -keypass testpassword123 \
   -keystore app/my-android-release-key.keystore \
   -alias my-android-release-key \
   -file app/my-android-release-upload-certificat.pem
   
```
