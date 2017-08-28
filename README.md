# Hanoi DB Backup
## What does this do?
This bash script backups your database, and compresses it in a 6-tape tower of hanoi scheme.
This means at any one time you will have 6 copies of your db, ranging in data from yesterday to between 32-64 days ago

If you don't know what the Tower of Hanoi tape rotation scheme is:
https://en.wikipedia.org/wiki/Backup_rotation_scheme

Note: most likely you will need to install zip...will explore other compression options

## Instructions
1. Use the example.cnf file to create a configuration file for you db
2. End the name of the configuration file .conf (it's in the .gitignore)
3. Open hanoi.sh and set the hanoi_home and configuration location variables
4. Cron the script to run daily
5. Be satisfied that your data is now a little safer, and you have staggered snapshots

## Things to do:
1. Add all variables to conf file (hanoi home, db name, etc)
2. Options to backup different dbs (postgres, mysql)
3. Add option to choose how many tapes
4. Add table of coverage of each number of tapes
5. Figure out the formula to generate the list for infinite tapes so no need to pregenerate tape rotation arrays.
6. Add ways to send backups offsite (integrate with AWS S3?)
7. Give options for compression / no compression
