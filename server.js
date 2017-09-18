var express = require('express');
var app = express();

app.use((req, res, next) => {
    res.header('Cache-Control', 'no-cache, must-revalidate');
    res.header('Pragma', 'no-cache');
    res.header('Expires', 'Sat, 26 Jul 1997 05:00:00 GMT');
    return next();
});
indexHandler = function(req, res) {
  return res.sendFile("./dist/index.html", { root: __dirname });
};
// app.get("/", indexHandler);
// app.get("/red", indexHandler);
// app.get("/green", indexHandler);
// app.get("/blue", indexHandler);
app.get("/modals", indexHandler);
app.get("/buttons", indexHandler);
// app.get("/termsofuse", indexHandler);
// app.get("/login", indexHandler);

app.use(express["static"](__dirname + "/dist"));
app.use((req, res) => res.status(404).send('404 not found'));
app.listen(3190, () => console.log('ocsw started at http://localhost:3190/'));
