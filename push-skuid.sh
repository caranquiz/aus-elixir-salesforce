for line in `cat skuid-pages.txt`
do
    echo "$line"
    sfdx skuid:page:push skuidpages/"$line".json
done