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

## Creating AN IPA via GitHub actions
1. Take a manual path. Build the entire thing with the help of command line scripts. No magic happenning in background.
2. Use GitHub actions marketplace action. Provide the certificate password + provisioning and certificate using GitHub actions secrets. this GitHub action is using fastlane to build project and Generate IPA.

### Creating AN IPA with GitHub actions (Manaual Path)
The steps to create an IPA manually. invloves following steps.
1. Use the default `xcodebuild` command to create the archive and generate the IPA
2. Use a command line tool utility called `gpg` to encrypt your provisioning and certificate using standard AES256 encryption.
3. Commit the encrypted files above into your repo.
4. Install the gpg utility in the GitHub actions step.
5. Decrypt the files and set the provisioning profile + certificate before starting to build the project.
6. Build the project and generate the IPA

We create the gpg files by running commands like...
gpg --symmetric --cipher-algo AES256 RBiOSWildCardDev.mobileprovision
gpg --symmetric --cipher-algo AES256 AppleDevelopmentRBiOSWildCard.p12

The password on the P12 file is the same as the password used to perform the encryption. The password is also stored on Github as a secret in the env var PROVISIONING_PASSWORD.

### Creating AN IPA with GitHub actions (Prebuilt GitHub MarketPlace action)
The steps to create an IPA manually. invloves following steps.
1. Encode the provisioning profile and certificate into base64 format. using the commands below.
2. Set this base64 encoded strings + the certificate export password into GitHub actions secrets. 
3. Feed the required parameters into the GitHub actions. Note: the parameters need to be used with `""` (double quotes)

Tip: `ExportOptions.plist` is needed to generate the IPA. Many data points provided above was taken from the `ExportOptions.plist` file. Initially there is no such file. Generate the IPA using Xcode and then you can extract the `ExportOptions.plist` file from the IPA folder.


### Command to encode files from a given format to base64 string
#openssl base64 -in AppleDevelopmentRBiOSWildCard.p12 -A | tr -d '\n' > AppleDevelopmentRBiOSWildCard_base64.txt
#openssl base64 -in RBiOSWildCardDev.mobileprovision -A | tr -d '\n' > RBiOSWildCardDev_base64.txt

### Command the check if the file generate above was a success
#openssl base64 -A -d -in certificate_base64.txt -out certificate.p12