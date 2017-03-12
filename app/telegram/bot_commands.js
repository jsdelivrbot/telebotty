/**
 * Botcommands Helper class
 * 
 * @param {any} database 
 * @param {any} web 
 * @param {any} settings 
 * @param {any} bot 
 */
function Commands(database, web, settings, bot) {
    var Path = require('path'),
        path = Path.join(__dirname, 'commands'),
        utils = require('../app/utils');

    if (database === null && settings.telegram.debug) {
        console.log('[TG]', 'no database present. this could lead to errors if bot needs to access to a database.');
    }
    // load all commands
    var commands = utils.requireDir(path);
    for (var i in commands) {
        commands[i](database, web, settings, bot);
    }

    if (settings.telegram.debug) {
        console.log('[TG]', 'all commands loaded.');
    }
}

module.exports = Commands;