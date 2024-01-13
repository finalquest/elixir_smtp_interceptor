defmodule SmtpInterceptor.Mailer do
  use Swoosh.Mailer, otp_app: :smtp_interceptor
  alias Swoosh.Adapters.Local.Storage.Memory

  def search_by_account(account) do 
    Memory.all() 
      |> filter_by_account(account) 
      |> to_list(account) 
  end
  
  defp filter_by_account(mails, account) do
    Enum.filter(mails, fn mail -> 
      Enum.any?(mail.to, fn {_name, email} -> email == account end)
    end)
  end

  defp to_list(mails, account) do
    Enum.map(mails, fn mail -> 
      {_from, from_address} = mail.from
      %{"Message-ID"=> id} = mail.headers
      %{
        id: id,
        from: from_address,
        to: account,
        subject: mail.subject,
        # body: mail.body
      }
    end)
  end
end

