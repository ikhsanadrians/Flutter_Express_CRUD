const express = require('express')
const app = express()
const port = 3002
const mahasiswaRouter = require('./routes/mahasiswa');

app.use(express.json())


app.use(
    express.urlencoded({
        extended: true,
    })
);

app.get('/',(req : any ,res : any) => {
    const message: { message: string } = { message: "ok" };
    res.json(message)
})

app.use('/mahasiswa',mahasiswaRouter)


app.listen(port, () => {
    console.log(`app listening at http://localhost:${port}`);
})