# SampleJokes
A repository to demonstrate the classic use case of migrating from gcd and closure or delegate based approach to modern concurrency and combine based approach

## Sample project details
In this project we call an API every 1 min, the API call returns a string and the table view is updated accordingly. The curx of this project is to demo a pr where we can migrate existing delegate and closure based approach to modern concurrency based syntax.

### Assumptions:
1. As long the project is in foreground the ticker will keep running.
2. Project going back ground and foregorund secnario is ignored for now.
3. The scope of this project is having a constant stream of jokes coming from the joke API

### Note:
Please head to the pr section and see the work in details.

### Usage:
1. Xcode 14+
2. Async Await
3. UIKit
4. Architecture: MVVM
5. iOS 13+


## Feature
1. Every minute fetches a joke from an open API
2. Adds a new joke to a list at the end
3. Displays the list of the jokes with size of 10
4. A new jokes replace old ones
5. Relaunching the app all loaded jokes should be displayed
6. TableViewCell done using code only in autolayout

## Icing on the cake
1. docc documentation
2. GitHub secrets demo


We create the gpg files by running commands like...

gpg --symmetric --cipher-algo AES256 RBiOSWildCardDev.mobileprovision
gpg --symmetric --cipher-algo AES256 AppleDevelopmentRBiOSWildCard.p12

The password on the P12 file is the same as the password used to perform the encryption. The password is also stored on Github as a secret in the env var PROVISIONING_PASSWORD.


# Encode
#openssl base64 -in AppleDevelopmentRBiOSWildCard.p12 -A | tr -d '\n' > AppleDevelopmentRBiOSWildCard_base64.txt
#openssl base64 -in RBiOSWildCardDev.mobileprovision -A | tr -d '\n' > RBiOSWildCardDev_base64.txt

# Decode
#openssl base64 -A -d -in certificate_base64.txt -out certificate.p12