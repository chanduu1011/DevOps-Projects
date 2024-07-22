

const express = require('express');

const app = express();
app.get("/",(req,res) =>{
    res.send("Service is up and running")
});
app.listen(8090, () =>{
    console.log("server is up");
});