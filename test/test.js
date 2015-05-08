var assert = require("assert");
var pg     = require("pg");

var conString = process.env.DATABASE_URL;

describe('PostgreSQL test', function(){
  it("should connect to pg", function(done) {
    pg.connect(conString, function(err, client) {
      assert.equal(err, null);
      client.query('SELECT $1::int AS number', ['1'], function(err, result) {
        assert.equal(err, null);
        assert.equal(result.rows[0].number, 1);
        client.end();
        done();
      });
    });
  });
});
