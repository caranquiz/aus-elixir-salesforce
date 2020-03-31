count=1
replaceString=""
for line in `cat skuid-pages.txt`
do
pullFileName="${line/ngUi_/$replaceString}"
echo "$pullFileName"
sfdx skuid:page:pull --page "$pullFileName"
Done