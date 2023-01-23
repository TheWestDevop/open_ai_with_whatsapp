defmodule WhatsAppClient.VerifyToken do
  @type t :: %__MODULE__{
          token: String.t(),
          mode: String.t()
        }
  defstruct [:mode, :token]

  @spec call(%__MODULE__{}) :: :ok | {:error, :forbidden}
  def call(%__MODULE__{} = command) do
    with true <- is_binary(command.mode),
         true <- is_binary(command.token),
         false <- is_empty?(command.mode),
         false <- is_empty?(command.token),
         :ok <- is_token_valid(command.mode, command.token) do
      :ok
    else
      _any_error -> {:error, :forbidden}
    end
  end

  def call(_), do: {:error, "wrong command"}

  @spec is_token_valid(String.t(), String.t()) :: :ok | :error
  defp is_token_valid(mode, token) do
    key = verify_token()

    if mode === "subscribe" && token === key do
      :ok
    else
      :error
    end
  end

  defp is_empty?(nil), do: true
  defp is_empty?(val), do: val |> String.trim() |> String.length() === 0

  defp verify_token, do: Application.get_env(:whatsapp_client, :verification_token)
end
