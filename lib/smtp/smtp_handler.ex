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
    subject = lines |> Enum.find(fn line -> String.starts_with?(line, "Subject: ") end)
                  |> (fn line -> String.replace(line, "Subject: ", "") end).()
    blank_line_index = Enum.find_index(lines, &(&1 == ""))
    body_lines = Enum.slice(lines, blank_line_index + 1, length(lines))
    body = Enum.join(body_lines, "\r\n")
    %{subject: subject, body: body}
  end

  defp create_mail(email) do
    %{body: body, subject: subject} = extract_body(email)
    IO.inspect(body)
     fake_body = "<!doctype html>\n<html>\n <head> \n  <meta http-equiv=\"Content-Type\" content=\"text/html\" charset=\"UTF-8\"> \n  <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\"> \n  <title>Document</title> \n  <link href=\"https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500&amp;display=swap\" rel=\"stylesheet\"> \n  <link href=\"https://fonts.googleapis.com/css2?family=Montserrat:wght@700&amp;display=swap\" rel=\"stylesheet\"> \n  <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css\"> \n  <style>\r\n            * {\r\n                margin: 0;\r\n                border: 0;\r\n                padding: 0;\r\n                font-family: \"Montserrat\", sans-serif;\r\n                box-sizing: border-box;\r\n                text-decoration: none;\r\n            }\r\n\r\n            .ExternalClass {\r\n                width: 100%;\r\n            }\r\n\r\n            h1 {\r\n                font-size: 32px;\r\n            }\r\n\r\n            span,\r\n            b {\r\n                font-size: 20px;\r\n            }\r\n\r\n            p {\r\n                font-size: 16px;\r\n            }\r\n\r\n            span,\r\n            h1,\r\n            b {\r\n                color: #035177;\r\n            }\r\n\r\n            @media (max-width: 480px) {\r\n                .inline-images {\r\n                    display: none !important;\r\n                }\r\n\r\n                .small-screen-images {\r\n                    display: table-row !important;\r\n                    width: 100% !important;\r\n                }\r\n            }\r\n\r\n        </style> \n </head> \n <body> \n  <div id=\"body\" style=\"background-color: #eee; height: 100%; font-weight: 500; color: #035177;\"> \n   <table class=\"main-table\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"margin: 0 auto; max-width: 600px;\"> \n    <thead> \n     <tr> \n      <td><img class=\"head-img\" src=\"https://www.nbch.com.ar/Portals/0/Images/banner-superior.v1.png\" alt=\"NBCH 24 Tu banco siempre con vos\" style=\"width: 100%;\"></td> \n     </tr> \n    </thead> \n    <tbody style=\"background: white;\"> \n     <tr> \n      <td class=\"td-tbody\" style=\"display: block; width: 80%; margin: auto; padding: 60px 0 0; text-align: center;\"> <p style=\"line-height: 1.4;\">Tu código de verificación es:</p> <h2 id=\"verify-code\" style=\"text-decoration: none; font-size: 48px; font-weight: 700; cursor: default; margin-top: 10px;\" href=\"#\">351236</h2> \n       <hr style=\"background-color: #a9c9be; height: 2px; width: 70%; margin: auto; margin-top: 10px; margin-bottom: 20px;\"> <p style=\"line-height: 1.4; margin-bottom: 20px; max-width: 456px;\">Este código dura 60 segundos deberás ingresarlo para confirmar tu operación en la plataforma Online Banking.</p> <p style=\"line-height: 1.4; margin-bottom: 48px;\">Es un resguardo para tu cuenta y tus transacciones.</p> <p class=\"content--contact-info\" style=\"margin-top: 30px; margin-bottom: 15px; color: #474747; font-size: 14px; font-weight: 400; line-height: 1.4; text-align: center;\"><a href=\"tel:08009996224\" style=\"color: #545454\"> <b style=\"font-size: 16px\">0800-999-6224 </b></a>| WhatsApp: <a href=\"https://www.mailinator.com/linker?linkid=05e36e63-46ec-4177-bb5d-821a3673f895\" style=\"color: #545454\" target=\"_blank\"> <b style=\"font-size: 16px\">+54 9 (362) 416 - 1290</b></a></p> </td> \n     </tr> \n    </tbody> \n    <tfoot style=\"width: 100%; background-image: url('https://www.nbch.com.ar/Portals/0/Images/banner-inferior-sin-logos.v1.png'); background-repeat: no-repeat; background-size: cover; display: table; padding: 30px 0; width: 100%;\"> \n     <tr class=\"inline-images\"> \n      <td style=\"display: table-cell; text-align: center; min-width: 100px;\"><img style=\"max-width: 105px; width: 100%; margin: 0 auto;\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch24-online-banking.v1.png\" alt=\"NBCH 24 online banking\"></td> \n      <td style=\"display: table-cell; text-align: center; min-width: 100px;\"><img style=\"max-width: 105px; width: 100%; margin: 0 auto;\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch24-billetera.v1.png\" alt=\"NBCH 24 billetera\"></td> \n      <td style=\"display: table-cell; text-align: center; min-width: 100px;\"><img style=\"max-width: 230px\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch.v1.png\" alt=\"Nuevo Banco del Chaco\"></td> \n     </tr> \n     <tr class=\"small-screen-images\" style=\"display: none;\"> \n      <td style=\"width: 50%; display: table-cell; text-align: center; min-width: 100px;\"><img style=\"max-width: 105px; width: 100%; margin: 0 auto;\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch24-online-banking.v1.png\" alt=\"NBCH 24 online banking\"></td> \n      <td style=\"width: 50%; display: table-cell; text-align: center; min-width: 100px;\"><img style=\"max-width: 105px; width: 100%; margin: 0 auto;\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch24-billetera.v1.png\" alt=\"NBCH 24 billetera\"></td> \n     </tr> \n     <tr class=\"small-screen-images\" style=\"height: 10px\"> \n      <td style=\"display: table-cell; text-align: center; min-width: 100px;\"></td> \n     </tr> \n     <tr class=\"small-screen-images\" style=\"display: none;\"> \n      <td style=\"margin: 0 auto; display: table-cell; text-align: center; min-width: 100px;\" colspan=\"2\"><img style=\"max-width: 230px; width: 100%; margin: 0 auto;\" src=\"https://www.nbch.com.ar/Portals/0/Images/logo-nbch.v1.png\" alt=\"Nuevo Banco del Chaco\"></td> \n     </tr> \n    </tfoot> \n   </table> \n  </div>  \n </body>\n</html>"

    new()
    |> to(email.rcpt)
    |> from(email.from)
    |> subject(subject)
    |> html_body(fake_body)
    |> text_body(body)
  end
end
