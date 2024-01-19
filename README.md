# SmtpInterceptor

Runs on Elixir, Phoenix, and LiveView. 
Utilizes Swoosh mailer to simulate an SMTP server, storing all received emails in memory.
The in-memory emails can be searched by recipient to preview their appearance. 
A basic alternative to web-based services like Mailinator.

## Docker run

  * should set the PHX_HOST and PHX_SECRET
  * docker run -p 4000:4000 -p 4646:4646 -e PHX_HOST=[host] -e SECRET_KEY_BASE=[long secret] ferbas/smtp_interceptor:0.0.1

## How to use

  * run the docker image
  * configure the client to point to the container host at the 4646 port.
  * go to the dashboard at http://[host]:4000
  * search by recipient
  
## out of scope for now.
  
  * the http server do not have https configuration for now.
