# 各语言ssh工具
各语言的一个ssh工具的hello world，其中
1. python最简洁
1. js全方位异步化
1. java的那个工具貌似实现了最多的功能
### python fabric
[链接](http://www.fabfile.org/)
```python
from fabric import Connection
result = Connection('web1.example.com').run('uname -s', hide=True)
msg = "Ran {0.command!r} on {0.connection.host}, got stdout:\n{0.stdout}"
print(msg.format(result))
```
```
Ran 'uname -s' on web1.example.com, got stdout:
Linux
```
### node.js ssh2
[链接](https://github.com/mscdex/ssh2)
```js
var Client = require('ssh2').Client;

var conn = new Client();
conn.on('ready', function() {
  console.log('Client :: ready');
  conn.exec('uptime', function(err, stream) {
    if (err) throw err;
    stream.on('close', function(code, signal) {
      console.log('Stream :: close :: code: ' + code + ', signal: ' + signal);
      conn.end();
    }).on('data', function(data) {
      console.log('STDOUT: ' + data);
    }).stderr.on('data', function(data) {
      console.log('STDERR: ' + data);
    });
  });
}).connect({
  host: '192.168.100.100',
  port: 22,
  username: 'frylock',
  privateKey: require('fs').readFileSync('/here/is/my/key')
});
```
```
example output:
Client :: ready
STDOUT:  17:41:15 up 22 days, 18:09,  1 user,  load average: 0.00, 0.01, 0.05

Stream :: exit :: code: 0, signal: undefined
Stream :: close
```

### java sshj
[链接](https://github.com/hierynomus/sshj)
```java
package net.schmizz.sshj.examples;

import net.schmizz.sshj.SSHClient;
import net.schmizz.sshj.common.IOUtils;
import net.schmizz.sshj.connection.channel.direct.Session;
import net.schmizz.sshj.connection.channel.direct.Session.Command;

import java.io.Console;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

/** This examples demonstrates how a remote command can be executed. */
public class Exec {
    private static final Console con = System.console();

    public static void main(String... args)
            throws IOException {
        final SSHClient ssh = new SSHClient();
        ssh.loadKnownHosts();
        ssh.connect("localhost");
        Session session = null;
        try {
            ssh.authPublickey(System.getProperty("user.name"));
            session = ssh.startSession();
            final Command cmd = session.exec("ping -c 1 google.com");
            con.writer().print(IOUtils.readFully(cmd.getInputStream()).toString());
            cmd.join(5, TimeUnit.SECONDS);
            con.writer().print("\n** exit status: " + cmd.getExitStatus());
        } finally {
            try {
                if (session != null) {
                    session.close();
                }
            } catch (IOException e) {
                // Do Nothing   
            }
            ssh.disconnect();
        }
    }
}
```
### go ssh
[golang自带ssh工具包](https://godoc.org/golang.org/x/crypto/ssh)
```go
func SSHConnect( user, password, host string, port int ) ( *ssh.Session, error ) {
    var (
        auth         []ssh.AuthMethod
        addr         string
        clientConfig *ssh.ClientConfig
        client       *ssh.Client
        session      *ssh.Session
        err          error
    )
    // get auth method
    auth = make([]ssh.AuthMethod, 0)
    auth = append(auth, ssh.Password(password))

    hostKeyCallbk := func(hostname string, remote net.Addr, key ssh.PublicKey) error {
            return nil
    }

    clientConfig = &ssh.ClientConfig{
        User:               user,
        Auth:               auth,
        // Timeout:             30 * time.Second,
        HostKeyCallback:    hostKeyCallbk, 
    }

    // connet to ssh
    addr = fmt.Sprintf( "%s:%d", host, port )

    if client, err = ssh.Dial( "tcp", addr, clientConfig ); err != nil {
        return nil, err
    }

    // create session
    if session, err = client.NewSession(); err != nil {
        return nil, err
    }

    return session, nil
}

func runSsh(){

    var stdOut, stdErr bytes.Buffer

    session, err := SSHConnect( "username", "passworld", "192.168.1.4", 22 )
    if err != nil {
        log.Fatal(err)
    }
    defer session.Close()

    session.Stdout = &stdOut
    session.Stderr = &stdErr

    session.Run("if [ -d liujx/project ]; then echo 0; else echo 1; fi")
    ret, err := strconv.Atoi( str.Replace( stdOut.String(), "\n", "", -1 )  )
    if err != nil {
        panic(err)
    }

    fmt.Printf("%d, %s\n", ret, stdErr.String() )

}
```