#bin/bash

#on determine la date des dossiers a deplacer

echo -e '                    ENTER THE DATE OF THE EOD FOLDER TO COPY'
read -p ' Enter the Year:' year 
echo -e "\n"  
read -p ' Enter the Month:' month  
echo -e "\n" 
read -p ' Enter the Day:' day
echo -e "\n"
 
echo -e "\n         THE EOD FOLDERS TO COPY HAVE THE PREVIOUS DATE $year-$month-$day"
echo -e "\n"

#creation des repertoire a copier

date="$year-$month-$day"
mkdir -p /home/obiee/oracle/products/"$date"/{branch_report,consolidated_report}/010
mkdir -p /home/obiee/oracle/products/"$date"/branch_report/{020,021,022,023,024,030,031,032,040,041,042,043,050,051}


#preparation des transferts
cp -r  /home/obiee/oracle/products/Temp/Generation/OUT/010/"$date"/*.xls /home/obiee/oracle/products/"$date"/consolidated_report/010
  
cp -r  /home/obiee/oracle/products/Generation/OUT/010/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/010
cp -r  /home/obiee/oracle/products/Generation/OUT/020/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/020
cp -r  /home/obiee/oracle/products/Generation/OUT/021/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/021
cp -r  /home/obiee/oracle/products/Generation/OUT/022/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/022
cp -r  /home/obiee/oracle/products/Generation/OUT/023/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/023
cp -r  /home/obiee/oracle/products/Generation/OUT/024/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/024
cp -r  /home/obiee/oracle/products/Generation/OUT/030/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/030
cp -r  /home/obiee/oracle/products/Generation/OUT/031/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/031
cp -r  /home/obiee/oracle/products/Generation/OUT/032/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/032
cp -r  /home/obiee/oracle/products/Generation/OUT/040/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/040
cp -r  /home/obiee/oracle/products/Generation/OUT/041/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/041
cp -r  /home/obiee/oracle/products/Generation/OUT/042/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/042
cp -r  /home/obiee/oracle/products/Generation/OUT/043/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/043
cp -r  /home/obiee/oracle/products/Generation/OUT/050/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/050
cp -r  /home/obiee/oracle/products/Generation/OUT/051/"$date"/*.xls /home/obiee/oracle/products/"$date"/branch_report/051

echo '                 EOD REPORT FOLDER READY TO MOVE INTO FTP '

lftp  172.20.50.22 << EOT
user eod Nfc*123
mirror -R  /home/obiee/oracle/products/"$date"
quit
EOT 

echo '                                  EOD REPORTS COPIED TO FTP '







