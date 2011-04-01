# Class: mysql
#
# This class provides definitions to manage a mysql server and its databases
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql {

    class server {
        package { ["mysql", "mysql-server"]: ensure => latest }

        define grant($user, $password, $db, $host="localhost") {
            exec { "mysql_user_grant_$user_$db":
                path    => "/usr/bin:/usr/sbin:/bin",
                command => "mysql -uroot -e \"grant all privileges on $db.* to '$user'@'$host' identified by '$password'\"",
                unless  => "mysql -u$user -p$password -D$db -h$host",
                require => Service['mysqld'],
            }
        }

        define db($source) {
            exec { "mysql_schema_load_$name":
                path    => "/usr/bin:/usr/sbin:/bin",
                command => "mysql -uroot < $source",
                unless  => "mysql -uroot -e \"use $name\"",
                require => Service['mysqld'],
            }   
        }

        service { "mysqld":
            enable     => true,
            ensure     => running,
            hasrestart => true,
            hasstatus  => true,
            require    => Package['mysql-server', 'mysql'],
        }
    }
}
