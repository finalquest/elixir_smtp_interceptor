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
  
  defp parse_mail(%{body: body}) do 
    lines = String.split(body, "\r\n")
    subject = extract_subject(lines)
    body = extract_body(body)
    %{subject: subject, body: body}
  end
  
  defp extract_body(string_body) do
    
    case has_mime(string_body) do
      true -> extract_mime_body(string_body)
      false -> extract_simple_body(string_body)
    end
    
  end

  defp extract_simple_body(body) do
    lines = String.split(body, "\r\n")
    blank_line_index = Enum.find_index(lines, &(&1 == ""))
    body_lines = Enum.slice(lines, blank_line_index + 1, length(lines))
    new_body = Enum.join(body_lines, "\r\n")
    %{plain_text: new_body, html_text: new_body}
    
  end

  defp extract_mime_body(body) do
    # Find the boundary string in the headers
    boundary = body
             |> String.split("\r\n")
             |> Enum.find(fn line -> String.contains?(line, "boundary=") end)
             |> (fn line -> 
                   line 
                   |> String.split("boundary=")
                   |> List.last()
                   |> String.trim_leading("\"")
                   |> String.trim_trailing("\"") 
                end).()

    # Split the body into parts using the boundary
    parts = String.split(body, "--" <> boundary)

    # Initialize variables for plain text and HTML content
    plain_text = extract_part_content(parts, "text/plain") 
    html_text = extract_part_content(parts, "text/html")
    
    # Iterate through each part to find plain text and HTML content

    %{plain_text: plain_text, html_text: html_text}
  end

  defp has_mime(body) do
    String.contains?(body, "Content-Type: multipart/")
  end

  defp extract_part_content(parts, content_type) do
    parts
    |> Enum.find(fn part -> String.contains?(part, "Content-Type: " <> content_type) end)
    |> extract_content()
    |> SmtpInterceptor.QuotedPrintable.decode()
  end

  def extract_content(part) do
    part
      |> String.split("\r\n\r\n", parts: 2)
      |> List.last()
  end


  defp extract_subject(lines) do
    lines |> Enum.find(fn line -> String.starts_with?(line, "Subject: ") end)
          |> (fn line -> String.replace(line, "Subject: ", "") end).()
  end

  defp create_mail(email) do
    %{body: %{plain_text: plain, html_text: html}, subject: subject} = parse_mail(email)
    new()
    |> to(email.rcpt)
    |> from(email.from)
    |> subject(subject)
    |> html_body(html)
    |> text_body(plain)
  end
end
