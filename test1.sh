version_gui=$(awk '/monero-gui-source-v/ {print $2}' monero-site/downloads/hashes.txt | awk -F".tar.bz2" '{print $1}' | awk -F"-" '{print $4}')
version_cli=$(awk '/monero-source-v/ {print $2}' monero-site/downloads/hashes.txt | awk -F".tar.bz2" '{print $1}' | awk -F"-" '{print $3}')
echo -e "\n--> GUI version: $version_gui \n--> CLI version: $version_cli"
mkdir validate_sources
cd validate_sources
# Download / verify git-archive-all.sh
curl -O https://raw.githubusercontent.com/fabacab/git-archive-all.sh/master/git-archive-all.sh
echo "db62e9a824866989c9d080f008ec06d81421cf94bed3762acba3b9148607af2d git-archive-all.sh" | sha256sum -c
chmod +x git-archive-all.sh
echo -e "--> Generating tarballs..."
#-----------------------------------
# clone a different branch
#-----------------------------------
version_gui=v0.17.3.0
# CLI
git clone --recursive -b $version_cli --depth 1 --shallow-submodule https://github.com/monero-project/monero.git monero.git && cd monero.git && ../git-archive-all.sh --prefix monero-source-${version_cli}/ --format tar --tree-ish $version_cli ../monero-source-${version_cli}.tar && cd .. && bzip2 monero-source-${version_cli}.tar
# GUI
git clone --recursive -b $version_gui --depth 1 --shallow-submodule https://github.com/monero-project/monero-gui.git monero-gui.git && cd monero-gui.git && ../git-archive-all.sh --prefix monero-gui-source-${version_gui}/ --format tar --tree-ish $version_gui ../monero-gui-source-${version_gui}.tar && cd .. && bzip2 monero-gui-source-${version_gui}.tar
mkdir yours
#-----------------------------------
# Copy and rename the sus imposter to latest version / rename it to the latest
#-----------------------------------
cp monero-gui-source-${version_gui}.tar.bz2 yours/monero-gui-source-v0.17.3.2.tar.bz2
version_gui=v0.17.3.2

cp monero-source-${version_cli}.tar.bz2 yours/.

mkdir from_website
echo -e "\n--> Move tarballs from getmonero..."
cd from_website
wget dlsrc.getmonero.org/gui/monero-gui-source-${version_gui}.tar.bz2
wget dlsrc.getmonero.org/cli/monero-source-${version_cli}.tar.bz2
cd ..
echo -e "\n--> Unpacking all..."
bunzip2 yours/*.bz2 
bunzip2 from_website/*.bz2
tar xf yours/monero-source-${version_cli}.tar -C yours/
tar xf yours/monero-gui-source-${version_gui}.tar -C yours/
tar xf from_website/monero-source-${version_cli}.tar -C from_website/
tar xf from_website/monero-gui-source-${version_gui}.tar -C from_website
# Compare directories
echo -e "\n--> Comparing CLI directories"
diff -r yours/monero-source-$version_cli from_website/monero-source-$version_cli
echo -e "\n--> Comparing GUI directories"
#-----------------------------------
# rename the sus imposters extracted dir name to the latest version
#-----------------------------------
mv yours/monero-gui-source-v0.17.3.0 yours/monero-gui-source-${version_gui}
diff -r yours/monero-gui-source-$version_gui from_website/monero-gui-source-$version_gui
