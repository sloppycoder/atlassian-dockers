docker pull postgres:9.3

cd java-base
#./build.sh
cd ..

cd atl-data
./build.sh
cd ..

cd atl-jira
./build.sh
cd ..

cd atl-stash
./build.sh
cd ..

cd atl-fisheye
./build.sh
cd ..

