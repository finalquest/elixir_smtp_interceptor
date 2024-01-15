defmodule SmtpInterceptor.QuotedPrintable do
  @moduledoc """
  Encodes/decodes quoted-printable strings according to RFC 2045.

  See the following links for reference:
  - <https://tools.ietf.org/html/rfc2045#section-6.7>
  """

  @doc """
  Decodes a quoted-printable encoded string.

  ## Examples

      Mail.Quot
      "façade"
  """
  @spec decode(binary) :: binary
  def decode(string, acc \\ [])

  def decode(<<>>, acc) do
    acc
    |> Enum.reverse()
    |> Enum.join()
  end

  def decode(<<?=, ?\r, ?\n, tail::binary>>, acc) do
    decode(tail, acc)
  end

  def decode(<<?=, chars::binary-size(2), tail::binary>>, acc) do
    case Base.decode16(chars, case: :mixed) do
      {:ok, decoded} -> decode(tail, [decoded | acc])
      :error -> decode(tail, [chars, "=" | acc])
    end
  end

  def decode(<<char::binary-size(1), tail::binary>>, acc) do
    decode(tail, [char | acc])
  end
end
