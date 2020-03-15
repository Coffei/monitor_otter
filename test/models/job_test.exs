defmodule MonitorOtter.Models.JobTest do
  use ExUnit.Case
  alias MonitorOtter.Models.Job

  test "valid changeset" do
    changeset =
      Job.changeset(%Job{}, %{
        name: "my cool job",
        enabled: true,
        url: "https://www.google.com",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    assert changeset.valid?
    assert changeset.errors == []

    changeset =
      Job.changeset(%Job{}, %{
        name: "my cool job",
        enabled: true,
        url: "https://www.google.com",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        last_state: %{some: :state},
        last_check_at: DateTime.utc_now(),
        last_check_change_at: DateTime.utc_now(),
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    assert changeset.valid?
    assert changeset.errors == []
  end

  test "missing fields" do
    changeset = Job.changeset(%Job{}, %{})

    refute changeset.valid?

    assert changeset.errors == [
             {:name, {"can't be blank", validation: :required}},
             {:enabled, {"can't be blank", validation: :required}},
             {:url, {"can't be blank", validation: :required}},
             {:checker_type, {"can't be blank", validation: :required}},
             {:checker_config, {"can't be blank", validation: :required}},
             {:notification_email, {"can't be blank", validation: :required}},
             {:created_at, {"can't be blank", validation: :required}},
             {:changed_at, {"can't be blank", validation: :required}}
           ]
  end

  test "invalid name" do
    changeset =
      Job.changeset(%Job{}, %{
        name: "sh",
        enabled: true,
        url: "https://www.google.com",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:name,
              {"should be at least %{count} character(s)",
               count: 3, validation: :length, kind: :min, type: :string}}
           ]

    changeset =
      Job.changeset(%Job{}, %{
        name: for(_ <- 1..257, do: "a", into: ""),
        enabled: true,
        url: "https://www.google.com",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:name,
              {"should be at most %{count} character(s)",
               count: 256, validation: :length, kind: :max, type: :string}}
           ]
  end

  test "invalid checker_type" do
    changeset =
      Job.changeset(%Job{}, %{
        name: "name",
        enabled: true,
        url: "https://www.google.com",
        checker_type: "invalid",
        checker_config: %{},
        notification_email: "test@email.com",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:checker_type, {"checker type is invalid", []}}
           ]
  end

  test "incorrect types" do
    changeset =
      Job.changeset(%Job{}, %{
        name: :bad_name,
        enabled: %{bad: :enabled},
        url: 123,
        checker_type: 123,
        checker_config: "configuration",
        notification_email: [],
        last_check_at: :bad_last_check_at,
        last_check_change_at: :bad_last_check_change_at,
        created_at: 123,
        changed_at: 456
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:name, {"is invalid", [type: :string, validation: :cast]}},
             {:enabled, {"is invalid", [type: :boolean, validation: :cast]}},
             {:url, {"is invalid", [type: :string, validation: :cast]}},
             {:checker_type, {"is invalid", [type: :string, validation: :cast]}},
             {:checker_config, {"is invalid", [type: :map, validation: :cast]}},
             {:notification_email, {"is invalid", [type: :string, validation: :cast]}},
             {:last_check_at, {"is invalid", [type: :utc_datetime, validation: :cast]}},
             {:last_check_change_at, {"is invalid", [type: :utc_datetime, validation: :cast]}},
             {:created_at, {"is invalid", [type: :utc_datetime, validation: :cast]}},
             {:changed_at, {"is invalid", [type: :utc_datetime, validation: :cast]}}
           ]
  end

  test "invalid url" do
    changeset =
      Job.changeset(%Job{}, %{
        name: "my cool job",
        enabled: true,
        url: "a",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test@email.com",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:url,
              {"should be at least %{count} character(s)",
               count: 3, validation: :length, kind: :min, type: :string}}
           ]
  end

  test "invalid notification email" do
    changeset =
      Job.changeset(%Job{}, %{
        name: "my cool job",
        enabled: true,
        url: "https://www.google.com",
        checker_type: "regex",
        checker_config: %{},
        notification_email: "test",
        created_at: DateTime.utc_now(),
        changed_at: DateTime.utc_now()
      })

    refute changeset.valid?

    assert changeset.errors == [
             {:notification_email, {"has invalid format", [validation: :format]}}
           ]
  end
end
