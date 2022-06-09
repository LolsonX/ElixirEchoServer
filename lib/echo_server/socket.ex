defmodule EchoServer.Socket do
  @enforce_keys [:socket]
  defstruct [:socket, :ip, :port]
  @type t() :: %__MODULE__{
    socket: port() | {:"$inet", atom(), any},
    ip: String.t() | nil,
    port: String.t() | nil
  }

  @spec new(port | {:"$inet", atom, any}) :: EchoServer.Socket.t()
  def new(socket) do
    handle_socket(socket, :inet.peername(socket))
  end

  @spec get_socket_info(EchoServer.Socket.t) :: nonempty_binary()
  def get_socket_info(echo_socket) do
    "#{echo_socket.ip}:#{echo_socket.port}"
  end

  defp handle_socket(socket, {:error, _atom}) do
    %EchoServer.Socket{socket: socket}
  end

  defp handle_socket(socket, {:ok, {ip,port}}) do
    %EchoServer.Socket{socket: socket, ip: Tuple.to_list(ip) |> Enum.join("."), port: port}
  end
end
