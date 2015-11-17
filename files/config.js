// # Ghost Configuration
var path = require('path'),
    config;
var ghostStorage = process.env.GHOST_STORAGE || 'sqlite3';

config = {
    // ### Production
    production: {
        url: 'http://'+( process.env.GHOST_HOST || 'localhost' ),
        compress: false, // nginx will do the gzip'ing for us
        mail: {},
        database: {
            client: ghostStorage,
            connection: {},
            debug: false
        },

        // run on localhost - nginx will take care of presenting us to the
        // outside world
        server: {
            host: '127.0.0.1',
            port: '2368'
        },

        paths: {
          contentPath: process.env.GHOST_CONTENT
        }
    }
};

// we presently only support SQLite or MySQL from the command line
if (ghostStorage == 'sqlite3') {
  config.production.database.connection = {
    filename: path.join(process.env.GHOST_CONTENT || __dirname, '/data/ghost.db')
  };
} else if (ghostStorage == 'mysql') {
  config.production.database.connection = {
    host     : process.env.GHOST_MYSQL_HOST     || 'localhost',
    port     : process.env.GHOST_MYSQL_PORT     || 3306,
    database : process.env.GHOST_MYSQL_DATABASE || 'ghost',
    user     : process.env.GHOST_MYSQL_USER     || 'ghost',
    password : process.env.GHOST_MYSQL_PASSWORD || 'ghost',
    charset  : process.env.GHOST_MYSQL_CHARSET  || 'utf8'
  };
}

module.exports = config;
