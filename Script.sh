echo "Ready to clean the data? [1/0]"
read cleancontinue

if [ $cleancontinue -eq 1 ]
then
    echo "Cleaning Data"
    python dev/cleanse_data.py
    echo "Done Cleaning Data"
    dev_version=$(head -n 1 dev/changelog.md)
    prod_version=$(head -n 1 prod/changelog.md)
    read -a splitversion_dev <<< $dev_version
    read -a splitversion_prod <<< $prod_version
    dev_version=${splitversion_dev[1]}
    prod_version=${splitversion_prod[1]}
    if [ $prod_version != $dev_version ]
    then
        echo "New changes detected. Move dev files to prod? [1/0]"
        read scriptcontinue
    else
        scriptcontinue=0
    fi
else
    echo "Please come back when you are ready"
fi

if [ $scriptcontinue -eq 1 ]
then
    for filename in dev/*
    do
        if [ $filename == "dev/cademycode_cleansed.db" ] || [ $filename == "dev/cademycode_cleansed.csv" ] || [ $filename == "dev/changelog.md" ]
        then
            cp $filename prod
            echo "Copying " $filename
        else
            echo "Not Copying " $filename
        fi
    done
else
    echo "Please come back when you are ready"
fi