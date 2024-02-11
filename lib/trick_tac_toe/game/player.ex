defmodule TrickTacToe.Game.Player do
  @enforce_keys []
  defstruct [
    :name,
    :number,
    :marker,
    :wins,
    :losses
  ]

  @doc """
  Returns a new player struct
  """
  def new(name, number) do
    with(
      :ok <- validate_name(name),
      :ok <- validate_number(number)
    ) do
      %__MODULE__{
        name: name,
        number: number,
        marker: marker_from_number(number),
        wins: 0,
        losses: 0
      }
    end
  end

  defp validate_name(name) when not is_binary(name), do: {:error, "name must be a string"}
  defp validate_name(name) when byte_size(name) == 0, do: {:error, "name cannot be empty"}
  defp validate_name(_name), do: :ok

  defp validate_number(number) when number not in [1, 2], do: {:error, "invalid player number"}
  defp validate_number(_number), do: :ok

  defp marker_from_number(1), do: :x
  defp marker_from_number(2), do: :o
end
