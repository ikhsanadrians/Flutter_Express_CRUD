const mysql = require('mysql2/promise')
const configsql = require('../config')

async function query(sql:any,params:any){
    const connection = await mysql.createConnection(configsql.db);
    const [results, ] = await connection.execute(sql, params);
  
    return results;
}

module.exports = {
    query
}