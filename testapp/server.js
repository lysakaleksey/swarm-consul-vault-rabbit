'use strict';

const express = require('express');
const amqp = require('amqplib/callback_api');


// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();

app.get('/', (req, res) => {
  res.send('I am alive');
});

app.get('/send', (req, res) => {

  amqp.connect(process.env.AMQP_URL, function (err, conn) {
    if (err) {
      res.send('Error ' + err);
    } else {
      conn.createChannel(function (err, ch) {
        var q = 'hello';
        var msg = 'Hello World!';

        ch.assertQueue(q, {durable: true});
        ch.sendToQueue(q, Buffer.from(msg));

        setImmediate(function () {
          ch.close();
          conn.close();
        });

        res.send('Sent at ' + new Date());
      });
    }
  });

});


app.listen(PORT, HOST);

console.log('AMQP url is ' + process.env.AMQP_URL);
console.log(`Running on http://${HOST}:${PORT}`);