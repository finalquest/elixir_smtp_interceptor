defmodule SmtpInterceptor.Handler do
  import Swoosh.Email
  alias SmtpInterceptor.Mailer
  @behaviour Pique.Behaviours.Handler

  def handle(data) when is_map(data) do 
    create_mail(data) |> Mailer.deliver() 
    {:ok, data}
  end

  def handle(email) when is_binary(email) do
    {:ok, email}
  end
  
   defp extract_body(%{body: body}) do
    lines = String.split(body, "\r\n")
    blank_line_index = Enum.find_index(lines, &(&1 == ""))
    body_lines = Enum.slice(lines, blank_line_index + 1, length(lines))
    Enum.join(body_lines, "\r\n")
  end

  defp create_mail(email) do
    body = extract_body(email)
    new()
    |> to(email.rcpt)
    |> from(email.from)
    |> subject("Hello, Avengers!")
    |> html_body(body)
    |> text_body(body)
  end
end
