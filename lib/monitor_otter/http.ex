defmodule MonitorOtter.Http do
  @moduledoc """
  Module for HTTP access to pages.
  """

  @doc """
  Fetch page content.

  Returns `{:ok, content}` or `{:error, reason}`.
  """
  def fetch(url) do
    case HTTPoison.get(url) do
      {:ok, response} -> {:ok, response.body}
      error -> error
    end
  end
end
