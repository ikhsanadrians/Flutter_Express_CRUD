const db = require('./db');
const helper = require('../helper');
const dbConfig = require('../config');

async function getMultiple(page = 1){
    const offset = helper.getOffset(page,dbConfig.listPerPage);
    const rows = await db.query(
        `SELECT * FROM mahasiswa ORDER BY id DESC`
    );

    const data = helper.emptyOrRows(rows);
    const meta = {page};

    return {
        data,
        meta
    }
}

async function create(query:any){
     const result = await db.query(
        `INSERT into mahasiswa (name,address,phone_number,photo) VALUES ('${query.name}', '${query.address}' , '${query.phone_number}' , '${query.photo}')`);

     let message = 'Error While Creating Mahasiswa'

     if(result.affectedRows) message = 'mahasiswa created successfully'

     return {message}
}

async function show(id:string){
     const result = await db.query(
        `SELECT * from mahasiswa where id='${id}'`
     )
     
     let message = ''
     
     if(!result || result.length === 0) message = `mahasiswa with id: ${id} not found!`
     
     let data = result

     if(result.length > 0) message = 'succcess! get mahasiswa detail'

     return {
        message,
        data
     }
   }

   async function search(query: any) {
      const result = await db.query(
        `SELECT * FROM mahasiswa WHERE name LIKE '%${query}%'`
      );
    
      let message = 'Error while getting mahasiswa';
    
      if(!result || result.length === 0) message = `mahasiswa with name: ${query} not found!`
    
      if(result.length >= 1) message = `success! found mahasiswa `

      const data = result;
    
      return {
        message,
        data,
      };
    }
    


async function update(id:string,query:any){
   const result = await db.query(
     `UPDATE mahasiswa SET name = '${query.name}' , address = '${query.address}' , phone_number = '${query.phone_number}' , photo = '${query.photo}' WHERE id = ${id}`
   )
   let message = 'Error while Creating Mahasiswa'

   if(result.affectedRows) message = 'mahasiswa updated successfully'

   return {message}
}


async function destroy(id:string){
     const result = await db.query(
        `DELETE from mahasiswa WHERE id='${id}'`
     );

     let message = 'Error while deleting mahasiswa';

     if (result.affectedRows) {
       message = 'mahasiswa deleted successfully';
     }
   
     return {message};
}





module.exports = {
    getMultiple,
    create,
    update,
    show,
    search,
    destroy
}