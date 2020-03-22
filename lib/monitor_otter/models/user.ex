defmodule MonitorOtter.Models.User do
  @moduledoc """
  User model.
  """
  use Ecto.Schema

  import Ecto.Changeset,
    only: [
      change: 2,
      cast: 3,
      validate_required: 2,
      validate_length: 3,
      validate_format: 3,
      unique_constraint: 2
    ]

  schema "user" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :created_at, :utc_datetime
    field :changed_at, :utc_datetime
  end

  @doc "Create a user changeset"
  def changeset(user, params) do
    user
    |> cast(params, [:name, :email, :password, :created_at, :changed_at])
    |> validate_required([:name, :email, :password, :created_at, :changed_at])
    |> validate_length(:name, min: 3)
    |> validate_length(:email, min: 3)
    |> validate_format(:email, ~r/.+@.+/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
