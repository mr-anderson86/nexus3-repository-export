# Nexus 3 Repository Export

## Description:
This repository contains a script which downloads a full Nexus 3 repository into the current dir you are on your Linux session.  

### Tested on:
* Linux CentOS 7
* Maven repository  
(Might work on other Linux distributions, and probably will work also for NPM and other repos, but can't promise that)

### Dependencies:
* You need to have lftp in order to make this script work:
```bash
sudo yum install lftp -y
```

### Repository main files:
* downloadNexus3Artifacts.sh - take a guess what it does ;-)

## Usage:

### Running on Linux session:
```bash
git clone https://github.com/mr-anderson86/nexus3-repository-export.git
cd nexus3-repository-export
./downloadNexus3Artifacts.sh <your nexus address> <your nexus repo>

#Example:
# ./downloadNexus3Artifacts.sh http://nexus.example.com:8081 my-maven-repo
```

Then you will see all the artifacts downloaded to your current location, exactly with the same hierarchy as it saved in the Nexus repo.

## Other ideas:
If you want, from this location you could upload all artifacts to a new Nexus3 server, or even into an Artifactory server as well, using script from below:  
https://github.com/sonatype-nexus-community/nexus-repository-import-scripts  
(Super kick ass script!! Thanks to whoever wrote it!! :-))

### The end, enjoy :)
