args=("$@")

if [ $# != "1" ]
then
    echo "Usage: ./start.sh [path_to_env_file]"
    exit
fi

set -o allexport
. ${args[0]}
set +o allexport

rm -rf build
mkdir build

go build -o template-compiler

#create dirs
DIRS=$(find configs -type d)
for DIR in $DIRS
do
    echo $DIR | sed "s/^configs/build/g" | xargs mkdir -p
done
FILES=$(find configs -type f)
for FILE in $FILES
do
    NEW_FILENAME=$(echo $FILE | sed "s/^configs/build/g")
    if echo $FILE | grep -q ".tmpl$"; then
        NEW_FILENAME=$(echo $NEW_FILENAME | sed "s/.tmpl$//g")
        ./template-compiler compile $FILE > $NEW_FILENAME
    else 
        cp $FILE $NEW_FILENAME
    fi
done