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

  amqp.connect(process.env.SEND_URL, function (err, conn) {
    if (err) {
      res.send('Connect errors ' + err);
    } else {
      conn.createChannel(function (err, ch) {

        ch.sendToQueue(process.env.QUEUE, Buffer.from('Hello World!'));

        setImmediate(function () {
          ch.close();
          conn.close();
        });

        res.send('Sent at ' + new Date());
      });
    }
  });

});

app.get('/get', (req, res) => {

  amqp.connect(process.env.GET_URL, function (err, conn) {
    if (err) {
      res.send('Connect error ' + err);
    } else {
      conn.createChannel(function (err, ch) {
        if (err) {
          console.log('get createChannel err ' + err);
        }

        ch.get(process.env.QUEUE, {}, function (err, msg) {
          if (err) {
            res.send('Get error ' + err);
          } else if (msg) {
            res.send('Received ' + msg.content.toString());
            ch.ack(msg);
          } else {
            res.send('No data found');
          }

          setImmediate(function () {
            ch.close();
            conn.close();
          });

        });

      });
    }
  });

});


app.listen(PORT, HOST);

console.log(`Running on http://${HOST}:${PORT}`);