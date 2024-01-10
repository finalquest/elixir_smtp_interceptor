defmodule SmtpInterceptor.Handler do
  import Swoosh.Email
  alias SmtpInterceptor.Mailer
  @behaviour Pique.Behaviours.Handler

  def handle(data) when is_map(data) do 
    IO.inspect "DATA"
    IO.inspect extract_body(data)
    create_mail(data) |> Mailer.deliver() 
    {:ok, data}
  end

  def handle(email) when is_binary(email) do
    IO.inspect "EMAILLLL"
    IO.inspect email

    {:ok, email}
  end
  
   defp extract_body(%{body: body}) do
    IO.inspect "BODY"
    lines = String.split(body, "\r\n")
    blank_line_index = Enum.find_index(lines, &(&1 == ""))
    body_lines = Enum.slice(lines, blank_line_index + 1, length(lines))
    Enum.join(body_lines, "\r\n")
  end

  defp create_mail(email) do
    new()
    |> to({"pepe", "pepe@pepe.com"})
    |> from({"Dr B Banner", "hulk.smash@example.com"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello pepepepepe</h1>")
    |> text_body("Hello pepepepepep\n")
  end
end
