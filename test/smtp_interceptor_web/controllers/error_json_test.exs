defmodule SmtpInterceptorWeb.ErrorJSONTest do
  use SmtpInterceptorWeb.ConnCase, async: true

  test "renders 404" do
    assert SmtpInterceptorWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SmtpInterceptorWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
