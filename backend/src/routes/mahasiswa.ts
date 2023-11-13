const expressRoutes = require('express')
const router = expressRoutes.Router()
const mahasiswa = require('../services/mahasiswa')

router.get('/', async function (req:any,res:any,next:any) {
    try {
        if(req.query.q == "null"){
            res.json(await mahasiswa.getMultiple(req.query.page))
        } else {
            res.json(await mahasiswa.search(req.query.q));
        }
   
    } catch (err: any){
        console.error(`Error while Getting Mahasiswa`, err.message);
    }
    
})

router.get('/:id/show', async function(req:any,res:any,next:any){
    try {
        res.json(await mahasiswa.show(req.params.id))
    } catch (err: any) {
        console.error(`Error while showing mahasiswa`, err.message)
    }
})

router.post('/', async function(req:any,res:any,next:any){
    try {
        res.json(await mahasiswa.create(req.body ));
    } catch (err:any) {
        console.error(`Error while creating mahasiswa`, err.message)
        next(err)
    }
})

router.put('/:id',async function(req:any,res:any,next:any){
    try {
        res.json(await mahasiswa.update(req.params.id,req.body));
    } catch (err:any){
        console.error(`Error while updating mahasiswa`, err.message)
        next(err)
    }
})

router.get('/search', async function(req:any,res:any,next:any){
     const searchQuery = req.query.q
     try {
        res.json(await mahasiswa.search(req.query.q));
     } catch (err:any) {
        console.error(`Error while search mahasiswa`, err.message)
        next(err)
     }
});

router.delete('/:id', async function(req:any,res:any,next:any){
    try {
        res.json(await mahasiswa.destroy(req.params.id));
    } catch (err:any) {
        console.error(`Error while deleting mahasiswa`, err.message)
        next(err)
    }
})

module.exports = router;