defmodule MonitorOtter.DAO.UsersTest do
  use MonitorOtter.DataCase
  alias MonitorOtter.DAO.Users
  alias MonitorOtter.Models.User

  test "user is created" do
    start = System.os_time(:second)

    assert {:ok, %User{id: id}} =
             Users.create(%{name: "Jonas", email: "test@email.com", password: "test-password"})

    assert is_integer(id)

    assert [
             %User{
               name: "Jonas",
               email: "test@email.com",
               password: password,
               created_at: created,
               changed_at: changed
             }
           ] = Users.get_all()

    created = DateTime.to_unix(created, :second)
    changed = DateTime.to_unix(changed, :second)

    assert start <= created
    assert created == changed

    assert Bcrypt.verify_pass("test-password", password)
  end

  test "user with duplicate email is not created" do
    Users.create(%{name: "Jonas", email: "test@email.com", password: "test-password"})

    assert {:error, changeset} =
             Users.create(%{name: "Jonas 2", email: "test@email.com", password: "test-password"})

    refute changeset.valid?

    assert changeset.errors == [
             {:email,
              {"has already been taken", constraint: :unique, constraint_name: "user_email_index"}}
           ]
  end

  test "user is updated" do
    {:ok, %User{id: id}} =
      Users.create(%{name: "Jonas", email: "test@email.com", password: "test-password"})

    assert {:ok, _} =
             Users.update(id, %{
               name: "New name",
               email: "newemail@test.com",
               password: "new-password"
             })

    [%User{id: ^id, name: "New name", email: "newemail@test.com", password: new_pass}] =
      Users.get_all()

    refute Bcrypt.verify_pass("test-password", new_pass)
    assert Bcrypt.verify_pass("new-password", new_pass)
  end

  test "non-existent job is not updated" do
    assert {:error, :not_found} = Users.update(1, %{name: "new name"})
  end

  test "user is deleted" do
    {:ok, %User{id: id}} =
      Users.create(%{name: "Jonas", email: "test@email.com", password: "test-password"})

    assert {:ok, %User{}} = Users.delete(id)

    assert(Users.get_all() == [])
  end

  test "non-existent user is not deleted" do
    assert {:error, :not_found} = Users.delete(1)
  end

  test "password is checked if user exists" do
    Users.create(%{name: "Jonas", email: "test@email.com", password: "test-password"})
    assert Users.check_password("test@email.com", "test-password")
    refute Users.check_password("test@email.com", "bad-password")
  end

  test "password is checked if user doesn't exist" do
    refute Users.check_password("test@email.com", "test-password")
  end
end
