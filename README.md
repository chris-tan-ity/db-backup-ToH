# Hanoi DB Backup
## Instructions
1. Use the example.cnf file to create a configuration file for you db
2. Open hanoi.sh and set the hanoi_home and configuration location variables
3. Cron the script to run daily
4. Be satisfied that your data is now a little safer, and you have staggered snapshots


## Things to do:
1. Add all variables to conf file (hanoi home, db name, etc)
2. Options to backup different dbs (postgres, mysql)
3. Add option to choose how many tapes
4. Add table of coverage of each number of tapes
5. Figure out the formula to generate the list for infinite tapes so no need to pregenerate tape rotation arrays.
6. Add ways to send backups offsite (integrate with AWS S3?)
