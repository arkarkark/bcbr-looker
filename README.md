# bcbr-looker
Looker files for BC Bike Race 2016


```bash
brew install mysql
mysql.server.start

cp bcbr.config.example ~/.bcbr.config
# maybe you want to edit ~/.bcbr.config now?
mysqladmin -u root create bcbr
mysql -u root
```

Then run these commands (you might want to change the password (and in ~/.bcbr.config too):
```sql
CREATE USER 'bcbr'@'localhost' IDENTIFIED BY 'bcbr';
GRANT ALL PRIVILEGES ON bcbr.* TO 'bcbr'@'localhost' WITH GRANT OPTION;
```

Once the database is made you can then create the database using bcbr.sql
(since .bcbr.config is in inifile format you can use --defaults-file) and then load your data:
```bash
mysql --defaults-file=~/.bcbr.config < bcbr.sql
# did that work?
mysql --defaults-file=~/.bcbr.config <<< 'SHOW TABLES'
# load it
./bcbrloader.py
# verify it works
mysql --defaults-file=~/.bcbr.config -E <<< 'SELECT COUNT(*) AS num_tracks FROM tracks; SELECT COUNT(*) AS num_playlisys FROM playlists;' | fgrep -v '*****'
```
