defmodule MonitorOtter.Models.UserTest do
  use ExUnit.Case
  alias MonitorOtter.Models.User

  test "valid changeset" do
    changeset =
      User.changeset(%User{}, %{
        name: "Jonas",
        email: "test@email.com",
        password: "test-password",
        created_at: ~U[2020-03-13T12:00:00Z],
        changed_at: ~U[2020-03-13T13:30:00Z]
      })

    assert changeset.valid?
    assert changeset.errors == []

    assert %{
             name: "Jonas",
             email: "test@email.com",
             password: _,
             created_at: ~U[2020-03-13T12:00:00Z],
             changed_at: ~U[2020-03-13T13:30:00Z]
           } = changeset.changes
  end

  test "missing fields" do
    changeset = User.changeset(%User{}, %{})

    refute changeset.valid?

    assert changeset.errors == [
             {:name, {"can't be blank", validation: :required}},
             {:email, {"can't be blank", validation: :required}},
             {:password, {"can't be blank", validation: :required}},
             {:created_at, {"can't be blank", validation: :required}},
             {:changed_at, {"can't be blank", validation: :required}}
           ]
  end

  test "invalid name" do
    changeset =
      User.changeset(%User{}, %{
        name: "sh",
        email: "test@email.com",
        password: "test-password",
        created_at: ~U[2020-03-13T12:00:00Z],
        changed_at: ~U[2020-03-13T13:30:00Z]
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:name,
              {"should be at least %{count} character(s)",
               count: 3, validation: :length, kind: :min, type: :string}}
           ]
  end

  test "invalid email" do
    changeset =
      User.changeset(%User{}, %{
        name: "Jonas",
        email: "test",
        password: "test-password",
        created_at: ~U[2020-03-13T12:00:00Z],
        changed_at: ~U[2020-03-13T13:30:00Z]
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:email, {"has invalid format", [validation: :format]}}
           ]
  end

  test "invalid password" do
    changeset =
      User.changeset(%User{}, %{
        name: "Jonas",
        email: "test@email.com",
        password: "short",
        created_at: ~U[2020-03-13T12:00:00Z],
        changed_at: ~U[2020-03-13T13:30:00Z]
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:password,
              {"should be at least %{count} character(s)",
               count: 6, validation: :length, kind: :min, type: :string}}
           ]
  end

  test "password is hashed" do
    changeset =
      User.changeset(%User{}, %{
        name: "Jonas",
        email: "test@email.com",
        password: "test-password",
        created_at: ~U[2020-03-13T12:00:00Z],
        changed_at: ~U[2020-03-13T13:30:00Z]
      })

    assert Bcrypt.verify_pass("test-password", changeset.changes.password)
  end
end
