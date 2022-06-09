# EchoServer

Simple echo server written in elixir. It can manage multiple clients at one time.

During creation i was heavily using [Elixir-lang.org tutorial](https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html)

# How to use
Start the project
```mix run --no-halt```
Go to terminal and try to connect with telnet
```telnet <ip> <port>```
To setup port use env variable
```PORT=<my_port> mix run --no-halt```

# Note
This is my first project written in Elixir