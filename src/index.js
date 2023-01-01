const http = require('http');
const port = process.env.PORT;
const message = process.env.MESSAGE;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  const msg = message
  res.end(msg);
});

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
})