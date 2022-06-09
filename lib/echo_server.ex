defmodule EchoServer do
  require Logger

  @spec accept(char) :: no_return
  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(EchoServer.Socket.new(socket))
  end

  @spec loop_acceptor(EchoServer.Socket.t) :: no_return
  defp loop_acceptor(echo_socket) do
    {:ok, client} = :gen_tcp.accept(echo_socket.socket)
    {:ok, pid} = Task.Supervisor.start_child(EchoServer.TaskSupervisor, fn -> serve(EchoServer.Socket.new(client)) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(echo_socket)
  end

  @spec serve(EchoServer.Socket.t) :: no_return
  defp serve(echo_socket) do
    handle_connection(echo_socket, read_line(echo_socket))
  end

  @spec handle_connection(EchoServer.Socket.t, {:ok, binary}) :: no_return()
  defp handle_connection(echo_socket, {:ok, msg}) do
    Logger.info("Writing message")
    write_line(msg, echo_socket)
    serve(echo_socket)
  end

  @spec handle_connection(EchoServer.Socket.t, {:error, binary}) :: no_return()
  defp handle_connection(_socket, {:error, _reason}) do
    Logger.info("Error")
  end

  @spec read_line(EchoServer.Socket.t) :: {:error, atom()} | {:ok, any}
  defp read_line(echo_socket) do
    :gen_tcp.recv(echo_socket.socket, 0)
  end

  @spec write_line(nonempty_binary, EchoServer.Socket.t) :: no_return()
  defp write_line(line, echo_socket) do
    :gen_tcp.send(echo_socket.socket, line)
  end
end
