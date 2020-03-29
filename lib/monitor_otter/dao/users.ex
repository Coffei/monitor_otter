defmodule MonitorOtter.DAO.Users do
  @moduledoc """
  DAO for User entity

  Defines common CRUD functions for `MonitorOtter.Models.User`.
  """
  import Ecto.Query, only: [from: 2]
  alias MonitorOtter.Models.User
  alias MonitorOtter.Repo

  @doc """
  Returns all users.
  """
  def get_all do
    Repo.all(User)
  end

  @doc """
  Return user by its email.
  """
  def get_by_email(email) do
    query =
      from u in User,
        where: u.email == ^email,
        select: u

    Repo.one(query)
  end

  @doc """
  Create new user.
  """
  def create(user) do
    now = DateTime.utc_now()

    params =
      user
      |> Map.put(:created_at, now)
      |> Map.put(:changed_at, now)

    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update existing user.
  """
  def update(id, update) do
    case Repo.get(User, id) do
      %User{} = user ->
        params = Map.put(update, :changed_at, DateTime.utc_now())

        user
        |> User.changeset(params)
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Delete a user.
  """
  def delete(id) do
    case Repo.get(User, id) do
      %User{} = user -> Repo.delete(user)
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Check if email/password combination matches.
  """
  def check_password(email, password) do
    query =
      from u in User,
        where: u.email == ^email,
        select: u

    with %User{password: hashed_password} <- Repo.one(query) do
      Bcrypt.verify_pass(password, hashed_password)
    else
      _ -> false
    end
  end
end
